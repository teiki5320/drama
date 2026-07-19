import 'package:audioplayers/audioplayers.dart';

/// Les bruits de la messagerie — trois sons courts synthétisés maison
/// (aucun son d'un autre OS n'est copié).
class Sfx {
  static final Map<String, AudioPlayer> _players = {};
  static const Map<String, String> _sources = {
    'recu': 'audio/sfx_recu.wav',
    'envoye': 'audio/sfx_envoye.wav',
    'banniere': 'audio/sfx_banniere.wav',
  };
  static bool _ready = false;

  static Future<void> init() async {
    try {
      for (final e in _sources.entries) {
        final p = AudioPlayer();
        await p.setPlayerMode(PlayerMode.lowLatency);
        await p.setVolume(0.5);
        _players[e.key] = p;
      }
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static void play(String kind) {
    if (!_ready) return;
    final p = _players[kind];
    final src = _sources[kind];
    if (p == null || src == null) return;
    p.stop().then((_) => p.play(AssetSource(src))).catchError((_) {});
  }
}
