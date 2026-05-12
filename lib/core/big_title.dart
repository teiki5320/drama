import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'day_ambience.dart';

/// Big serif title at the top of every screen, replacing AppBar.
class BigTitle extends StatelessWidget {
  const BigTitle(this.text, {super.key, this.subtitle, this.ambience});

  final String text;
  final String? subtitle;
  final DayAmbience? ambience;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.05,
                  ),
                ),
              ),
              if (ambience != null) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAE0CC).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ambience!.emoji,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          ambience!.label,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            _TypewriterSubtitle(text: subtitle!),
          ],
        ],
      ),
    );
  }
}

/// Sous-titre du jour qui s'écrit caractère par caractère à
/// l'ouverture du jour. Donne l'impression que la date / le lieu /
/// l'heure sont en train d'être tapés dans le carnet.
class _TypewriterSubtitle extends StatefulWidget {
  const _TypewriterSubtitle({required this.text});
  final String text;

  @override
  State<_TypewriterSubtitle> createState() => _TypewriterSubtitleState();
}

class _TypewriterSubtitleState extends State<_TypewriterSubtitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<int> _chars;

  @override
  void initState() {
    super.initState();
    final ms = (widget.text.length * 22).clamp(400, 1800);
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms),
    );
    _chars = IntTween(begin: 0, end: widget.text.length)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void didUpdateWidget(_TypewriterSubtitle old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _ctrl.reset();
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _chars,
      builder: (context, _) {
        return Text(
          widget.text.substring(0, _chars.value),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
        );
      },
    );
  }
}
