import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Limite réelle de swipes par jour gameworld. L'ancien « 50/jour » était
/// fictif : état de widget remis à zéro à chaque ouverture, deck de 11
/// cartes — la limite était inatteignable.
const int kSwipesParJour = 15;

/// État persistant du feed Tinder : compteur de swipes par jour, cartes
/// déjà consommées (le deck ne se rejoue plus à chaque ouverture) et gags
/// one-shot.
@immutable
class TinderState {
  final int swipesUsed;
  final int lastSwipeDay;
  final Set<String> consumedCardIds;

  const TinderState({
    this.swipesUsed = 0,
    this.lastSwipeDay = 0,
    this.consumedCardIds = const {},
  });

  int remaining(int day) =>
      day == lastSwipeDay ? (kSwipesParJour - swipesUsed).clamp(0, kSwipesParJour) : kSwipesParJour;

  TinderState copyWith({
    int? swipesUsed,
    int? lastSwipeDay,
    Set<String>? consumedCardIds,
  }) =>
      TinderState(
        swipesUsed: swipesUsed ?? this.swipesUsed,
        lastSwipeDay: lastSwipeDay ?? this.lastSwipeDay,
        consumedCardIds: consumedCardIds ?? this.consumedCardIds,
      );

  Map<String, dynamic> toJson() => {
        'swipesUsed': swipesUsed,
        'lastSwipeDay': lastSwipeDay,
        'consumed': consumedCardIds.toList(),
      };

  static TinderState fromJson(Map<String, dynamic> j) => TinderState(
        swipesUsed: j['swipesUsed'] as int? ?? 0,
        lastSwipeDay: j['lastSwipeDay'] as int? ?? 0,
        consumedCardIds:
            ((j['consumed'] as List?) ?? []).map((e) => e as String).toSet(),
      );
}

final tinderStateProvider =
    StateNotifierProvider<TinderStateNotifier, TinderState>(
  (ref) => TinderStateNotifier(),
);

class TinderStateNotifier extends StateNotifier<TinderState> {
  static const _kKey = 'tinder_state_v1';

  TinderStateNotifier() : super(const TinderState()) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null) return;
      state = TinderState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kKey, jsonEncode(state.toJson()));
    } catch (_) {}
  }

  /// Enregistre un swipe : nouveau jour = compteur remis à zéro ;
  /// la carte quitte définitivement le deck.
  void recordSwipe(int day, String cardId) {
    final sameDay = day == state.lastSwipeDay;
    state = state.copyWith(
      swipesUsed: sameDay ? state.swipesUsed + 1 : 1,
      lastSwipeDay: day,
      consumedCardIds: {...state.consumedCardIds, cardId},
    );
    _save();
  }

  /// Reset (Réglages > Réinitialiser la partie).
  Future<void> reset() async {
    state = const TinderState();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kKey);
    } catch (_) {}
  }
}
