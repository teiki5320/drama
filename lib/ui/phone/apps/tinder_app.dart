import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// Tinder — version jeu-dans-le-jeu. Trois onglets : Feed (swipe),
/// Likes reçus (dynamique), Profil (Shen elle-même éditable selon
/// mood). Mécaniques : 50 swipes/jour, match impossible 80 %, filtres
/// photo, multi-photos par profil, Tinder Platinum gag, profil ghost
/// Tristan qui apparaît au J7 21h, profil Camille blague.
class TinderApp extends ConsumerStatefulWidget {
  const TinderApp({super.key});

  @override
  ConsumerState<TinderApp> createState() => _TinderAppState();
}

class _TinderAppState extends ConsumerState<TinderApp>
    with TickerProviderStateMixin {
  late List<_Match> _deck;
  Offset _drag = Offset.zero;
  bool _returning = false;
  int _likes = 0;
  int _nopes = 0;
  int _superLikes = 0;
  int _swipesRestants = 50;
  int _currentPhotoIdx = 0; // photo affichée sur la carte du haut
  int _tabIdx = 0; // 0=feed, 1=likes reçus, 2=profil
  bool _platinumPopupShown = false;
  bool _noteAfter10Sent = false;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _deck = List.from(_kInitialDeck);
    // Injecter profils contextuels selon le jour gameworld.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final day = ref.read(phoneStateProvider).currentDay;
      _injectContextualProfiles(day);
      setState(() {});
    });
  }

  void _injectContextualProfiles(int day) {
    // Tristan ghost — apparaît à partir de J7 21h00 (post-Tour Heng)
    if (day >= 7 && !_deck.any((m) => m.id == 'ghost_tristan')) {
      _deck.insert(2, _kGhostTristan);
    }
    // Camille gag — apparaît dès l'ouverture
    if (!_deck.any((m) => m.id == 'gag_camille')) {
      _deck.insert(4, _kGagCamille);
    }
  }

  void _onMyProfileTap() {
    HapticFeedback.selectionClick();
    setState(() => _tabIdx = 2);
  }

  void _onLikesTap() {
    HapticFeedback.selectionClick();
    setState(() => _tabIdx = 1);
  }

  void _onFeedTap() {
    HapticFeedback.selectionClick();
    setState(() => _tabIdx = 0);
  }

  void _resolve(bool liked, {bool superLike = false}) {
    if (_deck.isEmpty) return;
    final m = _deck.first;
    // Compteur de swipes — 50 par jour
    if (_swipesRestants <= 0) {
      HapticFeedback.heavyImpact();
      _showSwipesExhausted();
      return;
    }
    // Gag Camille — au lieu de résoudre, ouvre un dialog
    if (m.id == 'gag_camille' && liked) {
      _showCamilleGag();
      return;
    }
    HapticFeedback.mediumImpact();
    if (liked) {
      if (superLike) {
        _superLikes++;
      } else {
        _likes++;
      }
    } else {
      _nopes++;
    }
    _swipesRestants--;
    // Match impossible : 80 % des right-swipes sur profils non autoMatch
    // se ferment silencieusement (« vous n'êtes pas premium »).
    final triggerMatch = liked && m.autoMatch;
    final invisibleSwipe =
        liked && !m.autoMatch && !m.ghost && _rng.nextDouble() < 0.80;
    setState(() {
      _drag = Offset.zero;
      _returning = false;
      _deck.removeAt(0);
      _currentPhotoIdx = 0;
    });
    if (triggerMatch) _showMatch(m);
    if (invisibleSwipe) _showInvisible();
    // Note Shen brouillon après 10 swipes
    final totalSwipes = _likes + _nopes + _superLikes;
    if (totalSwipes >= 10 && !_noteAfter10Sent) {
      _noteAfter10Sent = true;
      _showShenNoteToast();
    }
    // Tinder Platinum popup toutes les 7 swipes (max 1 fois par session)
    if (totalSwipes >= 7 && !_platinumPopupShown) {
      _platinumPopupShown = true;
      Future.delayed(const Duration(milliseconds: 600), _showPlatinumPopup);
    }
  }

  void _showSwipesExhausted() {
    showDialog<void>(
      context: context,
      builder: (ctx) => _SimpleDialog(
        title: 'Plus de swipes',
        body: 'Tu en as eu 50 aujourd\'hui. Reviens demain.\n\n'
            'Ou achète un pack de 5 pour 0,99 €.',
        primaryLabel: 'Demain',
        secondaryLabel: 'Acheter 5 swipes',
        onPrimary: () => Navigator.of(ctx).pop(),
        onSecondary: () {
          Navigator.of(ctx).pop();
          // Gag : on ouvre Platinum popup
          _showPlatinumPopup();
        },
      ),
    );
  }

  void _showInvisible() {
    // Tinder dit « vous n'êtes pas premium » de manière diégétique :
    // un toast discret en haut de l'écran.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A1A),
        content: Text(
          'Ce profil ne voit pas votre like. Passe en Platinum.',
          style: GoogleFonts.inter(
              fontSize: 12, color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  void _showShenNoteToast() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2400),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF3DA85F),
        content: Text(
          '✎ Nouvelle note brouillon dans Notes — « 10 swipes »',
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

  void _showPlatinumPopup() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✨ Tinder Platinum',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFB8860B),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '147 personnes t\'ont likée cette semaine.\n\n'
                'Débloque-les avec Platinum — 19,99 €/mois.\n\n'
                'Ou bois un autre thé.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF1A1A1A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97757),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    'Bois un thé',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCamilleGag() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Espèce de gourde',
                style: GoogleFonts.crimsonPro(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFFD97757),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'C\'est moi.\n\n'
                'Je teste si tu lis encore mon nom.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF1A1A1A),
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _deck.removeWhere((m) => m.id == 'gag_camille');
                    _drag = Offset.zero;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    'Coupable',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatch(_Match m) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xCCFD297B),
      builder: (ctx) => _MatchAnimation(match: m),
    );
  }

  void _showProfileDetail(_Match m) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProfileDetailSheet(match: m),
    );
  }

  /// Animation spring de retour quand on relâche avant le seuil.
  void _springBack() async {
    if (_drag == Offset.zero) return;
    setState(() => _returning = true);
    final start = _drag;
    const duration = Duration(milliseconds: 220);
    final steps = 14;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(
          Duration(milliseconds: duration.inMilliseconds ~/ steps));
      if (!mounted) return;
      final t = i / steps;
      final eased = Curves.easeOutBack.transform(t);
      setState(() => _drag = Offset.lerp(start, Offset.zero, eased)!);
    }
    if (!mounted) return;
    setState(() {
      _drag = Offset.zero;
      _returning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(phoneStateProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          // Header avec retour + flamme + GOLD
          _TinderHeader(
            swipesRestants: _swipesRestants,
            onPlatinum: _showPlatinumPopup,
            onClose: () {
              HapticFeedback.selectionClick();
              ref.read(phoneStateProvider.notifier).closeApp();
            },
          ),
          // 3 tabs : Flamme / Cœur (likes) / Profil
          _TinderTabs(
            tabIdx: _tabIdx,
            onFeed: _onFeedTap,
            onLikes: _onLikesTap,
            onProfile: _onMyProfileTap,
          ),
          Expanded(
            child: _tabIdx == 0
                ? _buildFeed()
                : _tabIdx == 1
                    ? _LikesReceivedView(
                        likesRecus: _computeLikesRecus(p.currentDay),
                        onPlatinum: _showPlatinumPopup,
                      )
                    : _MyProfileView(mood: p.mood, day: p.currentDay),
          ),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: _deck.isEmpty
                ? const _EmptyDeck()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AspectRatio(
                      aspectRatio: 0.7,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_deck.length > 1)
                            Transform.scale(
                              scale: 0.95,
                              child: _Card(
                                match: _deck[1],
                                drag: Offset.zero,
                                photoIdx: 0,
                              ),
                            ),
                          GestureDetector(
                            onLongPress: () =>
                                _showProfileDetail(_deck.first),
                            onTapUp: (d) {
                              // Tap zone gauche/droite pour changer de photo
                              final w = MediaQuery.of(context).size.width;
                              final dx = d.localPosition.dx;
                              final m = _deck.first;
                              if (m.photos.length <= 1) return;
                              setState(() {
                                if (dx < w / 3) {
                                  _currentPhotoIdx =
                                      (_currentPhotoIdx - 1) %
                                          m.photos.length;
                                  if (_currentPhotoIdx < 0) {
                                    _currentPhotoIdx += m.photos.length;
                                  }
                                } else if (dx > 2 * w / 3) {
                                  _currentPhotoIdx =
                                      (_currentPhotoIdx + 1) %
                                          m.photos.length;
                                }
                              });
                              HapticFeedback.selectionClick();
                            },
                            onPanUpdate: (d) {
                              if (_returning) return;
                              setState(() => _drag += d.delta);
                            },
                            onPanEnd: (_) {
                              if (_drag.dy < -120 && _drag.dx.abs() < 100) {
                                _resolve(true, superLike: true);
                              } else if (_drag.dx.abs() > 100) {
                                _resolve(_drag.dx > 0);
                              } else {
                                _springBack();
                              }
                            },
                            child: _Card(
                              match: _deck.first,
                              drag: _drag,
                              photoIdx: _currentPhotoIdx,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        if (_deck.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionBtn(
                  icon: Icons.close,
                  color: const Color(0xFFFD5068),
                  onTap: () => _resolve(false),
                ),
                _ActionBtn(
                  icon: Icons.star,
                  color: const Color(0xFF4FC3F7),
                  small: true,
                  onTap: () => _resolve(true, superLike: true),
                ),
                _ActionBtn(
                  icon: Icons.favorite,
                  color: const Color(0xFF66D7A1),
                  onTap: () => _resolve(true),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatChip(
                  label: 'Nopes',
                  value: _nopes,
                  color: const Color(0xFFFD5068)),
              _StatChip(
                  label: '⭐',
                  value: _superLikes,
                  color: const Color(0xFF4FC3F7)),
              _StatChip(
                  label: 'Likes',
                  value: _likes,
                  color: const Color(0xFF66D7A1)),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Text(
            'Tap gauche/droite : photo suivante. Appui long : profil.\n'
            'Swipe haut : ⭐. ${_swipesRestants}/50 swipes aujourd\'hui.',
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  /// Calcule les likes reçus simulés (formule régulière dépendante du
  /// jour et du nombre de swipes faits). Croît au fil du temps.
  int _computeLikesRecus(int day) {
    final total = _likes + _nopes + _superLikes;
    // Base : 12 + day*3 + total swipes
    return 12 + (day * 3) + total + (_superLikes * 4);
  }
}

// ─── Header / Tabs ───────────────────────────────────────────────

class _TinderHeader extends StatelessWidget {
  const _TinderHeader({
    required this.swipesRestants,
    required this.onPlatinum,
    required this.onClose,
  });
  final int swipesRestants;
  final VoidCallback onPlatinum;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Color(0xFFFD297B), size: 20),
            onPressed: onClose,
          ),
          const Icon(Icons.local_fire_department,
              color: Color(0xFFFD297B), size: 28),
          const SizedBox(width: 8),
          Text(
            'tinder',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFFD297B),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPlatinum,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'PLATINUM',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinderTabs extends StatelessWidget {
  const _TinderTabs({
    required this.tabIdx,
    required this.onFeed,
    required this.onLikes,
    required this.onProfile,
  });
  final int tabIdx;
  final VoidCallback onFeed;
  final VoidCallback onLikes;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TabIcon(
              icon: Icons.local_fire_department,
              active: tabIdx == 0,
              onTap: onFeed),
          _TabIcon(icon: Icons.favorite, active: tabIdx == 1, onTap: onLikes),
          _TabIcon(icon: Icons.person, active: tabIdx == 2, onTap: onProfile),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon(
      {required this.icon, required this.active, required this.onTap});
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Icon(
          icon,
          color: active ? const Color(0xFFFD297B) : Colors.grey.shade400,
          size: 26,
        ),
      ),
    );
  }
}

// ─── Likes reçus view ────────────────────────────────────────────

class _LikesReceivedView extends StatelessWidget {
  const _LikesReceivedView({
    required this.likesRecus,
    required this.onPlatinum,
  });
  final int likesRecus;
  final VoidCallback onPlatinum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Likes reçus',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$likesRecus personnes t\'ont likée',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          // Grid 2x2 de cartes floues
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: likesRecus.clamp(0, 6),
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(_blurredColors[i % _blurredColors.length][0]),
                            Color(_blurredColors[i % _blurredColors.length][1]),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Floutage : overlay semi-transparent
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Icon(Icons.lock,
                            color: Colors.grey.shade600, size: 32),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onPlatinum,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Voir qui — Tinder Platinum',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _blurredColors = [
  [0xFFFD5068, 0xFFFFC837],
  [0xFF4FC3F7, 0xFF1F2937],
  [0xFF66D7A1, 0xFFE7E1D2],
  [0xFFE89B7F, 0xFF5E2E66],
  [0xFFFCE6D8, 0xFFD7DEE5],
  [0xFFFAEAD0, 0xFFCFC8B5],
];

// ─── Mon profil view (Shen elle-même) ────────────────────────────

class _MyProfileView extends StatelessWidget {
  const _MyProfileView({required this.mood, required this.day});
  final int mood;
  final int day;

  @override
  Widget build(BuildContext context) {
    final bio = _shenBio(mood);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo principale
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFCE6D8), Color(0xFFFAE0CC)],
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/photos/avatars/shen.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Shen, 24',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Belleville, Paris · J$day',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'BIO',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              bio,
              style: GoogleFonts.crimsonPro(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF1A1A1A),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'La bio est générée automatiquement selon ton mood courant.\n'
            'Tu ne peux pas l\'éditer. Tinder décide pour toi.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static String _shenBio(int mood) {
    if (mood <= 2) {
      return '_Bio vide._';
    }
    if (mood <= 4) {
      return 'Livreuse à vélo. Carnet vert. Maman malade.\n'
          'Ne cherche rien.';
    }
    if (mood <= 6) {
      return 'Vingt-quatre ans, Paris 19e. Croissants à deux mains.\n'
          'Curieuse. Pas pressée.';
    }
    if (mood <= 8) {
      return 'Étudiante en archi, livreuse à vélo, fille de.\n'
          'J\'aime le thé Long Jing première récolte.\n'
          'Cherche éphémère bien fait.';
    }
    return 'Vingt-quatre ans, déjà beaucoup vu.\n'
        'Je sais reconnaître un Long Jing à l\'aveugle.\n'
        'Apporte un livre, on parlera.';
  }
}

// ─── Models ──────────────────────────────────────────────────────

class _Match {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String location;
  final String? longBio;
  final List<int> gradient;
  final String emoji;
  /// Plusieurs photos par profil — chaque photo est une combinaison
  /// emoji + gradient + filtre style Insta.
  final List<_PhotoStub> photos;
  final bool autoMatch;
  final bool isCanonGag;
  final bool ghost;
  const _Match({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.location,
    required this.gradient,
    required this.emoji,
    this.photos = const [],
    this.longBio,
    this.autoMatch = false,
    this.isCanonGag = false,
    this.ghost = false,
  });
}

/// Une photo de profil — emoji central + gradient + filtre style
/// Insta appliqué (modifie les couleurs).
class _PhotoStub {
  final String emoji;
  final List<int> gradient;
  final _Filter filter;
  const _PhotoStub({
    required this.emoji,
    required this.gradient,
    this.filter = _Filter.none,
  });
}

enum _Filter {
  none,
  valencia, // chaud, légèrement délavé
  mayfair, // tons rose-violet
  nashville, // sépia
  inkwell, // noir et blanc
}

ColorFilter? _matrixForFilter(_Filter f) {
  switch (f) {
    case _Filter.none:
      return null;
    case _Filter.valencia:
      return const ColorFilter.matrix([
        1.0, 0.04, 0.04, 0, 5,
        0, 1.0, 0.04, 0, 5,
        0, 0, 0.9, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    case _Filter.mayfair:
      return const ColorFilter.matrix([
        1.0, 0, 0.1, 0, 0,
        0, 0.9, 0.1, 0, 0,
        0, 0, 1.0, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    case _Filter.nashville:
      return const ColorFilter.matrix([
        0.7, 0.5, 0.2, 0, 0,
        0.4, 0.7, 0.2, 0, 0,
        0.3, 0.4, 0.5, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    case _Filter.inkwell:
      return const ColorFilter.matrix([
        0.299, 0.587, 0.114, 0, 0,
        0.299, 0.587, 0.114, 0, 0,
        0.299, 0.587, 0.114, 0, 0,
        0, 0, 0, 1, 0,
      ]);
  }
}

// ─── Deck initial ────────────────────────────────────────────────

const _kInitialDeck = <_Match>[
  _Match(
    id: 'quentin',
    name: 'Quentin',
    age: 27,
    bio: '« Charcuterie · Crossfit · Bons vivants »',
    location: 'À 2 km',
    gradient: [0xFF888888, 0xFF2A2A2A],
    emoji: '🍖',
    photos: [
      _PhotoStub(emoji: '🍖', gradient: [0xFF888888, 0xFF2A2A2A]),
      _PhotoStub(emoji: '🏋️', gradient: [0xFF6B7280, 0xFF374151], filter: _Filter.valencia),
      _PhotoStub(emoji: '🍷', gradient: [0xFF7F1D1D, 0xFF3A0A0A]),
    ],
    longBio:
        'Commercial dans les vins. Crossfit 5 fois par semaine.\n'
        'Pas de relation toxique. Pas de drama. Pas de prise de tête.',
  ),
  _Match(
    id: 'antoine',
    name: 'Antoine',
    age: 31,
    bio: '« Banquier le jour, DJ la nuit. Authentique. »',
    location: 'À 800 m',
    gradient: [0xFF1F2937, 0xFF374151],
    emoji: '🎧',
    photos: [
      _PhotoStub(emoji: '🎧', gradient: [0xFF1F2937, 0xFF374151]),
      _PhotoStub(emoji: '💼', gradient: [0xFF374151, 0xFF6B7280], filter: _Filter.inkwell),
      _PhotoStub(emoji: '🌃', gradient: [0xFF0A0E1F, 0xFF1A1E33], filter: _Filter.mayfair),
    ],
    autoMatch: true,
    longBio:
        'Sciences Po, HEC, M&A chez Lazard. Set tous les jeudis au Wanderlust.\n'
        '« Authentique » est ma valeur cardinale.',
  ),
  _Match(
    id: 'leo',
    name: 'Léo',
    age: 24,
    bio: '« 6 mois Bali · pas sérieux · pas pressé »',
    location: 'À 4 km',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    emoji: '🌴',
    photos: [
      _PhotoStub(emoji: '🌴', gradient: [0xFFE89B7F, 0xFFFCC9A1], filter: _Filter.valencia),
      _PhotoStub(emoji: '🏄', gradient: [0xFF06B6D4, 0xFF0E7490]),
      _PhotoStub(emoji: '🧘', gradient: [0xFFFCD34D, 0xFFFEF3C7], filter: _Filter.nashville),
    ],
    longBio:
        'Surf, yoga, ayahuasca. J\'investis dans les NFT et la beauté intérieure.\n'
        '« Pas pressé » = je ne réponds pas avant 3 jours.',
  ),
  _Match(
    id: 'maxime',
    name: 'Maxime',
    age: 29,
    bio: '« Ingé blockchain. Cherche complice. »',
    location: 'À 1.2 km',
    gradient: [0xFF5E2E66, 0xFF8B4A8A],
    emoji: '⛓️',
    photos: [
      _PhotoStub(emoji: '⛓️', gradient: [0xFF5E2E66, 0xFF8B4A8A]),
      _PhotoStub(emoji: '💻', gradient: [0xFF1F2937, 0xFF6366F1], filter: _Filter.mayfair),
    ],
    longBio:
        'Founder d\'une DAO. Mon LinkedIn parle pour moi.\n'
        'Cherche une complice qui comprend que je suis pris à 22h chaque soir.',
  ),
  _Match(
    id: 'hugo',
    name: 'Hugo',
    age: 33,
    bio: '« Père divorcé · 2 enfants week-end sur 2 »',
    location: 'À 6 km',
    gradient: [0xFF6E94B5, 0xFFAEC4D8],
    emoji: '👨‍👧',
    photos: [
      _PhotoStub(emoji: '👨‍👧', gradient: [0xFF6E94B5, 0xFFAEC4D8]),
      _PhotoStub(emoji: '🏠', gradient: [0xFF8B7355, 0xFFCFC8B5], filter: _Filter.nashville),
    ],
    longBio:
        'Architecte d\'intérieur. Père séparé. Mes enfants passent avant tout.\n'
        'Sauf un week-end sur deux.',
  ),
  _Match(
    id: 'damien',
    name: 'Damien',
    age: 35,
    bio: '« Avocat fiscaliste · Yacht à Antibes l\'été »',
    location: 'À 3 km',
    gradient: [0xFF3A4555, 0xFF6B7385],
    emoji: '⚖️',
    photos: [
      _PhotoStub(emoji: '⚖️', gradient: [0xFF3A4555, 0xFF6B7385]),
      _PhotoStub(emoji: '⛵', gradient: [0xFF1E40AF, 0xFF60A5FA], filter: _Filter.valencia),
      _PhotoStub(emoji: '🥃', gradient: [0xFF78350F, 0xFFB45309], filter: _Filter.inkwell),
    ],
    longBio:
        'Cabinet d\'affaires rue de Rivoli. Yacht 18 m basé à Antibes.\n'
        'Ma bio est honnête, vous voyez ce que vous achetez.',
  ),
  _Match(
    id: 'sebastien',
    name: 'Sébastien',
    age: 28,
    bio: '« Sapio-sexuel · Médite 2 h/jour »',
    location: 'À 9 km',
    gradient: [0xFF2E7D32, 0xFF66BB6A],
    emoji: '🧘',
    photos: [
      _PhotoStub(emoji: '🧘', gradient: [0xFF2E7D32, 0xFF66BB6A], filter: _Filter.nashville),
      _PhotoStub(emoji: '📚', gradient: [0xFF422006, 0xFF7C2D12]),
    ],
    autoMatch: true,
    longBio:
        'Je cherche une partenaire mentale d\'abord. Stoïcien.\n'
        'Je lis Marc Aurèle dans les transports.',
  ),
  _Match(
    id: 'karim',
    name: 'Karim',
    age: 30,
    bio: '« Photographe · Hong Kong · Paris »',
    location: 'À 1 km',
    gradient: [0xFF1A1A1A, 0xFF8B4A8A],
    emoji: '📷',
    photos: [
      _PhotoStub(emoji: '📷', gradient: [0xFF1A1A1A, 0xFF8B4A8A], filter: _Filter.inkwell),
      _PhotoStub(emoji: '🌆', gradient: [0xFFE89B7F, 0xFF5E2E66]),
    ],
    longBio:
        'Reportage, mariage, mode. Je voyage 3 semaines par mois.\n'
        'Hong Kong me manque. Tu connais ?',
  ),
  _Match(
    id: 'vincent_canon',
    name: 'Vincent',
    age: 36,
    bio: '« Closing · Yachts · Brunch dominical »',
    location: 'À 0.1 km',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    emoji: '💼',
    photos: [
      _PhotoStub(emoji: '💼', gradient: [0xFFE89B7F, 0xFFFCC9A1]),
      _PhotoStub(emoji: '🥂', gradient: [0xFFFFC837, 0xFFFFFFFF], filter: _Filter.valencia),
      _PhotoStub(emoji: '🏝️', gradient: [0xFF06B6D4, 0xFFFCD34D]),
    ],
    longBio:
        'Senior Sales chez Heng International.\n'
        'Frère de Tristan, le DG. Cherche une « real one ».\n'
        'Anglicismes assumés. Closing, deal, no problemo.',
    autoMatch: true,
    isCanonGag: true,
  ),
];

// Profils contextuels (injectés selon le jour)

const _kGhostTristan = _Match(
  id: 'ghost_tristan',
  name: 'Anonyme',
  age: 32,
  bio: '« Vu une fois Avenue Montaigne, 08:17 le 3 juin »',
  location: 'À 0 km',
  gradient: [0xFF0A0E1F, 0xFF1F2937],
  emoji: '👻',
  photos: [
    _PhotoStub(emoji: '👻', gradient: [0xFF0A0E1F, 0xFF1F2937], filter: _Filter.inkwell),
  ],
  longBio:
      'Ce profil n\'existe pas vraiment.\n'
      'L\'algorithme dit qu\'il est passé une fois dans ton secteur,\n'
      'à 11h47 mardi dernier.\n\n'
      'Tu l\'as su autrement.',
  ghost: true,
);

const _kGagCamille = _Match(
  id: 'gag_camille',
  name: 'Camille',
  age: 24,
  bio: '« Code civil · Croissants · Vannes »',
  location: 'À 3 km',
  gradient: [0xFFFCE6D8, 0xFFFAE0CC],
  emoji: '🥐',
  photos: [
    _PhotoStub(emoji: '🥐', gradient: [0xFFFCE6D8, 0xFFFAE0CC]),
    _PhotoStub(emoji: '📚', gradient: [0xFFE7E1D2, 0xFFCFC8B5], filter: _Filter.nashville),
  ],
  longBio: 'Tu sais qui je suis. Tape « Like » pour voir.',
);

// ─── UI atoms ───────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({
    required this.match,
    required this.drag,
    required this.photoIdx,
  });
  final _Match match;
  final Offset drag;
  final int photoIdx;

  @override
  Widget build(BuildContext context) {
    final angle = drag.dx / 800;
    final likeOpacity = (drag.dx / 100).clamp(0.0, 1.0);
    final nopeOpacity = (-drag.dx / 100).clamp(0.0, 1.0);
    final superOpacity = (-drag.dy / 120).clamp(0.0, 1.0);
    final hasPhotos = match.photos.isNotEmpty;
    final photo = hasPhotos ? match.photos[photoIdx % match.photos.length] : null;
    final gradient = photo?.gradient ?? match.gradient;
    final emoji = photo?.emoji ?? match.emoji;
    final filter = photo?.filter ?? _Filter.none;
    final matrix = _matrixForFilter(filter);
    return Transform.translate(
      offset: drag,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background gradient + filtre Insta-style
                Positioned.fill(
                  child: matrix == null
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: gradient.map((h) => Color(h)).toList(),
                            ),
                          ),
                        )
                      : ColorFiltered(
                          colorFilter: matrix,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors:
                                    gradient.map((h) => Color(h)).toList(),
                              ),
                            ),
                          ),
                        ),
                ),
                Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
                // Indicateurs de photos en haut (style Insta stories)
                if (match.photos.length > 1)
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: List.generate(match.photos.length, (i) {
                        final active = i == photoIdx % match.photos.length;
                        return Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(alpha: active ? 0.95 : 0.40),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                // Stamps LIKE / NOPE / SUPER LIKE
                Positioned(
                  top: 30,
                  left: 24,
                  child: Opacity(
                    opacity: likeOpacity,
                    child: Transform.rotate(
                      angle: -0.3,
                      child: _Stamp(
                          text: 'LIKE', color: const Color(0xFF66D7A1)),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 24,
                  child: Opacity(
                    opacity: nopeOpacity,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: _Stamp(
                          text: 'NOPE', color: const Color(0xFFFD5068)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: superOpacity,
                    child: Center(
                      child: _Stamp(
                          text: 'SUPER LIKE',
                          color: const Color(0xFF4FC3F7),
                          big: true),
                    ),
                  ),
                ),
                // Bandeau bas
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              match.name,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${match.age}',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match.bio,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.text, required this.color, this.big = false});
  final String text;
  final Color color;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: big ? 22 : 28,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: big ? 1 : 0,
        ),
      ),
    );
  }
}

class _EmptyDeck extends StatelessWidget {
  const _EmptyDeck();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department,
              size: 64, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 14),
          Text(
            'Tu as fini ta pile.',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Demain matin tu désinstalleras l\'app, comme prévu.',
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    this.small = false,
  });
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 44.0 : 56.0;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: small ? 22 : 28),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(
      {required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label · $value',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SimpleDialog extends StatelessWidget {
  const _SimpleDialog({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });
  final String title;
  final String body;
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (secondaryLabel != null)
                  TextButton(
                    onPressed: onSecondary,
                    child: Text(secondaryLabel!,
                        style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600)),
                  ),
                ElevatedButton(
                  onPressed: onPrimary,
                  child: Text(primaryLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchAnimation extends StatefulWidget {
  const _MatchAnimation({required this.match});
  final _Match match;

  @override
  State<_MatchAnimation> createState() => _MatchAnimationState();
}

class _MatchAnimationState extends State<_MatchAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        margin: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final t = _ctrl.value;
                final pulse = 1.0 + 0.15 * (1 - (2 * t - 1).abs());
                return Transform.scale(
                  scale: pulse,
                  child: Text(
                    'It\'s a match!',
                    style: GoogleFonts.crimsonPro(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFFD297B),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            // Silhouettes face à face
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Silhouette(emoji: '🌿', delay: 0),
                AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) {
                    final t = _ctrl.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Opacity(
                        opacity: (t * 3 - 1).clamp(0.0, 1.0),
                        child: Text(
                          '✨',
                          style:
                              TextStyle(fontSize: 32 + 16 * (1 - t).abs()),
                        ),
                      ),
                    );
                  },
                ),
                _Silhouette(emoji: widget.match.emoji, delay: 350),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.match.name,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.match.id == 'vincent_canon'
                  ? 'Ne réponds pas.'
                  : 'Vous avez 24h pour rompre le silence.',
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Fermer',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFFFD297B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Silhouette extends StatelessWidget {
  const _Silhouette({required this.emoji, required this.delay});
  final String emoji;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 42)),
    );
  }
}

class _ProfileDetailSheet extends StatelessWidget {
  const _ProfileDetailSheet({required this.match});
  final _Match match;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scroll,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Galerie de toutes les photos en ligne horizontale
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: match.photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final p = match.photos[i];
                  final matrix = _matrixForFilter(p.filter);
                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (matrix != null)
                          ColorFiltered(
                            colorFilter: matrix,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: p.gradient
                                      .map((h) => Color(h))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        else
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: p.gradient
                                    .map((h) => Color(h))
                                    .toList(),
                              ),
                            ),
                          ),
                        Center(
                          child: Text(p.emoji,
                              style: const TextStyle(fontSize: 70)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(match.name,
                          style: GoogleFonts.inter(
                              fontSize: 28, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Text('${match.age}',
                          style: GoogleFonts.inter(
                              fontSize: 22, color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Color(0xFF8E8E93)),
                      const SizedBox(width: 4),
                      Text(match.location,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(match.bio,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: const Color(0xFF1A1A1A))),
                  const SizedBox(height: 14),
                  if (match.longBio != null)
                    Text(
                      match.longBio!,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
