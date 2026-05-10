import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';

/// Persists GameState as a JSON string under a single key.
///
/// If a save becomes unreadable (schema change, corruption), the raw
/// content is moved to a timestamped backup key so it isn't lost
/// silently — handy for post-mortem if a user reports lost progress.
class GameStateRepository {
  static const String _key = 'gameState_v1';
  static const String _corruptedPrefix = 'gameState_v1_corrupted_';

  Future<GameState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return GameState.decode(raw);
    } catch (e, st) {
      debugPrint('GameStateRepository: save corrupted, preserving backup. $e');
      debugPrintStack(stackTrace: st);
      final ts = DateTime.now().millisecondsSinceEpoch;
      await prefs.setString('$_corruptedPrefix$ts', raw);
      await prefs.remove(_key);
      return null;
    }
  }

  Future<void> save(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state.encode());
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
