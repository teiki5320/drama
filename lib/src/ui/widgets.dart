import 'package:flutter/material.dart';

import '../models.dart';
import '../palette.dart';

/// Pastille dégradée avec initiales, comme les avatars de Messages.
class GradientAvatar extends StatelessWidget {
  const GradientAvatar({super.key, required this.def, this.size = 44});

  final ThreadDef def;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [def.gradientTop, def.gradientBottom],
        ),
      ),
      child: Text(
        def.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}

/// Les trois points animés « en train d'écrire… ».
class TypingDots extends StatefulWidget {
  const TypingDots({super.key, required this.color});

  final Color color;

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_controller.value - i * 0.15) % 1.0;
            final opacity =
                phase < 0.3 ? 0.35 + (phase / 0.3) * 0.65 : 1.0 - ((phase - 0.3) / 0.7) * 0.65;
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
              child: Opacity(
                opacity: opacity.clamp(0.35, 1.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Pastille rouge « À RÉPONDRE » de la liste des conversations.
class ReplyPill extends StatelessWidget {
  const ReplyPill({super.key});

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: pal.pill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'À RÉPONDRE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
