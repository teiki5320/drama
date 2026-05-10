import '../models/choice.dart';
import '../models/game_state.dart';
import '../models/shop_item.dart';
import 'ending_calculator.dart';

/// Pure functions that mutate GameState. No I/O, no Riverpod refs — easy
/// to unit-test and reason about.
class EconomyEngine {
  const EconomyEngine();

  static const int kMomTreatmentCost = 18000;
  static const int kMomDeadlineDay = 45;
  static const int kFinalDay = 112;

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

    return state.copyWith(
      argent: newArgent,
      mood: newMood,
      reputation: newReputation,
      followers: followersFromReputation(newReputation),
      lowMoodStreak: newStreak,
      choicesMade: mergedChoices,
      unlockedConversations: mergedConvos,
      isMomTreatmentPaid: newIsMomPaid,
    );
  }

  /// Tick of the daily simulation: passive income, then advance the day.
  /// Should be called *after* applyChoice when the player presses "Jour
  /// suivant".
  GameState advanceDay(GameState state) {
    final next = state.currentDay + 1;
    final income = passiveIncome(state.followers);

    final advanced = state.copyWith(
      currentDay: next,
      argent: state.argent + income,
    );

    // Check the "deadline maman" : if argent reaches 18 000€ before J45 and
    // not paid yet, mark as paid + bonus mood.
    if (!advanced.isMomTreatmentPaid &&
        advanced.argent >= kMomTreatmentCost &&
        advanced.currentDay <= kMomDeadlineDay + 1) {
      return advanced.copyWith(
        isMomTreatmentPaid: true,
        argent: advanced.argent - kMomTreatmentCost,
        mood: (advanced.mood + 2).clamp(0, 10),
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
    return state.copyWith(
      argent: state.argent - item.price,
      mood: (state.mood + item.moodGain).clamp(0, 10),
      reputation: newRep,
      followers: followersFromReputation(newRep),
      ownedItems: newOwned,
    );
  }

  /// Tagline shown on the Insta profile, by follower bracket. Cf. ROADMAP §4.3.
  String instaTagline(int followers) {
    if (followers >= 50000) return 'vraie influence';
    if (followers >= 25000) return 'influence locale';
    if (followers >= 10000) return 'communauté';
    return 'petite tribu';
  }
}
