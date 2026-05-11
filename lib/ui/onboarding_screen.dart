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

/// 4-page welcome screen on first launch with character portraits.
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
      title: 'Tu es Shen.',
      body:
          'Shen Marchand. 24 ans, franco-chinoise, livreuse à vélo à Belleville. Yeux verts hérités d\'une mère française qui n\'a jamais quitté la France. Mandarin courant que personne ne sait qu\'elle parle.',
      chars: [
        _PageChar(
          photo: 'assets/photos/characters/shen_y.jpeg',
          name: 'Shen Marchand',
          meta: '24 ans · Belleville',
          accent: 'C\'est toi.',
        ),
      ],
    ),
    _Page(
      title: 'Les deux femmes de ta vie.',
      body:
          'Maman te ment sur sa maladie pour ne pas t\'inquiéter. Camille te garde en vie avec des croissants et la moitié des phrases qui te font tenir.',
      chars: [
        _PageChar(
          photo: 'assets/photos/characters/helene_marchand.png',
          name: 'Maman',
          meta: '50 ans · Hôpital Tenon',
          accent: 'Te cache la moitié.',
        ),
        _PageChar(
          photo: 'assets/photos/characters/camille_rx.png',
          name: 'Camille',
          meta: '24 ans · Étudiante en droit',
          accent: 'Vannes & croissants.',
        ),
      ],
    ),
    _Page(
      title: 'Ce qui t\'attend.',
      body:
          'Un héritier glaçon. Une matriarche qui voit tout. Un demi-frère qui sourit trop. 112 jours pour décider de tout.',
      chars: [
        _PageChar(
          photo: 'assets/photos/characters/t_heng.png',
          name: 'Tristan Heng',
          meta: '29 ans · Heng International',
          accent: 'Le glaçon.',
        ),
        _PageChar(
          photo: 'assets/photos/characters/heng_lihua.png',
          name: 'Madame Heng',
          meta: '58 ans · La tante',
          accent: 'Sait des choses.',
        ),
      ],
    ),
    _Page(
      title: 'Trois jauges. Une deadline.',
      body:
          '💰 L\'argent · 😊 Le mood · ⭐ La réputation. Chaque choix les bouge. Pas de bonne ni de mauvaise option, juste des compromis.\n\nMaman a besoin de 18 000 € pour son traitement avant J45. Si tu n\'y arrives pas, le drama bascule sur la branche du deuil.',
      chars: [],
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
  final String title;
  final String body;
  final List<_PageChar> chars;
  const _Page({required this.title, required this.body, this.chars = const []});
}

class _PageChar {
  final String photo;
  final String name;
  final String meta;
  final String accent;
  const _PageChar({
    required this.photo,
    required this.name,
    required this.meta,
    required this.accent,
  });
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.page});
  final _Page page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            page.title,
            style: GoogleFonts.crimsonPro(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.body,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          if (page.chars.length == 1)
            _BigCharCard(char: page.chars.first)
          else if (page.chars.length >= 2)
            Row(
              children: [
                Expanded(child: _DuoCharCard(char: page.chars[0])),
                const SizedBox(width: 10),
                Expanded(child: _DuoCharCard(char: page.chars[1])),
              ],
            ),
        ],
      ),
    );
  }
}

class _BigCharCard extends StatelessWidget {
  const _BigCharCard({required this.char});
  final _PageChar char;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                char.photo,
                fit: BoxFit.cover,
                cacheWidth: 600,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEAE6DD),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person,
                      size: 64, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            char.name,
            style: GoogleFonts.crimsonPro(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            char.meta,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              char.accent,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.accentOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuoCharCard extends StatelessWidget {
  const _DuoCharCard({required this.char});
  final _PageChar char;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                char.photo,
                fit: BoxFit.cover,
                cacheWidth: 360,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEAE6DD),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person,
                      size: 36, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            char.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.crimsonPro(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            char.meta,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            char.accent,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.accentOrange,
            ),
          ),
        ],
      ),
    );
  }
}
