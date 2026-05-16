import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/romance.dart';

/// Rendu visuel d'un profil de romance. Procédural — pas de vraies photos
/// (cf. audit, contrainte environnement). Mais avec assez de variété
/// (gradient, initiale, emoji, label) pour donner un vrai "feeling" iOS.
///
/// 3 tailles : `small` (32) pour les chips, `medium` (50) pour les
/// avatars de liste, `large` (220+) pour les bulles photo.

enum RomanceAvatarSize { small, medium, large }

class RomanceAvatar extends StatelessWidget {
  const RomanceAvatar({
    super.key,
    required this.profile,
    this.size = RomanceAvatarSize.medium,
    this.photoIdx = 0,
  });
  final RomanceProfile profile;
  final RomanceAvatarSize size;
  /// Index dans `photoEmojis` (utilisé pour rendre des "photos différentes").
  final int photoIdx;

  double get _dim {
    switch (size) {
      case RomanceAvatarSize.small:
        return 32;
      case RomanceAvatarSize.medium:
        return 50;
      case RomanceAvatarSize.large:
        return 220;
    }
  }

  @override
  Widget build(BuildContext context) {
    final emoji = profile.photoEmojis.isNotEmpty
        ? profile.photoEmojis[photoIdx % profile.photoEmojis.length]
        : profile.emoji;
    return ClipOval(
      child: SizedBox(
        width: _dim,
        height: _dim,
        child: _GradientCard(
          gradient: profile.gradient,
          emoji: emoji,
          initial: profile.name.isNotEmpty ? profile.name[0] : '?',
          size: size,
        ),
      ),
    );
  }
}

/// Carte rectangulaire (4:5) utilisée pour les photos partagées dans
/// les threads DM. Gradient + emoji + caption overlay en bas.
class RomanceSharedPhoto extends StatelessWidget {
  const RomanceSharedPhoto({
    super.key,
    required this.profile,
    required this.caption,
    required this.time,
    this.photoIdx = 0,
  });
  final RomanceProfile profile;
  final String caption;
  final String time;
  final int photoIdx;

  @override
  Widget build(BuildContext context) {
    final emoji = profile.photoEmojis.isNotEmpty
        ? profile.photoEmojis[photoIdx % profile.photoEmojis.length]
        : profile.emoji;
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _GradientCard(
              gradient: profile.gradient,
              emoji: emoji,
              initial: profile.name.isNotEmpty ? profile.name[0] : '?',
              size: RomanceAvatarSize.large,
              showInitial: false,
            ),
            // Vignette + caption en bas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.fromLTRB(10, 18, 10, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Text(
                  caption,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ),
            // Heure en haut à droite
            Positioned(
              top: 8,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte interne — gradient riche, initiale grosse, emoji + texture
/// procédurale (cercles flous évoquant du bokeh).
class _GradientCard extends StatelessWidget {
  const _GradientCard({
    required this.gradient,
    required this.emoji,
    required this.initial,
    required this.size,
    this.showInitial = true,
  });
  final List<int> gradient;
  final String emoji;
  final String initial;
  final RomanceAvatarSize size;
  final bool showInitial;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BokehPainter(
        colorTop: Color(gradient.first),
        colorBot: Color(gradient.last),
        seed: emoji.hashCode + initial.hashCode,
      ),
      child: Center(
        child: _content(),
      ),
    );
  }

  Widget _content() {
    switch (size) {
      case RomanceAvatarSize.small:
        return Text(emoji, style: const TextStyle(fontSize: 16));
      case RomanceAvatarSize.medium:
        return Text(emoji, style: const TextStyle(fontSize: 22));
      case RomanceAvatarSize.large:
        return Stack(
          alignment: Alignment.center,
          children: [
            // Initiale géante en filigrane
            if (showInitial)
              Text(
                initial.toUpperCase(),
                style: GoogleFonts.crimsonPro(
                  fontSize: 120,
                  color: Colors.white.withValues(alpha: 0.18),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            Text(emoji, style: const TextStyle(fontSize: 80)),
          ],
        );
    }
  }
}

/// Peint un dégradé "bokeh" : 2 couleurs verticales + 5-8 cercles flous
/// translucides positionnés selon le seed pour donner un côté "photo
/// réelle floutée". Stable à travers les rebuilds (seed = hash du profil).
class _BokehPainter extends CustomPainter {
  _BokehPainter({
    required this.colorTop,
    required this.colorBot,
    required this.seed,
  });
  final Color colorTop;
  final Color colorBot;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    // Background : dégradé vertical
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colorTop, colorBot],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Bokeh : 6 cercles flous translucides
    final rng = Random(seed);
    for (var i = 0; i < 6; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final r = (size.shortestSide * (0.05 + rng.nextDouble() * 0.18));
      final opacity = 0.06 + rng.nextDouble() * 0.10;
      final color = i.isEven ? Colors.white : Colors.black;
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.6);
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }

    // Vignette légère en haut/bas
    final vignettePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.15),
          Colors.transparent,
          Colors.black.withValues(alpha: 0.20),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  @override
  bool shouldRepaint(_BokehPainter old) =>
      old.colorTop != colorTop ||
      old.colorBot != colorBot ||
      old.seed != seed;
}
