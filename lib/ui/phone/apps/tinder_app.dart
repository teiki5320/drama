import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// Tinder — n'apparaît qu'à un beat précis (soir de désespoir). Pile
/// de cartes swipeables physiquement (drag horizontal). Aucun match ne
/// vaut quelque chose, c'est un sas vide pendant 30 minutes.
class TinderApp extends ConsumerStatefulWidget {
  const TinderApp({super.key});

  @override
  ConsumerState<TinderApp> createState() => _TinderAppState();
}

class _TinderAppState extends ConsumerState<TinderApp> {
  final List<_Match> _deck = List.from(_kInitialDeck);
  Offset _drag = Offset.zero;
  bool _returning = false;

  void _resolve(bool liked) {
    HapticFeedback.mediumImpact();
    setState(() {
      _drag = Offset.zero;
      _returning = false;
      if (_deck.isNotEmpty) _deck.removeAt(0);
    });
  }

  /// Animation spring de retour quand on relâche avant le seuil.
  void _springBack() async {
    if (_drag == Offset.zero) return;
    setState(() => _returning = true);
    final start = _drag;
    const duration = Duration(milliseconds: 220);
    final steps = 14;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: duration.inMilliseconds ~/ steps));
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFFFD297B), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
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
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _deck.isEmpty
                  ? _EmptyDeck()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AspectRatio(
                        aspectRatio: 0.7,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Carte d'arrière-plan (suivante)
                            if (_deck.length > 1)
                              Transform.scale(
                                scale: 0.95,
                                child: _Card(match: _deck[1], drag: Offset.zero),
                              ),
                            // Carte du haut, suit le drag
                            GestureDetector(
                              onPanUpdate: (d) {
                                if (_returning) return;
                                setState(() => _drag += d.delta);
                              },
                              onPanEnd: (_) {
                                if (_drag.dx.abs() > 100) {
                                  _resolve(_drag.dx > 0);
                                } else {
                                  _springBack();
                                }
                              },
                              child: _Card(match: _deck.first, drag: _drag),
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
                    icon: Icons.favorite,
                    color: const Color(0xFF66D7A1),
                    onTap: () => _resolve(true),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              'Tu n\'es pas obligée d\'être là ce soir.',
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDeck extends StatelessWidget {
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

class _Match {
  final String name;
  final int age;
  final String bio;
  final List<int> gradient;
  final String emoji;
  const _Match({
    required this.name,
    required this.age,
    required this.bio,
    required this.gradient,
    required this.emoji,
  });
}

const _kInitialDeck = <_Match>[
  _Match(
    name: 'Quentin',
    age: 27,
    bio: '« Charcuterie · Crossfit · Bons vivants »',
    gradient: [0xFF888888, 0xFF2A2A2A],
    emoji: '🍖',
  ),
  _Match(
    name: 'Antoine',
    age: 31,
    bio: '« Banquier le jour, DJ la nuit. Authentique. »',
    gradient: [0xFF1F2937, 0xFF374151],
    emoji: '🎧',
  ),
  _Match(
    name: 'Léo',
    age: 24,
    bio: '« 6 mois Bali · pas sérieux · pas pressé »',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    emoji: '🌴',
  ),
  _Match(
    name: 'Maxime',
    age: 29,
    bio: '« Ingé blockchain. Cherche complice. »',
    gradient: [0xFF5E2E66, 0xFF8B4A8A],
    emoji: '⛓️',
  ),
  _Match(
    name: 'Hugo',
    age: 33,
    bio: '« Père divorcé · 2 enfants weekend sur 2 »',
    gradient: [0xFF6E94B5, 0xFFAEC4D8],
    emoji: '👨‍👧',
  ),
];

class _Card extends StatelessWidget {
  const _Card({required this.match, required this.drag});
  final _Match match;
  final Offset drag;

  @override
  Widget build(BuildContext context) {
    final angle = drag.dx / 800;
    final likeOpacity = (drag.dx / 100).clamp(0.0, 1.0);
    final nopeOpacity = (-drag.dx / 100).clamp(0.0, 1.0);
    return Transform.translate(
      offset: drag,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: match.gradient.map((h) => Color(h)).toList(),
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Emoji décoratif central
              Center(
                child: Text(
                  match.emoji,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
              // Stamps « LIKE » / « NOPE »
              Positioned(
                top: 30,
                left: 24,
                child: Opacity(
                  opacity: likeOpacity,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF66D7A1), width: 4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'LIKE',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF66D7A1),
                        ),
                      ),
                    ),
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFFD5068), width: 4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NOPE',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFD5068),
                        ),
                      ),
                    ),
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
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
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
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
