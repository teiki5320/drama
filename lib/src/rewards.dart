import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Un souvenir de la galerie, débloqué par le sudoku.
class Souvenir {
  const Souvenir(this.asset, this.titre);

  final String asset;
  final String titre;
}

/// Les souvenirs, dans l'ordre de déblocage — du décor vers l'intime.
const List<Souvenir> kSouvenirs = [
  Souvenir('assets/photos/lieux/pr_rizieres_coucher_soleil.webp',
      'Les rizières, un été.'),
  Souvenir('assets/photos/lieux/pr_chambre_valise_toits_chine.webp',
      'La chambre au-dessus des toits.'),
  Souvenir('assets/photos/lieux/pr_fleurs_iris_cour_fujian.webp',
      'La cour aux iris.'),
  Souvenir('assets/photos/quotidien/pr_the_plateau_gaiwan.webp',
      'Le Long Jing de Maman.'),
  Souvenir(
      'assets/photos/personnages/pr_femme_60aine_pivoines_fenetre_toits.webp',
      'Maman et ses pivoines. Toujours.'),
  Souvenir('assets/photos/quotidien/pr_album_photos_main_jade.webp',
      'L’album qu’on n’ouvre jamais en entier.'),
  Souvenir('assets/photos/personnages/pr_photo_famille_maison_pierre_2010.webp',
      'Mai 2010. La maison de pierre.'),
  Souvenir('assets/photos/personnages/pr_pere_et_shen_enfant.webp',
      'Papa. Avant tout ça.'),
];

/// Les fonds d'écran, débloqués par paliers (3, 6, 9 grilles).
const List<Souvenir> kWallpapers = [
  Souvenir('assets/photos/lieux/pr_feu_artifice_tour_nuit.webp',
      'Feu d’artifice'),
  Souvenir('assets/photos/lieux/pr_rue_asiatique_neons_nuit.webp', 'Néons'),
  Souvenir('assets/photos/lieux/pr_bureau_nuit_vue_skyline_neons.webp',
      'Skyline'),
];

/// Progression du joueur (grilles gagnées, fond d'écran choisi) — persistée.
class Rewards extends ChangeNotifier {
  Rewards._();

  static final Rewards instance = Rewards._();

  static const _kWins = 'sudoku_wins';
  static const _kWallpaper = 'wallpaper';

  SharedPreferences? _prefs;
  int wins = 0;
  String? wallpaper;

  Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      wins = _prefs?.getInt(_kWins) ?? 0;
      wallpaper = _prefs?.getString(_kWallpaper);
      notifyListeners();
    } catch (_) {
      // Sans persistance (tests), la progression vit en mémoire.
    }
  }

  int get souvenirsDebloques => min(wins, kSouvenirs.length);

  /// Le souvenir gagné par la dernière victoire (null si tous débloqués).
  Souvenir? get dernierSouvenir =>
      wins >= 1 && wins <= kSouvenirs.length ? kSouvenirs[wins - 1] : null;

  bool wallpaperDebloque(int i) => wins >= (i + 1) * 3;

  Future<void> addWin() async {
    wins++;
    notifyListeners();
    await _prefs?.setInt(_kWins, wins);
  }

  Future<void> setWallpaper(String? asset) async {
    wallpaper = asset;
    notifyListeners();
    if (asset == null) {
      await _prefs?.remove(_kWallpaper);
    } else {
      await _prefs?.setString(_kWallpaper, asset);
    }
  }
}
