import 'package:flutter/material.dart';

import '../models/phone_state.dart';

/// Palette de couleurs qui change selon l'heure du jeu (skin time-of-day).
class PhonePalette {
  final Color wallpaperTop;
  final Color wallpaperBottom;
  final Color statusBarFg; // texte de la status bar
  final Color homeOverlay; // léger voile sur le home pour ambiance
  final Brightness brightness;

  const PhonePalette({
    required this.wallpaperTop,
    required this.wallpaperBottom,
    required this.statusBarFg,
    required this.homeOverlay,
    required this.brightness,
  });

  static PhonePalette forBand(TimeOfDayBand b) {
    switch (b) {
      case TimeOfDayBand.matin:
        // 6h-9h : ciel pâle gris-bleu, encore frais
        return const PhonePalette(
          wallpaperTop: Color(0xFF8FA9C2),
          wallpaperBottom: Color(0xFFD6B98C),
          statusBarFg: Colors.white,
          homeOverlay: Color(0x14000000),
          brightness: Brightness.dark,
        );
      case TimeOfDayBand.jour:
        // 9h-12h : journée pleine, ciel plus profond
        return const PhonePalette(
          wallpaperTop: Color(0xFF6E94B5),
          wallpaperBottom: Color(0xFFAEC4D8),
          statusBarFg: Colors.white,
          homeOverlay: Color(0x14000000),
          brightness: Brightness.dark,
        );
      case TimeOfDayBand.midi:
        // 12h-17h : lumière chaude saturée
        return const PhonePalette(
          wallpaperTop: Color(0xFFE8AC65),
          wallpaperBottom: Color(0xFFF2C68A),
          statusBarFg: Colors.white,
          homeOverlay: Color(0x14000000),
          brightness: Brightness.dark,
        );
      case TimeOfDayBand.couchant:
        // 17h-20h : orange rose
        return const PhonePalette(
          wallpaperTop: Color(0xFFE89B7F),
          wallpaperBottom: Color(0xFFFCC9A1),
          statusBarFg: Colors.white,
          homeOverlay: Color(0x14000000),
          brightness: Brightness.dark,
        );
      case TimeOfDayBand.soir:
        // 20h-23h : bleu nuit chaud
        return const PhonePalette(
          wallpaperTop: Color(0xFF1E2A4A),
          wallpaperBottom: Color(0xFF4A3A55),
          statusBarFg: Colors.white,
          homeOverlay: Color(0x22000000),
          brightness: Brightness.dark,
        );
      case TimeOfDayBand.nuit:
        // 23h-6h : nuit profonde
        return const PhonePalette(
          wallpaperTop: Color(0xFF0A0E1F),
          wallpaperBottom: Color(0xFF1A1E33),
          statusBarFg: Colors.white,
          homeOverlay: Color(0x33000000),
          brightness: Brightness.dark,
        );
    }
  }
}
