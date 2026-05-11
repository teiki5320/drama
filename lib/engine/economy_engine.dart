import 'dart:math';

import '../models/choice.dart';
import '../models/game_state.dart';
import '../models/insta_post.dart';
import '../models/investment.dart';
import '../models/ledger_entry.dart';
import '../models/shop_item.dart';
import 'ending_calculator.dart';

/// Pure functions that mutate GameState. No I/O, no Riverpod refs — easy
/// to unit-test and reason about.
class EconomyEngine {
  const EconomyEngine();

  static const int kMomTreatmentCost = 18000;
  static const int kMomDeadlineDay = 45;
  static const int kFinalDay = 112;
  static const int kMaxPriceHistory = 60;

  /// Dernier jour pour lequel le scénario contient une entrée. Au-delà,
  /// `advanceDay` clamp au lieu d'incrémenter — évite que le compteur
  /// monte vers 112 dans le vide. À mettre à jour quand on étend le
  /// scénario au-delà de la semaine 2.
  static const int kMaxStoryDay = 14;

  /// Plafond du journal de transactions (Banque > Compte > Mouvements).
  /// On ne garde que les N plus récentes pour éviter que la sauvegarde
  /// gonfle sans limite sur une partie longue.
  static const int kMaxLedgerEntries = 80;

  /// Nombre de jours d'historique synthétique à fabriquer au premier
  /// lancement, pour que les sparklines aient déjà du contenu et que le
  /// graphique du patrimoine ne soit pas vide à J1.
  static const int kBootstrapHistoryDays = 30;

  static List<LedgerEntry> _capLedger(List<LedgerEntry> ledger) {
    if (ledger.length <= kMaxLedgerEntries) return ledger;
    return ledger.sublist(ledger.length - kMaxLedgerEntries);
  }

  /// Au premier lancement (ou après reset), si l'historique des prix
  /// est vide, on fabrique un passé synthétique de
  /// `kBootstrapHistoryDays` jours pour chaque action. Les cours
  /// drift de ±2% par jour, déterministe par ticker (seed = hash), et
  /// se terminent **exactement** sur le prix du catalogue.
  ///
  /// On seed aussi `wealthHistory` à plat (le joueur n'a pas trade
  /// avant J1) — juste pour que le graphique du Compte ne soit pas
  /// désespérément vide.
  GameState bootstrapHistory(GameState state, List<Investment> investments) {
    if (state.stockPriceHistory.isNotEmpty) return state;

    final newPriceHistory = <String, List<double>>{};
    final newCurrentPrices = <String, double>{};
    for (final inv in investments) {
      final rng = Random(inv.ticker.hashCode);
      final prices = <double>[inv.price.toDouble()];
      for (var i = 0; i < kBootstrapHistoryDays - 1; i++) {
        final noise = (rng.nextDouble() * 4 - 2) / 100; // -2% .. +2%
        // On remonte le temps : price[i-1] = price[i] / (1 + noise)
        final earlier = prices.first / (1 + noise);
        prices.insert(0, double.parse(earlier.toStringAsFixed(2)));
      }
      newPriceHistory[inv.ticker] = prices;
      newCurrentPrices[inv.ticker] = prices.last;
    }

    // wealthHistory : kBootstrapHistoryDays copies de l'argent courant
    // (pas de variations puisque rien n'a été tradé).
    final newWealthHistory = List<int>.filled(
      kBootstrapHistoryDays,
      state.argent,
      growable: true,
    );

    return state.copyWith(
      stockPriceHistory: newPriceHistory,
      stockCurrentPrices: newCurrentPrices,
      wealthHistory: newWealthHistory,
    );
  }

  /// Daily passive income from followers. Cf. ROADMAP §4.3.
  int passiveIncome(int followers) {
    if (followers >= 50000) return 200;
    if (followers >= 25000) return 80;
    if (followers >= 10000) return 25;
    if (followers >= 1000) return 5;
    return 0;
  }

  /// Followers derive from reputation (★1 = 1 000 abonnés). Cf. ROADMAP §4.2.
  int followersFromReputation(int reputation) {
    final base = 712; // starting tribe
    return base + (reputation * 1000);
  }

  /// Apply a choice option to the current state. Returns the new state with
  /// deltas applied, choice recorded, mood clamped to 0..10, low-mood streak
  /// updated, and the day advanced by 1.
  GameState applyChoice({
    required GameState state,
    required int dayId,
    required int optionIndex,
    required ChoiceOption option,
  }) {
    final newMood = (state.mood + option.mood).clamp(0, 10);
    final newReputation = (state.reputation + option.reputation)
        .clamp(0, 1 << 30); // no negative reputation
    final newArgent = state.argent + option.argent;
    final newFollowers = followersFromReputation(newReputation);
    final followersDelta = newFollowers - state.followers;

    final mergedChoices = Map<int, int>.from(state.choicesMade)
      ..[dayId] = optionIndex;

    final mergedConvos = option.unlocks == null
        ? state.unlockedConversations
        : <String>{
            ...state.unlockedConversations,
            ...option.unlocks!,
          }.toList(growable: false);

    final flagsToSet = option.setsFlags ?? const <String>[];
    final newIsMomPaid = flagsToSet.contains('isMomTreatmentPaid')
        ? true
        : state.isMomTreatmentPaid;

    final ledger = List<LedgerEntry>.from(state.ledger);
    if (option.argent != 0) {
      ledger.add(LedgerEntry(
        day: dayId,
        kind: option.argent > 0
            ? LedgerEntryKind.choiceIncome
            : LedgerEntryKind.choiceExpense,
        label: option.ledgerLabel ?? _truncate(option.text, 48),
        amount: option.argent,
      ));
    }

    return state.copyWith(
      argent: newArgent,
      mood: newMood,
      reputation: newReputation,
      followers: newFollowers,
      followersDeltaToday:
          state.followersDeltaToday + followersDelta,
      choicesMade: mergedChoices,
      unlockedConversations: mergedConvos,
      isMomTreatmentPaid: newIsMomPaid,
      ledger: _capLedger(ledger),
    );
  }

  static String _truncate(String s, int max) {
    if (s.length <= max) return s;
    return '${s.substring(0, max - 1)}…';
  }

  /// Tick of the daily simulation: passive income, then advance the day.
  /// Should be called *after* applyChoice when the player presses "Jour
  /// suivant".
  GameState advanceDay(GameState state, {List<Investment>? investments}) {
    // Plafond fin d'épisode : on autorise un seul cran après le dernier
    // jour scénarisé pour basculer sur l'écran "À suivre", puis on bloque.
    if (state.currentDay > kMaxStoryDay) {
      return state;
    }
    final next = state.currentDay + 1;
    final income = passiveIncome(state.followers);

    final ledger = List<LedgerEntry>.from(state.ledger);
    if (income > 0) {
      ledger.add(LedgerEntry(
        day: next,
        kind: LedgerEntryKind.passiveIncome,
        label: 'Partenariats Insta',
        amount: income,
      ));
    }

    var advanced = state.copyWith(
      currentDay: next,
      argent: state.argent + income,
      followersDeltaToday: 0, // reset au passage à un nouveau jour
      ledger: _capLedger(ledger),
    );

    // Check the "deadline maman" : if argent reaches 18 000€ before J45 and
    // not paid yet, mark as paid + bonus mood.
    if (!advanced.isMomTreatmentPaid &&
        advanced.argent >= kMomTreatmentCost &&
        advanced.currentDay <= kMomDeadlineDay + 1) {
      final updatedLedger = List<LedgerEntry>.from(advanced.ledger)
        ..add(LedgerEntry(
          day: advanced.currentDay,
          kind: LedgerEntryKind.momTreatment,
          label: 'Traitement de Maman (Tenon)',
          amount: -kMomTreatmentCost,
        ));
      advanced = advanced.copyWith(
        isMomTreatmentPaid: true,
        argent: advanced.argent - kMomTreatmentCost,
        mood: (advanced.mood + 2).clamp(0, 10),
        ledger: _capLedger(updatedLedger),
      );
    }

    // Apply daily ±2% noise + scripted triggers (§4.8) on the new day.
    if (investments != null && investments.isNotEmpty) {
      final newPrices = tickPrices(
        previousPrices: advanced.stockCurrentPrices,
        investments: investments,
        day: advanced.currentDay,
      );
      final newHistory = <String, List<double>>{};
      for (final inv in investments) {
        final prev = advanced.stockPriceHistory[inv.ticker] ?? const <double>[];
        final next = [...prev, newPrices[inv.ticker]!];
        if (next.length > kMaxPriceHistory) {
          next.removeRange(0, next.length - kMaxPriceHistory);
        }
        newHistory[inv.ticker] = next;
      }
      advanced = advanced.copyWith(
        stockCurrentPrices: newPrices,
        stockPriceHistory: newHistory,
      );
    }

    // Snapshot du patrimoine total (argent + portefeuille) à la fin du tick.
    var portfolio = 0.0;
    if (investments != null) {
      advanced.stockHoldings.forEach((ticker, qty) {
        final price = advanced.stockCurrentPrices[ticker] ??
            investments.firstWhere(
              (i) => i.ticker == ticker,
              orElse: () => Investment(
                ticker: ticker,
                name: '',
                sector: '',
                price: 0,
                description: '',
              ),
            ).price.toDouble();
        portfolio += price * qty;
      });
    }
    final wealthSnapshot = advanced.argent + portfolio.round();
    final newWealth = [...advanced.wealthHistory, wealthSnapshot];
    if (newWealth.length > kMaxPriceHistory) {
      newWealth.removeRange(0, newWealth.length - kMaxPriceHistory);
    }
    advanced = advanced.copyWith(wealthHistory: newWealth);

    // Branche deuil §4.6 : si la deadline maman est passée et le
    // traitement n'a jamais été payé, on bascule directement sur l'ending
    // tragique sans attendre J112.
    if (advanced.currentDay > kMomDeadlineDay && !advanced.isMomTreatmentPaid) {
      return advanced.copyWith(ending: 'le_deuil_et_la_route');
    }

    // Auto-compute final ending on the last day.
    if (advanced.currentDay >= kFinalDay) {
      return advanced.copyWith(ending: computeEnding(advanced));
    }
    return advanced;
  }

  /// Whether a shop item can be purchased given the current state.
  ({bool ok, String? reason}) canBuy(GameState state, ShopItem item) {
    if (state.argent < item.price) {
      return (ok: false, reason: 'Trop cher');
    }
    if (state.mood < item.requiredMood) {
      return (
        ok: false,
        reason: 'Mood ≥ ${item.requiredMood} requis',
      );
    }
    if (state.reputation < item.requiredReputation) {
      return (
        ok: false,
        reason: '⭐ ${item.requiredReputation} requis',
      );
    }
    if (state.ownedItems.contains(item.id)) {
      return (ok: false, reason: 'Déjà possédé');
    }
    return (ok: true, reason: null);
  }

  GameState buy(GameState state, ShopItem item) {
    final newOwned = List<String>.from(state.ownedItems)..add(item.id);
    final newRep = (state.reputation + item.reputationGain)
        .clamp(0, 1 << 30);

    var newPosts = state.generatedInstaPosts;
    if (item.generatesInstaPost) {
      final commentsCount =
          _seededComments(state.followers, state.currentDay, item.id);
      final post = InstaPost(
        id: 'shen_${item.id}_j${state.currentDay}',
        author: '@shen_y',
        day: state.currentDay,
        emoji: item.instaPostEmoji ?? item.emoji,
        caption: item.instaPostCaption ?? item.name,
        likes: _seededLikes(state.followers, state.currentDay, item.id),
        commentsCount: commentsCount,
        topComments: _seededTopComments(item.id, commentsCount),
      );
      newPosts = [...state.generatedInstaPosts, post];
    }

    final ledger = List<LedgerEntry>.from(state.ledger)
      ..add(LedgerEntry(
        day: state.currentDay,
        kind: LedgerEntryKind.shopPurchase,
        label: '${item.emoji} ${item.name}',
        amount: -item.price,
      ));

    return state.copyWith(
      argent: state.argent - item.price,
      mood: (state.mood + item.moodGain).clamp(0, 10),
      reputation: newRep,
      followers: followersFromReputation(newRep),
      ownedItems: newOwned,
      generatedInstaPosts: newPosts,
      ledger: _capLedger(ledger),
    );
  }

  /// Tagline shown on the Insta profile, by follower bracket. Cf. ROADMAP §4.3.
  String instaTagline(int followers) {
    if (followers >= 50000) return 'vraie influence';
    if (followers >= 25000) return 'influence locale';
    if (followers >= 10000) return 'communauté';
    return 'petite tribu';
  }

  // --- Investments ----------------------------------------------------------

  /// Current price for a ticker: state override (after ticks/triggers) if
  /// present, otherwise the base price from the catalog.
  double currentPrice(GameState state, Investment inv) {
    return state.stockCurrentPrices[inv.ticker] ?? inv.price;
  }

  ({bool ok, String? reason}) canBuyStock(
      GameState state, Investment inv, int qty) {
    if (qty <= 0) return (ok: false, reason: 'Quantité invalide');
    if (inv.unlockedAtDay != null && state.currentDay < inv.unlockedAtDay!) {
      return (ok: false, reason: 'Disponible J${inv.unlockedAtDay}');
    }
    final price = currentPrice(state, inv);
    final cost = (price * qty).round();
    if (state.argent < cost) return (ok: false, reason: 'Trop cher');
    return (ok: true, reason: null);
  }

  GameState buyStock(GameState state, Investment inv, int qty) {
    final price = currentPrice(state, inv);
    final cost = (price * qty).round();

    final prevQty = state.stockHoldings[inv.ticker] ?? 0;
    final prevAvg = state.stockAvgCost[inv.ticker] ?? 0.0;
    final newQty = prevQty + qty;
    final newAvg =
        ((prevAvg * prevQty) + (price * qty)) / newQty;

    final newHoldings = Map<String, int>.from(state.stockHoldings)
      ..[inv.ticker] = newQty;
    final newAvgCost = Map<String, double>.from(state.stockAvgCost)
      ..[inv.ticker] = newAvg;

    final ledger = List<LedgerEntry>.from(state.ledger)
      ..add(LedgerEntry(
        day: state.currentDay,
        kind: LedgerEntryKind.stockBuy,
        label: 'Achat $qty × ${inv.ticker}',
        amount: -cost,
      ));

    return state.copyWith(
      argent: state.argent - cost,
      stockHoldings: newHoldings,
      stockAvgCost: newAvgCost,
      ledger: _capLedger(ledger),
    );
  }

  ({bool ok, String? reason}) canSellStock(
      GameState state, String ticker, int qty) {
    final owned = state.stockHoldings[ticker] ?? 0;
    if (qty <= 0) return (ok: false, reason: 'Quantité invalide');
    if (owned < qty) return (ok: false, reason: 'Quantité insuffisante');
    return (ok: true, reason: null);
  }

  GameState sellStock(GameState state, Investment inv, int qty) {
    final price = currentPrice(state, inv);
    final proceeds = (price * qty).round();

    final prevQty = state.stockHoldings[inv.ticker] ?? 0;
    final newQty = prevQty - qty;

    final newHoldings = Map<String, int>.from(state.stockHoldings);
    final newAvgCost = Map<String, double>.from(state.stockAvgCost);
    if (newQty <= 0) {
      newHoldings.remove(inv.ticker);
      newAvgCost.remove(inv.ticker);
    } else {
      newHoldings[inv.ticker] = newQty;
      // avg cost unchanged on partial sell
    }

    final ledger = List<LedgerEntry>.from(state.ledger)
      ..add(LedgerEntry(
        day: state.currentDay,
        kind: LedgerEntryKind.stockSell,
        label: 'Vente $qty × ${inv.ticker}',
        amount: proceeds,
      ));

    return state.copyWith(
      argent: state.argent + proceeds,
      stockHoldings: newHoldings,
      stockAvgCost: newAvgCost,
      ledger: _capLedger(ledger),
    );
  }

  /// Returns the new currentPrices map after one day's tick: ±2% deterministic
  /// noise (seeded by day so the same day produces the same prices on reload),
  /// then any scripted trigger from §4.8 stacked on top.
  Map<String, double> tickPrices({
    required Map<String, double> previousPrices,
    required List<Investment> investments,
    required int day,
  }) {
    final out = <String, double>{};
    for (final inv in investments) {
      final base = previousPrices[inv.ticker] ?? inv.price;
      final rng = Random(day * 1000 + inv.ticker.hashCode);
      final noise = (rng.nextDouble() * 4 - 2) / 100; // -2% .. +2%
      var next = base * (1 + noise);
      final trig = scriptedDelta(day, inv.ticker);
      if (trig != null) next = next * (1 + trig);
      // Floor at 1€ to avoid runaway zeros.
      out[inv.ticker] = next < 1 ? 1 : double.parse(next.toStringAsFixed(2));
    }
    return out;
  }

  /// ROADMAP §4.8 narrative triggers on top of the ±2% daily noise.
  /// J98 BDE = ancien NCB renommé après refonte du catalogue.
  static double? scriptedDelta(int day, String ticker) {
    if (day == 35 && ticker == 'HENG') return 0.12;
    if (day == 52 && ticker == 'HENG') return -0.18;
    if (day == 76 && ticker == 'HAN') return 0.35;
    if (day == 98 && ticker == 'BDE') return -0.22;
    return null;
  }

  // Cosmetic numbers for generated insta posts. Deterministic per day+id so the
  // same post always shows the same counts.
  int _seededLikes(int followers, int day, String itemId) {
    final rng = Random(day * 31 + itemId.hashCode);
    final base = (followers * 0.07).round();
    return base + rng.nextInt(40);
  }

  int _seededComments(int followers, int day, String itemId) {
    final rng = Random(day * 7 + itemId.hashCode);
    return 1 + rng.nextInt(8);
  }

  List<InstaComment> _seededTopComments(String itemId, int commentsCount) {
    if (commentsCount == 0) return const [];
    // Camille comments on every shop-generated post — best friend, always there.
    // Cycle through a small pool of canonical reactions, picked by id hash for
    // determinism.
    final camillePool = <String>[
      'OUI ENFIN tu te fais plaisir 🤍',
      "tu vas me faire pleurer là, t'as bien mérité",
      "je viens voir ça ce soir, j'apporte le thé",
      "la photo est canon, t'es canon",
      'ça vaut tous les croissants du monde',
    ];
    final idx = itemId.hashCode.abs() % camillePool.length;
    final out = <InstaComment>[
      InstaComment(author: '@camille_rx', content: camillePool[idx]),
    ];
    if (commentsCount > 1) {
      out.add(const InstaComment(
        author: '@elise_ladroit',
        content: 'tellement contente pour toi 🥺',
      ));
    }
    return out;
  }
}
