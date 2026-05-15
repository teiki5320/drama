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

/// Onboarding 3 écrans façon livre — chapitre + numéro romain, citation
/// serif italique centrée, vignette photo, swipe horizontal entre les
/// pages avec parallax léger. Pose la voix Shen avant d'entrer dans le
/// téléphone.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
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
      gradient: [Color(0xFF0A0E1F), Color(0xFF1A2540), Color(0xFF1F2937)],
      accent: Color(0xFFD4AF37),
    ),
    _OnbStep(
      chapter: 'II',
      title: 'Ce téléphone',
      epigraph:
          'Tout passe par là.\n'
          'Les SMS de Maman, les calculs, les carnets, les comptes.\n'
          'Tu me liras à travers ce que je tape — et ce que je tais.',
      attribution: 'Mode d\'emploi',
      gradient: [Color(0xFF1F2937), Color(0xFF2E2A40), Color(0xFF4A3A55)],
      accent: Color(0xFFE8AC65),
    ),
    _OnbStep(
      chapter: 'III',
      title: 'Le compteur',
      epigraph:
          'Dix-huit mille euros.\n'
          'Six semaines.\n'
          'Quarante-deux jours.',
      attribution: 'À partir de maintenant.',
      gradient: [Color(0xFF8FA9C2), Color(0xFFC4B499), Color(0xFFD6B98C)],
      accent: Color(0xFFFFFFFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    return Stack(
      children: [
        // Fond animé qui s'interpole entre les gradients des étapes
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
        // Vignette sombre sur les bords pour donner du cadre
        const _Vignette(),
        // Bruit de pellicule subtil
        const _FilmGrain(),
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
                    isLast: i == _steps.length - 1,
                  ),
                ),
              ),
              // Indicateurs trait fin (au lieu des points)
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
                          alpha: i == _step ? 0.95 : 0.30),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Bouton « Continuer / Entrer » très épuré
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
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
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.10),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.30),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _step < _steps.length - 1 ? 'Continuer' : 'Entrer',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              // Hint swipe horizontal (sauf au dernier)
              const SizedBox(height: 14),
              Opacity(
                opacity: _step < _steps.length - 1 ? 0.5 : 0,
                child: Text(
                  'glisse →',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnbPage extends StatelessWidget {
  const _OnbPage({
    required this.step,
    required this.parallax,
    required this.isLast,
  });
  final _OnbStep step;
  final double parallax;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    // Le contenu se décale légèrement en sens inverse du swipe pour
    // donner une profondeur (parallax léger).
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Chapitre romain en filigrane
          Transform.translate(
            offset: Offset(parallax * 12, 0),
            child: Text(
              step.chapter,
              style: GoogleFonts.crimsonPro(
                fontSize: 92,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: step.accent.withValues(alpha: 0.50),
                height: 1.0,
                letterSpacing: 6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Trait or
          Container(
            width: 36,
            height: 1,
            color: step.accent.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 14),
          Text(
            step.title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 4,
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
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Attribution petite
          Text(
            '— ${step.attribution}',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.65),
              letterSpacing: 0.6,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

/// Vignette sombre sur les bords (radial gradient transparent → noir 40 %).
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

/// Bruit de pellicule subtil — petits dots blancs très transparents
/// répartis aléatoirement (seedés sur position, pas sur le temps pour
/// ne pas faire vibrer). Statique mais texturé.
class _FilmGrain extends StatelessWidget {
  const _FilmGrain();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _GrainPainter(),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..strokeCap = StrokeCap.round;
    // Distribution déterministe : 600 points pseudo-aléatoires.
    var seed = 1729;
    int next() {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return seed;
    }

    for (var i = 0; i < 600; i++) {
      final dx = (next() % 1000) / 1000 * size.width;
      final dy = (next() % 1000) / 1000 * size.height;
      final r = ((next() % 100) / 100) * 0.8 + 0.2;
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OnbStep {
  final String chapter;
  final String title;
  final String epigraph;
  final String attribution;
  final List<Color> gradient;
  final Color accent;

  const _OnbStep({
    required this.chapter,
    required this.title,
    required this.epigraph,
    required this.attribution,
    required this.gradient,
    required this.accent,
  });
}
