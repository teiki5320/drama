import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interactions Instagram de Shen — likes, posts masqués, stories et
/// reels vus, tag retiré. Persisté en autonome dans shared_preferences
/// (clé `instagram_state_v1`) : avant ça, tout vivait dans des Sets
/// locaux du widget et se réinitialisait à chaque réouverture de l'app.
@immutable
class InstagramState {
  final Set<String> liked;
  final Set<String> hidden;
  final Set<String> viewedStories;
  final Set<String> viewedReels;
  final bool tagRetire;

  const InstagramState({
    this.liked = const {},
    this.hidden = const {},
    this.viewedStories = const {},
    this.viewedReels = const {},
    this.tagRetire = false,
  });

  InstagramState copyWith({
    Set<String>? liked,
    Set<String>? hidden,
    Set<String>? viewedStories,
    Set<String>? viewedReels,
    bool? tagRetire,
  }) =>
      InstagramState(
        liked: liked ?? this.liked,
        hidden: hidden ?? this.hidden,
        viewedStories: viewedStories ?? this.viewedStories,
        viewedReels: viewedReels ?? this.viewedReels,
        tagRetire: tagRetire ?? this.tagRetire,
      );

  Map<String, dynamic> toJson() => {
        'liked': liked.toList(),
        'hidden': hidden.toList(),
        'viewedStories': viewedStories.toList(),
        'viewedReels': viewedReels.toList(),
        'tagRetire': tagRetire,
      };

  static InstagramState fromJson(Map<String, dynamic> j) => InstagramState(
        liked: ((j['liked'] as List<dynamic>?) ?? [])
            .map((e) => e as String)
            .toSet(),
        hidden: ((j['hidden'] as List<dynamic>?) ?? [])
            .map((e) => e as String)
            .toSet(),
        viewedStories: ((j['viewedStories'] as List<dynamic>?) ?? [])
            .map((e) => e as String)
            .toSet(),
        viewedReels: ((j['viewedReels'] as List<dynamic>?) ?? [])
            .map((e) => e as String)
            .toSet(),
        tagRetire: j['tagRetire'] as bool? ?? false,
      );
}

final instagramStateProvider =
    StateNotifierProvider<InstagramStateNotifier, InstagramState>(
  (ref) => InstagramStateNotifier(),
);

class InstagramStateNotifier extends StateNotifier<InstagramState> {
  static const _kKey = 'instagram_state_v1';

  InstagramStateNotifier() : super(const InstagramState()) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null) return;
      state =
          InstagramState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Save corrompue : on repart de zéro sans casser le boot.
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kKey, jsonEncode(state.toJson()));
    } catch (_) {}
  }

  void toggleLike(String postId) {
    final liked = {...state.liked};
    if (!liked.remove(postId)) liked.add(postId);
    state = state.copyWith(liked: liked);
    _save();
  }

  void hide(String postId) {
    state = state.copyWith(hidden: {...state.hidden, postId});
    _save();
  }

  void viewStory(String storyId) {
    state = state.copyWith(viewedStories: {...state.viewedStories, storyId});
    _save();
  }

  void viewReel(String reelId) {
    state = state.copyWith(viewedReels: {...state.viewedReels, reelId});
    _save();
  }

  void retireTag() {
    state = state.copyWith(tagRetire: true);
    _save();
  }

  /// Reset (Réglages > Réinitialiser la partie).
  Future<void> reset() async {
    state = const InstagramState();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kKey);
    } catch (_) {}
  }
}
