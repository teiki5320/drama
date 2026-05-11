import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/day_entry.dart';
import 'imessage_view.dart';

class DayNarrativeView extends StatelessWidget {
  const DayNarrativeView({super.key, required this.day});

  final DayEntry day;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    for (var i = 0; i < day.narrative.length; i++) {
      final b = day.narrative[i];
      Widget child;
      switch (b.type) {
        case NarrativeBlockType.prose:
          child = _Prose(text: b.content ?? '');
          break;
        case NarrativeBlockType.sectionTitle:
          child = _SectionTitle(text: b.content ?? '');
          break;
        case NarrativeBlockType.sms:
          child = IMessageView(
            conversationId: b.conversation,
            messages: b.messages ?? const [],
          );
          break;
        case NarrativeBlockType.image:
          child = _NarrativeImage(
            imageAsset: b.imageAsset,
            caption: b.content,
          );
          break;
        case NarrativeBlockType.quote:
          child = _Quote(text: b.content ?? '');
          break;
      }
      blocks.add(_FadeInUp(
        key: ValueKey('day-${day.id}-block-$i'),
        delay: Duration(milliseconds: 80 * i),
        child: child,
      ));
      blocks.add(const SizedBox(height: 14));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: blocks,
    );
  }
}

/// Animation d'entrée pour chaque bloc narratif : fade + léger glissement
/// vers le haut, en cascade. Donne l'impression que le carnet s'écrit
/// au fur et à mesure plutôt que d'apparaître d'un coup.
class _FadeInUp extends StatefulWidget {
  const _FadeInUp({
    super.key,
    required this.child,
    required this.delay,
  });

  final Widget child;
  final Duration delay;

  @override
  State<_FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<_FadeInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

class _Prose extends StatelessWidget {
  const _Prose({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 15.5,
        height: 1.6,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: GoogleFonts.crimsonPro(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}


class _NarrativeImage extends StatefulWidget {
  const _NarrativeImage({required this.imageAsset, required this.caption});

  final String? imageAsset;
  final String? caption;

  @override
  State<_NarrativeImage> createState() => _NarrativeImageState();
}

class _NarrativeImageState extends State<_NarrativeImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kenBurns;

  @override
  void initState() {
    super.initState();
    _kenBurns = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _kenBurns.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3EEDF),
            Color(0xFFE3D9C2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 42,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    );

    final Widget image;
    if (widget.imageAsset == null) {
      image = fallback;
    } else {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: AnimatedBuilder(
            animation: _kenBurns,
            builder: (context, _) {
              final t = Curves.easeInOut.transform(_kenBurns.value);
              final scale = 1.04 + 0.06 * t;
              final dx = -0.04 + 0.08 * t;
              final dy = -0.02 + 0.04 * t;
              return ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(dx * 20.0, dy * 20.0)
                      ..scale(scale, scale),
                    child: Image.asset(
                      widget.imageAsset!,
                      fit: BoxFit.cover,
                      cacheWidth: 1000,
                      errorBuilder: (_, __, ___) => fallback,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        image,
        if (widget.caption != null && widget.caption!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            widget.caption!,
            style: GoogleFonts.inter(
              fontStyle: FontStyle.italic,
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _Quote extends StatefulWidget {
  const _Quote({required this.text});
  final String text;

  @override
  State<_Quote> createState() => _QuoteState();
}

class _QuoteState extends State<_Quote> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fold;
  bool _hapticFired = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fold = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ctrl.forward();
      if (!_hapticFired) {
        _hapticFired = true;
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fold,
      builder: (context, child) {
        final t = _fold.value;
        return Opacity(
          opacity: t,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateX((1 - t) * -0.35),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 18),
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 36),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAE0CC), Color(0xFFFCEBC9)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '"',
              style: GoogleFonts.crimsonPro(
                fontSize: 64,
                fontWeight: FontWeight.w700,
                color: AppColors.accentOrange.withValues(alpha: 0.4),
                height: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary,
                height: 1.25,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
