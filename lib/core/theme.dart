import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Visual identity for À Contre-Jour. Light-mode only, "papier crème" base
/// with warm accent. Cf. ROADMAP §6.2.
ThemeData buildAppTheme() {
  final TextTheme base = GoogleFonts.interTextTheme().apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  );

  // Headlines / titles use a warm serif (substitut Crimson Pro / New York).
  final TextTheme withSerif = base.copyWith(
    displayLarge: GoogleFonts.crimsonPro(
      textStyle: base.displayLarge,
      fontWeight: FontWeight.w600,
    ),
    displayMedium: GoogleFonts.crimsonPro(
      textStyle: base.displayMedium,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.crimsonPro(
      textStyle: base.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.crimsonPro(
      textStyle: base.headlineLarge,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.crimsonPro(
      textStyle: base.headlineMedium,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.crimsonPro(
      textStyle: base.headlineSmall,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.crimsonPro(
      textStyle: base.titleLarge,
      fontWeight: FontWeight.w600,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.paperCream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accentOrange,
      brightness: Brightness.light,
      primary: AppColors.accentOrange,
      onPrimary: Colors.white,
      surface: AppColors.paperCream,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: withSerif,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.paperCream,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.crimsonPro(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.paperCream,
      selectedItemColor: AppColors.accentOrange,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0x141A1A1A),
      thickness: 0.5,
      space: 0,
    ),
  );
}
