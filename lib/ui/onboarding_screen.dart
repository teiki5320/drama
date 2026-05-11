import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/colors.dart';

const _onboardingKey = 'hasSeenOnboarding_v1';

/// True if the user has already gone through the welcome flow.
final hasSeenOnboardingProvider =
    FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_onboardingKey) ?? false;
});

/// 3-page welcome screen on first launch. Sets a flag in
/// SharedPreferences when the user taps "Commencer".
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = <_Page>[
    _Page(
      icon: '🌿',
      title: 'Bienvenue dans À Contre-Jour.',
      body:
          'Tu vas suivre Shen Marchand, 24 ans, livreuse à vélo à Belleville. Sa mère est malade, le loyer monte, et un milliardaire la regarde depuis sa Bentley.\n\nÀ toi de choisir comment elle traverse les 112 prochains jours.',
    ),
    _Page(
      icon: '⚖️',
      title: 'Trois jauges à surveiller.',
      body:
          '💰 L\'argent (tu démarres à 2 384 €).\n😊 Le mood (0 à 10) — l\'humeur de Shen.\n⭐ La réputation — son influence sociale et ses partenariats Insta.\n\nChaque choix bouge ces trois jauges. Pas de bonne ni de mauvaise option, juste des compromis.',
    ),
    _Page(
      icon: '🏥',
      title: 'La deadline : J45.',
      body:
          'Maman a besoin de 18 000 € pour son traitement avant J45. Si tu n\'as pas réuni la somme, le drama bascule sur la branche du deuil — sans retour.\n\nLes choix narratifs, la bourse, les partenariats Insta — à toi de jouer.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    ref.invalidate(hasSeenOnboardingProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;
    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Passer',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() => _page = i);
                },
                itemBuilder: (_, i) => _PageBody(page: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _page == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _page == i
                                ? AppColors.accentOrange
                                : const Color(0x141A1A1A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: isLast
                          ? _finish
                          : () {
                              HapticFeedback.selectionClick();
                              _controller.nextPage(
                                duration:
                                    const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                      child: Text(
                        isLast ? 'Commencer le drama' : 'Suivant',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page {
  final String icon;
  final String title;
  final String body;
  const _Page({required this.icon, required this.title, required this.body});
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.page});
  final _Page page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(page.icon, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          Text(
            page.title,
            style: GoogleFonts.crimsonPro(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.body,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
