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
        case NarrativeBlockType.beat:
          child = _Beat(text: b.content ?? '');
          break;
        case NarrativeBlockType.sceneBreak:
          child = _SceneBreak(text: b.content ?? '');
          break;
        case NarrativeBlockType.innerThought:
          child = _InnerThought(text: b.content ?? '');
          break;
        case NarrativeBlockType.stickyNote:
          child = _StickyNote(text: b.content ?? '');
          break;
        case NarrativeBlockType.list:
          child = _BulletList(text: b.content ?? '');
          break;
        case NarrativeBlockType.marginalia:
          child = _Marginalia(text: b.content ?? '');
          break;
        case NarrativeBlockType.dayFooter:
          child = _DayFooter(text: b.content ?? '');
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

  /// Rouge brique pour les phrases marquées `**ainsi**` dans le scénario.
  /// Réservé aux mots vraiment importants — pas un usage décoratif.
  static const _emphasisRed = Color(0xFFB02A23);

  /// Parse les emphases markdown inline :
  ///   - `**texte**` → gras, couleur rouge brique
  ///   - `*texte*` → italique
  /// Les autres occurrences de `*` restent littérales.
  static List<TextSpan> _parseEmphasis(String text, TextStyle base) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'\*\*([^*]+)\*\*|\*([^*]+)\*');
    int last = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: base));
      }
      if (m.group(1) != null) {
        spans.add(TextSpan(
          text: m.group(1),
          style: base.copyWith(
            color: _emphasisRed,
            fontWeight: FontWeight.w700,
          ),
        ));
      } else if (m.group(2) != null) {
        spans.add(TextSpan(
          text: m.group(2),
          style: base.copyWith(fontStyle: FontStyle.italic),
        ));
      }
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: base));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.inter(
      color: AppColors.textPrimary,
      fontSize: 15.5,
      height: 1.55,
    );

    if (!text.contains('*')) {
      return Text(text, style: base);
    }
    return Text.rich(TextSpan(children: _parseEmphasis(text, base)));
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
    // Tilt et décalage déterministes par image — chaque photo a sa
    // propre inclinaison, mais elle ne bouge pas entre deux passages
    // sur le même jour. Donne l'impression "vraie photo collée au
    // carnet" sans agiter le mise en page.
    final hash =
        (widget.imageAsset ?? widget.caption ?? 'fallback').hashCode.abs();
    final tilt = ((hash % 7) - 3) * 0.007; // -0.021 à +0.021 rad (~ ±1.2°)
    final offsetX = ((hash >> 3) % 5 - 2) * 1.2; // -2.4 à +2.4 px

    final fallback = Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3EEDF),
            Color(0xFFE3D9C2),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 42,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    );

    final Widget pictureContent;
    if (widget.imageAsset == null) {
      pictureContent = AspectRatio(aspectRatio: 4 / 3, child: fallback);
    } else {
      pictureContent = AspectRatio(
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
                    errorBuilder: (_, __, ___) =>
                        AspectRatio(aspectRatio: 4 / 3, child: fallback),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    // Cadre polaroid : bord blanc, marge basse plus épaisse (zone où
    // la légende d'une vraie polaroid serait écrite), ombre douce
    // décalée pour le relief, légère inclinaison.
    final polaroid = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(2, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: pictureContent,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.rotate(angle: tilt, child: polaroid),
          ),
          if (widget.caption != null && widget.caption!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.caption!,
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontStyle: FontStyle.italic,
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.45,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Phrase-choc isolée au milieu de la prose. Plus discrète qu'une
/// citation pleine page : italique Crimson Pro centré, taille moyenne,
/// pas d'encadré, juste de l'air autour. Sert à marquer une respiration
/// dramatique sans casser le flux narratif comme le ferait `_Quote`.
class _Beat extends StatelessWidget {
  const _Beat({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.crimsonPro(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.35,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

/// Séparateur de scène : petit timestamp ou ancrage gris clair centré
/// entre deux lignes horizontales fines. Marque une coupure visuelle
/// nette (changement de lieu, saut temporel) sans le poids d'un
/// `sectionTitle` qui prend la place d'un titre de chapitre.
class _SceneBreak extends StatelessWidget {
  const _SceneBreak({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final divider = Expanded(
      child: Container(
        height: 1,
        color: AppColors.textSecondary.withValues(alpha: 0.25),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          divider,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          divider,
        ],
      ),
    );
  }
}

/// Pensée intérieure de Shen, distincte de ce qu'elle "écrit" dans le
/// carnet. Italique Crimson Pro légèrement décalé à droite, fond très
/// pâle, comme une voix off entre deux paragraphes officiels.
class _InnerThought extends StatelessWidget {
  const _InnerThought({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18, right: 8, top: 4, bottom: 4),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAE0CC).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: AppColors.accentOrange.withValues(alpha: 0.5),
            width: 2.5,
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.crimsonPro(
          fontSize: 15.5,
          fontStyle: FontStyle.italic,
          color: AppColors.textPrimary,
          height: 1.55,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

/// Post-it Shen : note crue, liste, rappel. Fond crème jaune, légère
/// rotation, ombre douce. Crimson Pro, comme tracée au stylo. Ne prend
/// jamais toute la largeur — un vrai post-it tient dans un coin du
/// carnet. Angle et alignement varient légèrement selon le contenu
/// pour éviter l'effet "tous identiques".
class _StickyNote extends StatelessWidget {
  const _StickyNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final hash = text.hashCode.abs();
    final angle = ((hash % 5) - 2) * 0.011;
    final alignment = (hash % 3) == 0
        ? Alignment.center
        : ((hash % 2) == 0 ? Alignment.centerLeft : Alignment.centerRight);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Align(
        alignment: alignment,
        child: Transform.rotate(
          angle: angle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2C4),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Text(
                text,
                style: GoogleFonts.crimsonPro(
                  fontSize: 15.5,
                  color: AppColors.textPrimary,
                  height: 1.4,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Liste à puces : une ligne par item, contenu séparé par `\n`.
/// Indentation, puce orange, items rendus en Crimson Pro.
class _BulletList extends StatelessWidget {
  const _BulletList({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final items = text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Annotation marginale : commentaire après-coup de Shen, comme une
/// note ajoutée en relisant. Aligné à droite, plus petit, gris, avec
/// un fin tiret de séparation à gauche. Donne le sentiment du carnet
/// repris à un autre moment.
class _Marginalia extends StatelessWidget {
  const _Marginalia({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2, right: 4),
      child: Row(
        children: [
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: 1.5,
                  margin: const EdgeInsets.only(top: 10, right: 8),
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                ),
                Flexible(
                  child: Text(
                    text,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pied de page d'un jour : ligne fine, heure, courte phrase de clôture.
/// Marque visuellement la fin de l'entrée du carnet avant que la
/// ChoiceCard ne prenne le relais. Évite la rupture brutale narratif
/// → décision.
class _DayFooter extends StatelessWidget {
  const _DayFooter({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 1,
            color: AppColors.textSecondary.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
              height: 1.5,
            ),
          ),
        ],
      ),
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
