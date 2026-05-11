import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';
import '../core/formatters.dart';

/// Small explainer dialog shown when the user taps a stat chip in the
/// sidebar. Centered card with emoji big, current value, body text and a
/// "compris" button.
class _StatPopup extends StatelessWidget {
  const _StatPopup({
    required this.emoji,
    required this.title,
    required this.bigValue,
    required this.body,
    this.bigValueColor,
  });

  final String emoji;
  final String title;
  final String bigValue;
  final String body;
  final Color? bigValueColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.paperCream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bigValue,
              style: GoogleFonts.crimsonPro(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: bigValueColor ?? AppColors.textPrimary,
                height: 1.0,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentOrange,
                ),
                child: const Text(
                  'Compris',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showDayStatPopup(BuildContext context, int day) {
  showDialog<void>(
    context: context,
    builder: (_) => _StatPopup(
      emoji: '📔',
      title: 'JOUR EN COURS',
      bigValue: 'J$day / 112',
      body:
          'Le drama dure 112 jours et a 5 fins possibles. La deadline Maman tombe à J45 : tu dois avoir réuni 18 000 € avant.',
    ),
  );
}

void showArgentStatPopup(BuildContext context, int argent) {
  showDialog<void>(
    context: context,
    builder: (_) => _StatPopup(
      emoji: '💰',
      title: 'ARGENT EN BANQUE',
      bigValue: formatMoney(argent),
      body:
          'Tu démarres avec 2 384 €. Trois sources : choix narratifs (contrat Heng, jobs), partenariats Insta (selon followers), investissements en bourse. Le détail jour par jour est dans Banque > Compte > Mouvements.',
    ),
  );
}

void showMoodStatPopup(BuildContext context, int mood) {
  final color = mood >= 6
      ? AppColors.positive
      : (mood <= 2 ? AppColors.negative : AppColors.accentOrange);
  showDialog<void>(
    context: context,
    builder: (_) => _StatPopup(
      emoji: '😊',
      title: 'MOOD',
      bigValue: '$mood / 10',
      bigValueColor: color,
      body:
          'L\'humeur de Shen, de 0 à 10. À 2 ou moins, des choix vertueux se ferment. À 6+, elle accède aux items "mode" et "voyage". Repas, sommeil, petits plaisirs font remonter.',
    ),
  );
}

void showReputationStatPopup(BuildContext context, int reputation, int followers) {
  showDialog<void>(
    context: context,
    builder: (_) => _StatPopup(
      emoji: '⭐',
      title: 'RÉPUTATION',
      bigValue: '★ $reputation',
      body:
          'L\'influence sociale de Shen.\n\n1 ★ ≈ 1 000 abonnés Insta. Tu as actuellement $followers abonnés.\n\nPlus d\'abonnés = plus de partenariats payés chaque jour. La réputation débloque aussi certains items du shop.',
    ),
  );
}
