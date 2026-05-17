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

/// Onboarding 3 écrans façon page de livre — palette monochrome
/// blanc/marine, pas d'accent jaune. Bouton custom (pas de TextButton
/// pour éviter l'iOS Underline Buttons).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _step = 0;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      if (mounted) setState(() => _page = _ctrl.page ?? 0);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _markDone() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kOnboardingDone, true);
  }

  static const _steps = <_OnbStep>[
    _OnbStep(
      chapter: 'I',
      title: 'Avant la lumière',
      epigraph:
          'Maman tousse depuis trois nuits.\n'
          'L\'infirmière a dit : « Faites attention à ce qu\'elle vous dit. »',
      attribution: 'Shen, vingt-quatre ans, livreuse à vélo',
      gradient: [Color(0xFF0A0E1F), Color(0xFF14213D), Color(0xFF1F2937)],
    ),
    _OnbStep(
      chapter: 'II',
      title: 'Ce téléphone',
      epigraph:
          'Tout passe par là.\n'
          'Les SMS de Maman, les calculs, les carnets, les comptes —\n'
          'au fur et à mesure que la vie s\'ouvre.\n'
          'Tu me liras à travers ce que je tape — et ce que je tais.',
      attribution: 'Mode d\'emploi',
      gradient: [Color(0xFF14213D), Color(0xFF1F2937), Color(0xFF2A2E3F)],
    ),
    _OnbStep(
      chapter: 'III',
      title: 'Le compteur',
      epigraph:
          'Dix-huit mille euros.\n'
          'Six semaines.\n'
          'Quarante-deux jours.',
      attribution: 'À partir de maintenant.',
      gradient: [Color(0xFF1F2937), Color(0xFF374151), Color(0xFF4B5563)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return Stack(
      children: [
        // Fond animé monochrome
        AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: step.gradient,
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
        ),
        // Vignette sombre sur les bords
        const _Vignette(),
        SafeArea(
          child: Column(
            children: [
              const PhoneStatusBar(foreground: Colors.white),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _steps.length,
                  onPageChanged: (i) {
                    HapticFeedback.lightImpact();
                    setState(() => _step = i);
                  },
                  itemBuilder: (context, i) => _OnbPage(
                    step: _steps[i],
                    parallax: (i - _page).clamp(-1.0, 1.0),
                  ),
                ),
              ),
              // Indicateurs traits fins blancs (plus de jaune)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: i == _step ? 28 : 14,
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                          alpha: i == _step ? 0.85 : 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Bouton custom (pas de TextButton → pas d'iOS underline)
              _CustomButton(
                label: _step < _steps.length - 1 ? 'Continuer' : 'Entrer',
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  if (_step < _steps.length - 1) {
                    await _ctrl.animateToPage(
                      _step + 1,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    await _markDone();
                    widget.onFinished();
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnbPage extends StatelessWidget {
  const _OnbPage({required this.step, required this.parallax});
  final _OnbStep step;
  final double parallax;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Chapitre romain — blanc tamisé (plus de jaune)
          Transform.translate(
            offset: Offset(parallax * 12, 0),
            child: Text(
              step.chapter,
              style: GoogleFonts.crimsonPro(
                fontSize: 92,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Colors.white.withValues(alpha: 0.40),
                height: 1.0,
                letterSpacing: 6,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Titre du chapitre — petit, large lettering, blanc
          Text(
            step.title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.70),
              letterSpacing: 4,
              decoration: TextDecoration.none,
            ),
          ),
          const Spacer(),
          // Citation centrale
          Transform.translate(
            offset: Offset(parallax * 24, 0),
            child: Text(
              step.epigraph,
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.55,
                letterSpacing: 0.2,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 26),
          // Attribution discrète
          Text(
            '— ${step.attribution}',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.50),
              letterSpacing: 0.6,
              decoration: TextDecoration.none,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

/// Bouton custom — GestureDetector + Container, pas de TextButton
/// pour éviter que iOS « Underline Buttons » ne dessine un trait
/// jaune sous le libellé.
class _CustomButton extends StatelessWidget {
  const _CustomButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
              width: 0.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 1.2,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

/// Vignette sombre sur les bords (radial gradient transparent → noir).
class _Vignette extends StatelessWidget {
  const _Vignette();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.38),
            ],
            stops: const [0.6, 1.0],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _OnbStep {
  final String chapter;
  final String title;
  final String epigraph;
  final String attribution;
  final List<Color> gradient;

  const _OnbStep({
    required this.chapter,
    required this.title,
    required this.epigraph,
    required this.attribution,
    required this.gradient,
  });
}
