import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// SFX one-shots utilisables sur un beat ACE.
///
/// Les fichiers sont sous `assets/audio/ace/`. Les WAV actuels sont
/// des placeholders générés (tick/click/impact synthétiques). À
/// remplacer par des SFX libres de droits quand on en aura.
enum AceSfx {
  tick, // frappe machine, joué à chaque caractère du typewriter
  advance, // tap qui fait avancer au beat suivant
  impact, // collision, portière qui claque, choc
  ring, // sonnerie téléphone
}

/// Audio ambient en boucle pour le beat courant.
enum AceAmbient {
  none,
  rain, // pluie Belleville / studio nuit
}

const Map<AceSfx, String> _sfxPath = {
  AceSfx.tick: 'audio/ace/tick.wav',
  AceSfx.advance: 'audio/ace/advance.wav',
  AceSfx.impact: 'audio/ace/impact.wav',
  AceSfx.ring: 'audio/ace/ring.wav',
};

const Map<AceAmbient, String?> _ambientPath = {
  AceAmbient.none: null,
  AceAmbient.rain: 'audio/ace/rain_loop.wav',
};

/// Service audio léger pour le mode ACE.
///
/// - SFX one-shots via un pool de [AudioPlayer] (4 max simultanés) pour
///   éviter qu'un nouveau son coupe le précédent.
/// - Ambiance en boucle via un player dédié.
/// - Volumes par défaut conservateurs (ticks très bas, advance modéré,
///   impact fort, ambient en fond).
class AceAudio {
  AceAudio._();
  static final AceAudio instance = AceAudio._();

  bool muted = false;
  bool _ambientEnabled = true;

  final List<AudioPlayer> _pool = [];
  int _next = 0;
  AudioPlayer? _ambient;
  AceAmbient _ambientKind = AceAmbient.none;

  Future<void> _ensurePool() async {
    if (_pool.isNotEmpty) return;
    for (var i = 0; i < 4; i++) {
      final p = AudioPlayer(playerId: 'ace_sfx_$i');
      await p.setReleaseMode(ReleaseMode.stop);
      _pool.add(p);
    }
  }

  Future<void> playSfx(AceSfx kind, {double volume = 1.0}) async {
    if (muted) return;
    final asset = _sfxPath[kind];
    if (asset == null) return;
    try {
      await _ensurePool();
      final player = _pool[_next % _pool.length];
      _next++;
      await player.stop();
      await player.setVolume(volume.clamp(0.0, 1.0));
      await player.play(AssetSource(asset));
    } catch (e, st) {
      // Ne jamais faire crasher l'écran à cause d'un son manquant.
      if (kDebugMode) {
        // ignore: avoid_print
        print('AceAudio.playSfx error: $e\n$st');
      }
    }
  }

  Future<void> setAmbient(AceAmbient kind) async {
    if (kind == _ambientKind) return;
    _ambientKind = kind;
    if (!_ambientEnabled || muted) {
      await _ambient?.stop();
      return;
    }
    final asset = _ambientPath[kind];
    if (asset == null) {
      await _ambient?.stop();
      return;
    }
    try {
      _ambient ??= AudioPlayer(playerId: 'ace_ambient');
      await _ambient!.setReleaseMode(ReleaseMode.loop);
      await _ambient!.setVolume(0.35);
      await _ambient!.play(AssetSource(asset));
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AceAudio.setAmbient error: $e');
      }
    }
  }

  Future<void> stopAll() async {
    await _ambient?.stop();
    for (final p in _pool) {
      await p.stop();
    }
  }

  void setAmbientEnabled(bool enabled) {
    _ambientEnabled = enabled;
    if (!enabled) _ambient?.stop();
  }
}
