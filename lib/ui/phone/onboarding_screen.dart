import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'status_bar.dart';

const _kOnboardingDone = 'onboarding_done_v1';

/// True quand le joueur a déjà vu l'onboarding au moins une fois.
Future<bool> isOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  return p.getBool(_kOnboardingDone) ?? false;
}

/// Efface le flag — utilisé par Réglages > Reset partie.
Future<void> resetOnboarding() async {
  final p = await SharedPreferences.getInstance();
  await p.remove(_kOnboardingDone);
}

/// Onboarding 3 écrans — apparaît une seule fois au premier lancement.
/// Chaque écran est un faux lock screen avec un message de Shen qui
/// pose le ton (1re personne, ironie sèche, dignité).
///
/// L'utilisateur appuie sur « Continuer » → écran suivant → après le
/// 3e, on flag `onboarding_done` dans shared_preferences et on entre
/// dans le téléphone.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;

  Future<void> _markDone() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kOnboardingDone, true);
  }

  static const _steps = <_OnbStep>[
    _OnbStep(
      time: '06:30',
      date: 'vendredi 3 juin',
      title: 'Je m\'appelle Shen.',
      body:
          'Vingt-quatre ans, livreuse à vélo, fille unique. '
          'Maman tousse depuis trois nuits. '
          'L\'infirmière a dit : « Faites attention à ce qu\'elle vous dit. »',
      gradient: [Color(0xFF0A0E1F), Color(0xFF1A1E33)],
    ),
    _OnbStep(
      time: '06:32',
      date: 'vendredi 3 juin',
      title: 'Ce téléphone, c\'est moi.',
      body:
          'Tout passe par là — les SMS de Maman, les calculs, '
          'les carnets, les comptes. '
          'Tu me liras à travers ce que je tape et ce que je tais.',
      gradient: [Color(0xFF1F2937), Color(0xFF4A3A55)],
    ),
    _OnbStep(
      time: '06:34',
      date: 'vendredi 3 juin',
      title: 'Le compteur démarre maintenant.',
      body:
          'Dix-huit mille euros. Six semaines. '
          'Je n\'ai pas d\'autre choix que de tenir.\n\n'
          'Glisse pour commencer.',
      gradient: [Color(0xFF8FA9C2), Color(0xFFD6B98C)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: step.gradient,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const PhoneStatusBar(foreground: Colors.white),
            // Pad supplémentaire pour ne pas heurter la Dynamic Island
            // du device_frame iPad.
            const SizedBox(height: 36),
            Text(
              step.date.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.85),
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              step.time,
              style: GoogleFonts.inter(
                fontSize: 78,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                height: 1.0,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                step.title,
                style: GoogleFonts.crimsonPro(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                step.body,
                style: GoogleFonts.crimsonPro(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1.5,
                ),
              ),
            ),
            const Spacer(),
            // Indicateurs de pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (i) => Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: i == _step ? 1.0 : 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    if (_step < _steps.length - 1) {
                      setState(() => _step++);
                    } else {
                      await _markDone();
                      widget.onFinished();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.20),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _step < _steps.length - 1 ? 'Continuer' : 'Commencer',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnbStep {
  final String time;
  final String date;
  final String title;
  final String body;
  final List<Color> gradient;

  const _OnbStep({
    required this.time,
    required this.date,
    required this.title,
    required this.body,
    required this.gradient,
  });
}
