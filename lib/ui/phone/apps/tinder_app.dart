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
  int _likes = 0;
  int _nopes = 0;
  int _superLikes = 0;

  void _resolve(bool liked, {bool superLike = false}) {
    if (_deck.isEmpty) return;
    final m = _deck.first;
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
    final triggerMatch = liked && m.autoMatch;
    setState(() {
      _drag = Offset.zero;
      _returning = false;
      _deck.removeAt(0);
    });
    if (triggerMatch) _showMatch(m);
  }

  void _showMatch(_Match m) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xCCFD297B),
      builder: (ctx) => Center(
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
              Text(
                'It\'s a match!',
                style: GoogleFonts.crimsonPro(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFFFD297B),
                ),
              ),
              const SizedBox(height: 14),
              Text(m.emoji, style: const TextStyle(fontSize: 70)),
              const SizedBox(height: 10),
              Text(
                m.name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Ne réponds pas.',
                textAlign: TextAlign.center,
                style: GoogleFonts.crimsonPro(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
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
      ),
    );
  }

  void _openDetail(_Match m) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        builder: (_, scroll) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
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
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        m.gradient.map((h) => Color(h)).toList(),
                  ),
                ),
                child: Center(
                  child: Text(m.emoji,
                      style: const TextStyle(fontSize: 160)),
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
                        Text(m.name,
                            style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Text('${m.age}',
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
                        Text(m.location,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade700)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(m.bio,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF1A1A1A))),
                    const SizedBox(height: 14),
                    if (m.longBio != null)
                      Text(
                        m.longBio!,
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
      ),
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
                const Spacer(),
                // Idée 7 — Tinder Gold gimmick
                GestureDetector(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFFFFF8E1),
                        title: Text(
                          '⭐ Tinder Gold',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                        content: Text(
                          '147 personnes t\'ont likée.\n\n'
                          'Débloque-les avec Tinder Gold — 9,99 €/mois.\n\n'
                          'Ou bois un thé. C\'est gratuit.',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(
                              'Thé',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD97757),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'GOLD',
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
                            // Carte du haut : drag horizontal +
                            // drag up = super-like + long-press =
                            // détail.
                            GestureDetector(
                              onLongPress: () => _openDetail(_deck.first),
                              onPanUpdate: (d) {
                                if (_returning) return;
                                setState(() => _drag += d.delta);
                              },
                              onPanEnd: (_) {
                                if (_drag.dy < -120 &&
                                    _drag.dx.abs() < 100) {
                                  _resolve(true, superLike: true);
                                } else if (_drag.dx.abs() > 100) {
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
                _StatChip(label: 'Nopes', value: _nopes, color: const Color(0xFFFD5068)),
                _StatChip(label: '⭐', value: _superLikes, color: const Color(0xFF4FC3F7)),
                _StatChip(label: 'Likes', value: _likes, color: const Color(0xFF66D7A1)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Text(
              'Appui long pour voir le profil. Glisse vers le haut pour ⭐.\nTu n\'es pas obligée d\'être là ce soir.',
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 12,
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
  final String location;
  final String? longBio;
  final List<int> gradient;
  final String emoji;
  /// Si true, un match s'affiche après un swipe right. Sert au gag :
  /// quelques profils « It's a match! Ne réponds pas » qui dégagent.
  final bool autoMatch;
  /// Si true, profil canon spécial (Vincent / Tristan bug) — diffère
  /// le visuel et le comportement (carte tremblante, glitch fond).
  final bool isCanonGag;
  /// Si true, profil « fantôme » Tristan — non swipeable, juste pour
  /// le malaise.
  final bool ghost;
  const _Match({
    required this.name,
    required this.age,
    required this.bio,
    required this.location,
    required this.gradient,
    required this.emoji,
    this.longBio,
    this.autoMatch = false,
    this.isCanonGag = false,
    this.ghost = false,
  });
}

const _kInitialDeck = <_Match>[
  _Match(
    name: 'Quentin',
    age: 27,
    bio: '« Charcuterie · Crossfit · Bons vivants »',
    location: 'À 2 km',
    gradient: [0xFF888888, 0xFF2A2A2A],
    emoji: '🍖',
    longBio:
        'Commercial dans les vins. Crossfit 5 fois par semaine.\n'
        'Pas de relation toxique. Pas de drama. Pas de prise de tête.',
  ),
  _Match(
    name: 'Antoine',
    age: 31,
    bio: '« Banquier le jour, DJ la nuit. Authentique. »',
    location: 'À 800 m',
    gradient: [0xFF1F2937, 0xFF374151],
    emoji: '🎧',
    autoMatch: true,
    longBio:
        'Sciences Po, HEC, M&A chez Lazard. Set tous les jeudis au Wanderlust.\n'
        '« Authentique » est ma valeur cardinale.',
  ),
  _Match(
    name: 'Léo',
    age: 24,
    bio: '« 6 mois Bali · pas sérieux · pas pressé »',
    location: 'À 4 km',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    emoji: '🌴',
    longBio:
        'Surf, yoga, ayahuasca. J\'investis dans les NFT et la beauté intérieure.\n'
        '« Pas pressé » = je ne réponds pas avant 3 jours.',
  ),
  _Match(
    name: 'Maxime',
    age: 29,
    bio: '« Ingé blockchain. Cherche complice. »',
    location: 'À 1.2 km',
    gradient: [0xFF5E2E66, 0xFF8B4A8A],
    emoji: '⛓️',
    longBio:
        'Founder d\'une DAO. Mon LinkedIn parle pour moi.\n'
        'Cherche une complice qui comprend que je suis pris à 22h chaque soir.',
  ),
  _Match(
    name: 'Hugo',
    age: 33,
    bio: '« Père divorcé · 2 enfants week-end sur 2 »',
    location: 'À 6 km',
    gradient: [0xFF6E94B5, 0xFFAEC4D8],
    emoji: '👨‍👧',
    longBio:
        'Architecte d\'intérieur. Père séparé. Mes enfants passent avant tout.\n'
        'Sauf un week-end sur deux.',
  ),
  _Match(
    name: 'Damien',
    age: 35,
    bio: '« Avocat fiscaliste · Yacht à Antibes l\'été »',
    location: 'À 3 km',
    gradient: [0xFF3A4555, 0xFF6B7385],
    emoji: '⚖️',
    longBio:
        'Cabinet d\'affaires rue de Rivoli. Yacht 18 m basé à Antibes.\n'
        'Ma bio est honnête, vous voyez ce que vous achetez.',
  ),
  _Match(
    name: 'Sébastien',
    age: 28,
    bio: '« Sapio-sexuel · Médite 2 h/jour »',
    location: 'À 9 km',
    gradient: [0xFF2E7D32, 0xFF66BB6A],
    emoji: '🧘',
    autoMatch: true,
    longBio:
        'Je cherche une partenaire mentale d\'abord. Stoïcien.\n'
        'Je lis Marc Aurèle dans les transports.',
  ),
  _Match(
    name: 'Karim',
    age: 30,
    bio: '« Photographe · Hong Kong · Paris »',
    location: 'À 1 km',
    gradient: [0xFF1A1A1A, 0xFF8B4A8A],
    emoji: '📷',
    longBio:
        'Reportage, mariage, mode. Je voyage 3 semaines par mois.\n'
        'Hong Kong me manque. Tu connais ?',
  ),
  _Match(
    name: 'Pierre-Édouard',
    age: 32,
    bio: '« Chasseur de têtes · Polo · Tea Time »',
    location: 'À 11 km',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    emoji: '🎩',
    longBio:
        '13e génération de notaires. Polo le dimanche. Tea time strict 17h.\n'
        'Trois prénoms, on peut commencer par le premier.',
  ),
  _Match(
    name: 'Marc',
    age: 26,
    bio: '« Doctorant en philo · Ironique »',
    location: 'À 500 m',
    gradient: [0xFFFAEAD0, 0xFFFCEED4],
    emoji: '📚',
    longBio:
        'Thèse sur Levinas. Boursier ED. Je gagne 1 380 €.\n'
        'L\'ironie est mon outil. La précarité, ma méthode.',
  ),
  // Idée 3 — Vincent en match gag (sur-réel, futur beau-frère)
  _Match(
    name: 'Vincent',
    age: 36,
    bio: '« Closing · Yachts · Brunch dominical »',
    location: 'À 0.1 km',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    emoji: '💼',
    longBio:
        'Senior Sales chez Heng International.\n'
        'Frère de Tristan, le DG. Cherche une « real one ».\n'
        'Anglicismes assumés. Closing, deal, no problemo.',
    autoMatch: true, // Match gag → écran « Ne réponds pas. »
    isCanonGag: true,
  ),
  // Idée 4 — Tristan en bug, apparition fantôme
  _Match(
    name: 'T. ?',
    age: 32,
    bio: '« Profil indisponible · vu une fois dans ta zone »',
    location: 'Disparu',
    gradient: [0xFF0A0E1F, 0xFF1F2937],
    emoji: '👻',
    longBio:
        'Ce profil n\'existe pas vraiment.\n'
        'L\'algorithme dit qu\'il est passé une fois dans ton secteur, '
        'à 11h47 mardi dernier.\n\n'
        'Tu l\'as su autrement.',
    ghost: true,
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
    final superOpacity = (-drag.dy / 120).clamp(0.0, 1.0);
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
              // Stamp « SUPER LIKE » bleu vertical
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: superOpacity,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF4FC3F7), width: 4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SUPER LIKE',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF4FC3F7),
                          letterSpacing: 1,
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
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });
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
