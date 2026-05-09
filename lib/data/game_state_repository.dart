import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';

/// Persists GameState as a JSON string under a single key.
class GameStateRepository {
  static const String _key = 'gameState_v1';

  Future<GameState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return GameState.decode(raw);
    } catch (_) {
      // Corrupt save — wipe and start fresh rather than crash.
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
