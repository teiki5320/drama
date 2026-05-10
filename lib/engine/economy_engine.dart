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

    final newStreak = newMood <= 2 ? state.lowMoodStreak + 1 : 0;

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
        label: _truncate(option.text, 48),
        amount: option.argent,
      ));
    }

    return state.copyWith(
      argent: newArgent,
      mood: newMood,
      reputation: newReputation,
      followers: followersFromReputation(newReputation),
      lowMoodStreak: newStreak,
      choicesMade: mergedChoices,
      unlockedConversations: mergedConvos,
      isMomTreatmentPaid: newIsMomPaid,
      ledger: ledger,
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
      ledger: ledger,
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
          label: 'Traitement maman (Tenon)',
          amount: -kMomTreatmentCost,
        ));
      advanced = advanced.copyWith(
        isMomTreatmentPaid: true,
        argent: advanced.argent - kMomTreatmentCost,
        mood: (advanced.mood + 2).clamp(0, 10),
        ledger: updatedLedger,
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
      final post = InstaPost(
        id: 'shen_${item.id}_j${state.currentDay}',
        author: '@shen_y',
        day: state.currentDay,
        emoji: item.instaPostEmoji ?? item.emoji,
        caption: item.instaPostCaption ?? item.name,
        likes: _seededLikes(state.followers, state.currentDay, item.id),
        commentsCount:
            _seededComments(state.followers, state.currentDay, item.id),
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
      ledger: ledger,
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
      ledger: ledger,
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
      ledger: ledger,
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
}
