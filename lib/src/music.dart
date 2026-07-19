import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Un morceau de la playlist de Shen.
class Track {
  const Track(this.file, this.titre, this.sousTitre, {this.dispo = true});

  final String file;
  final String titre;
  final String sousTitre;

  /// Faux tant que le mp3 n'a pas été déposé dans assets/audio/.
  final bool dispo;
}

/// La playlist — les fichiers manquants s'affichent « à venir ».
const List<Track> kTracks = [
  Track('pluie_sur_belleville.mp3', 'Pluie sur Belleville',
      'Le thème de Shen'),
  Track('nuit_blanche.mp3', 'Nuit blanche', 'Les soirs de doute'),
  Track('fujian.mp3', 'Fujian', 'Les souvenirs de Chine'),
  Track('quarante_septieme_etage.mp3', '47ᵉ étage', 'L’univers Heng',
      dispo: false),
  Track('deux_sucres.mp3', 'Deux sucres', 'Camille', dispo: false),
];

/// Le lecteur : un seul morceau à la fois, en boucle, choix persistant.
class Music extends ChangeNotifier {
  Music._();

  static final Music instance = Music._();

  static const _kTrack = 'music_track';

  final AudioPlayer _player = AudioPlayer();
  SharedPreferences? _prefs;
  bool _ready = false;

  /// Le fichier du morceau choisi (null = silence).
  String? current;

  Future<void> init() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.35);
      _prefs = await SharedPreferences.getInstance();
      current = _prefs?.getString(_kTrack);
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  /// Relance le morceau choisi (au déverrouillage du téléphone).
  Future<void> autoStart() async {
    final c = current;
    if (!_ready || c == null) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$c'));
    } catch (_) {}
  }

  Future<void> play(String file) async {
    current = file;
    notifyListeners();
    await _prefs?.setString(_kTrack, file);
    if (!_ready) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$file'));
    } catch (_) {}
  }

  Future<void> stop() async {
    current = null;
    notifyListeners();
    await _prefs?.remove(_kTrack);
    if (!_ready) return;
    try {
      await _player.stop();
    } catch (_) {}
  }
}
