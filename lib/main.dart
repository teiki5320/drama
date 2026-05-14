import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Placeholder build pendant la refonte du projet en version téléphone.
/// L'ancienne app (carnet + ACE + 4 onglets) a été retirée le 14 mai
/// 2026. La nouvelle architecture sera reconstruite depuis le repo
/// nettoyé (`ROADMAP.md` histoire + `assets/data/*.json`).
void main() => runApp(const ComingSoonApp());

class ComingSoonApp extends StatelessWidget {
  const ComingSoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFBF7EF)),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'À Contre-Jour',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '逆光',
                    style: GoogleFonts.crimsonPro(
                      fontSize: 22,
                      color: const Color(0xFF6B6B6B),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Refonte en cours.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B6B6B),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Le drama revient bientôt.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B6B6B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
