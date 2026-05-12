import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/day_entry.dart';
import 'imessage_view.dart';

class DayNarrativeView extends StatelessWidget {
  const DayNarrativeView({
    super.key,
    required this.day,
    this.staticReplay = false,
  });

  final DayEntry day;

  /// En relecture du journal (jour déjà joué), on affiche tout d'un
  /// coup : pas de typewriter sur les sceneDialogue, pas de tap pour
  /// avancer. `false` par défaut pour les jours en cours.
  final bool staticReplay;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    int sceneBreakCount = 0;
    bool isFirstProse = true;
    for (var i = 0; i < day.narrative.length; i++) {
      final b = day.narrative[i];
      Widget child;
      switch (b.type) {
        case NarrativeBlockType.prose:
          final proseText = b.content ?? '';
          // Le drop cap n'est pertinent que sur une vraie prose qui
          // remplit plusieurs lignes — sinon la grosse lettre flotte
          // toute seule à côté d'un fragment de phrase.
          final isFirstAndLongEnough = isFirstProse && proseText.length >= 80;
          child = _Prose(
            text: proseText,
            dropCap: isFirstAndLongEnough,
            speaker: b.speaker,
          );
          isFirstProse = false;
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
          sceneBreakCount++;
          child = _SceneBreak(
            text: b.content ?? '',
            chapterNumber: sceneBreakCount,
          );
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
        case NarrativeBlockType.inlineQuote:
          child = _InlineQuote(text: b.content ?? '');
          break;
        case NarrativeBlockType.sceneDialogue:
          child = _SceneDialogue(
            key: ValueKey('scene-${day.id}-$i'),
            location: b.location ?? '',
            backgroundImageAsset: b.backgroundImageAsset,
            lines: b.lines ?? const [],
            staticReplay: staticReplay,
          );
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

/// Parse les emphases markdown inline (`**texte**` rouge gras / `*texte*`
/// italique) en TextSpans. `redT` permet d'animer la couleur du rouge
/// (0 = noir, 1 = rouge brique plein) — utilisé par `_Prose` pour son
/// reveal différé. Les autres widgets (sticky note, etc.) appellent
/// avec la valeur par défaut 1.0.
List<TextSpan> _parseEmphasisSpans(
  String text,
  TextStyle base, {
  double redT = 1.0,
}) {
  final spans = <TextSpan>[];
  final pattern = RegExp(r'\*\*([^*]+)\*\*|\*([^*]+)\*');
  int last = 0;
  final lerpRed = Color.lerp(
    AppColors.textPrimary,
    _Prose._emphasisRed,
    redT,
  )!;
  for (final m in pattern.allMatches(text)) {
    if (m.start > last) {
      spans.add(TextSpan(text: text.substring(last, m.start), style: base));
    }
    if (m.group(1) != null) {
      spans.add(TextSpan(
        text: m.group(1),
        style: base.copyWith(
          color: lerpRed,
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

class _Prose extends StatefulWidget {
  const _Prose({
    required this.text,
    this.dropCap = false,
    this.speaker,
  });
  final String text;

  /// Si true, la toute première lettre est rendue en très gros
  /// Crimson Pro à côté de la prose. Réservé à la première prose
  /// du jour pour ouvrir comme un livre.
  final bool dropCap;

  /// Id de personnage qui parle dans ce bloc (dialogue). Affiche un
  /// mini avatar 16dp à gauche du paragraphe. Voir
  /// `_speakerAvatar()` pour le mapping.
  final String? speaker;

  /// Rouge brique pour les phrases marquées `**ainsi**` dans le scénario.
  /// Réservé aux mots vraiment importants — pas un usage décoratif.
  static const _emphasisRed = Color(0xFFB02A23);

  @override
  State<_Prose> createState() => _ProseState();
}

class _ProseState extends State<_Prose> with SingleTickerProviderStateMixin {
  late final AnimationController _redCtrl;
  late final Animation<double> _redReveal;

  // Surbrillance pêche selon la proximité au centre du viewport.
  // 0 = loin, 1 = au centre. Recalculée à chaque scroll via le
  // listener attaché à la ScrollPosition parente.
  ScrollPosition? _scrollPos;
  double _proximity = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPos = Scrollable.maybeOf(context)?.position;
    if (newPos != _scrollPos) {
      _scrollPos?.removeListener(_updateProximity);
      _scrollPos = newPos;
      _scrollPos?.addListener(_updateProximity);
      // Première mesure après layout.
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateProximity());
    }
  }

  void _updateProximity() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos = box.localToGlobal(Offset.zero);
    final viewportH = MediaQuery.of(context).size.height;
    final blockCenter = pos.dy + box.size.height / 2;
    final dist = (blockCenter - viewportH / 2).abs();
    // Fenêtre douce : ±220 px autour du centre.
    final p = (1 - (dist / 220)).clamp(0.0, 1.0);
    if ((p - _proximity).abs() > 0.03) {
      setState(() => _proximity = p);
    }
  }

  @override
  void initState() {
    super.initState();
    _redCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _redReveal = CurvedAnimation(parent: _redCtrl, curve: Curves.easeOut);
    // Léger délai pour que la prose entre d'abord en noir, puis les
    // rouges s'enflamment juste après.
    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) _redCtrl.forward();
    });
  }

  @override
  void dispose() {
    _scrollPos?.removeListener(_updateProximity);
    _redCtrl.dispose();
    super.dispose();
  }


  Widget _wrapWithSpeaker(Widget child) {
    final avatar = _speakerAvatar(widget.speaker!);
    if (avatar == null) return child;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 4),
          child: avatar,
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _wrapWithDropCap(Widget child, String first, TextStyle base) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 4),
          child: Text(
            first,
            style: GoogleFonts.crimsonPro(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.0,
              letterSpacing: -1,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.inter(
      color: AppColors.textPrimary,
      fontSize: 15.5,
      height: 1.55,
    );

    // Drop cap : on retire la première lettre de la prose pour la
    // rendre en gros à part. Le reste du texte garde ses asterisques.
    String mainText = widget.text;
    String? capLetter;
    if (widget.dropCap && widget.text.isNotEmpty) {
      capLetter = widget.text[0];
      mainText = widget.text.substring(1).trimLeft();
    }

    return AnimatedBuilder(
      animation: _redReveal,
      builder: (context, _) {
        Widget content;
        if (mainText.contains('*')) {
          content = Text.rich(
            TextSpan(children: _parseEmphasisSpans(mainText, base, redT: _redReveal.value)),
          );
        } else {
          content = Text(mainText, style: base);
        }

        if (capLetter != null) {
          content = _wrapWithDropCap(content, capLetter, base);
        }
        if (widget.speaker != null) {
          content = _wrapWithSpeaker(content);
        }

        // Highlight pêche autour du paragraphe au centre du viewport.
        // Très léger (max 8 % d'alpha) — c'est un guide de lecture, pas
        // une mise en avant criarde.
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFAE0CC).withValues(alpha: _proximity * 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: content,
        );
      },
    );
  }
}

/// Mini avatar 18dp à gauche d'un paragraphe de dialogue. Mappe l'id
/// passé en `speaker` vers le portrait du perso s'il existe.
/// Retourne `null` si l'id n'est pas reconnu (le bloc s'affichera
/// alors sans avatar).
({String? photo, String? emoji})? _resolveSpeaker(String id) {
  String? photo;
  String? emoji;
  switch (id.toLowerCase()) {
    case 'tristan':
    case 't_heng':
      photo = 'assets/photos/characters/t_heng.png';
      break;
    case 'maman':
    case 'helene':
    case 'helene_marchand':
      photo = 'assets/photos/characters/helene_marchand.png';
      break;
    case 'camille':
    case 'camille_rx':
      photo = 'assets/photos/characters/camille_rx.png';
      break;
    case 'vincent':
    case 'vincent_h':
      photo = 'assets/photos/characters/vincent_h.png';
      break;
    case 'madame_heng':
    case 'heng_lihua':
      photo = 'assets/photos/characters/heng_lihua.png';
      break;
    case 'tante_mei':
    case 'mei_fujian':
      photo = 'assets/photos/characters/mei_fujian.png';
      break;
    case 'shen':
    case 'shen_y':
      photo = 'assets/photos/characters/shen_y.jpeg';
      break;
    case 'dr_aubin':
    case 'aubin':
      emoji = '🩺';
      break;
    case 'infirmiere':
    case 'infirmière':
      emoji = '👩‍⚕️';
      break;
    case 'notaire':
      emoji = '✒️';
      break;
    default:
      return null;
  }
  return (photo: photo, emoji: emoji);
}

Widget? _speakerAvatar(String id, {double size = 20}) {
  final r = _resolveSpeaker(id);
  if (r == null) return null;
  return _SpeakerBubble(photo: r.photo, emoji: r.emoji, size: size);
}

class _SpeakerBubble extends StatefulWidget {
  const _SpeakerBubble({
    required this.photo,
    required this.emoji,
    this.size = 20,
  });
  final String? photo;
  final String? emoji;
  final double size;

  @override
  State<_SpeakerBubble> createState() => _SpeakerBubbleState();
}

class _SpeakerBubbleState extends State<_SpeakerBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_ctrl);
    Future.delayed(const Duration(milliseconds: 360), () {
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
    final fallbackText = Text(
      widget.emoji ?? '?',
      style: TextStyle(fontSize: widget.size * 0.55),
    );
    final inner = widget.photo != null
        ? Image.asset(
            widget.photo!,
            fit: BoxFit.cover,
            cacheWidth: 96,
            errorBuilder: (_, __, ___) => fallbackText,
          )
        : fallbackText;
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          color: Color(0xFFEFE9D8),
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        child: inner,
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
    with TickerProviderStateMixin {
  late final AnimationController _kenBurns;
  late final AnimationController _reveal;
  late final Animation<double> _revealCurve;

  @override
  void initState() {
    super.initState();
    _kenBurns = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
    // Reveal : la polaroid arrive un peu plus inclinée et translatée
    // en haut, puis "se pose" sur sa rotation finale. Durée 700ms,
    // easeOut, comme posée à la main sur le carnet.
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _revealCurve = CurvedAnimation(parent: _reveal, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) _reveal.forward();
    });
  }

  @override
  void dispose() {
    _kenBurns.dispose();
    _reveal.dispose();
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
          AnimatedBuilder(
            animation: _revealCurve,
            builder: (context, child) {
              final t = _revealCurve.value;
              // Au début : double l'inclinaison + translation haute,
              // se résorbe vers le tilt final + offsetX.
              final liveTilt = tilt * (2 - t);
              final liveDx = offsetX * t;
              final liveDy = (1 - t) * -8.0;
              return Transform.translate(
                offset: Offset(liveDx, liveDy),
                child: Transform.rotate(angle: liveTilt, child: child),
              );
            },
            child: polaroid,
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
class _Beat extends StatefulWidget {
  const _Beat({required this.text});
  final String text;

  @override
  State<_Beat> createState() => _BeatState();
}

class _BeatState extends State<_Beat> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<int> _charsRevealed;

  @override
  void initState() {
    super.initState();
    final ms = (widget.text.length * 28).clamp(800, 4000);
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms),
    );
    _charsRevealed = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    // Court délai pour laisser le _FadeInUp parent terminer son entrée
    Future.delayed(const Duration(milliseconds: 280), () {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: AnimatedBuilder(
        animation: _charsRevealed,
        builder: (context, _) {
          final shown = widget.text.substring(0, _charsRevealed.value);
          return Text(
            shown,
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.35,
              letterSpacing: 0.1,
            ),
          );
        },
      ),
    );
  }
}

/// Séparateur de scène avec chiffre romain optionnel au-dessus.
/// Les deux lignes horizontales se tracent à l'apparition, du centre
/// vers les extrémités, pour rendre le passage de scène vivant.
class _SceneBreak extends StatefulWidget {
  const _SceneBreak({required this.text, this.chapterNumber});
  final String text;
  final int? chapterNumber;

  @override
  State<_SceneBreak> createState() => _SceneBreakState();
}

class _SceneBreakState extends State<_SceneBreak>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _spread;

  static const _romanNumerals = [
    '', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
    'XI', 'XII', 'XIII', 'XIV', 'XV',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _spread = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _roman {
    final n = widget.chapterNumber;
    if (n == null || n < 1 || n >= _romanNumerals.length) return '';
    return _romanNumerals[n];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          if (_roman.isNotEmpty) ...[
            Text(
              _roman,
              style: GoogleFonts.crimsonPro(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: AppColors.accentOrange.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
          ],
          AnimatedBuilder(
            animation: _spread,
            builder: (context, _) {
              final t = _spread.value;
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: t,
                        child: Container(
                          height: 1,
                          color: AppColors.textSecondary
                              .withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.text,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: t,
                        child: Container(
                          height: 1,
                          color: AppColors.textSecondary
                              .withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
    final shenAvatar = _speakerAvatar('shen', size: 18);
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shenAvatar != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 10),
              child: shenAvatar,
            ),
          ],
          Expanded(
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
          ),
        ],
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
              child: Builder(builder: (context) {
                final base = GoogleFonts.crimsonPro(
                  fontSize: 15.5,
                  color: AppColors.textPrimary,
                  height: 1.4,
                  letterSpacing: 0.1,
                );
                if (!text.contains('*')) {
                  return Text(text, style: base);
                }
                return Text.rich(
                  TextSpan(children: _parseEmphasisSpans(text, base)),
                );
              }),
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

/// Variante "inline" de la citation : plus petite que `_Quote` pleine
/// page, indentée à 80% de largeur, avec une barre verticale orange
/// à gauche. Pour les phrases marquantes intermédiaires qui ne
/// méritent pas la grosse boîte gradient.
class _InlineQuote extends StatelessWidget {
  const _InlineQuote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 12, 14),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColors.accentOrange.withValues(alpha: 0.7),
              width: 3.5,
            ),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.crimsonPro(
            fontSize: 22,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            height: 1.35,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

/// Scène de dialogue style "visual novel" sobre, occupant 80% de la
/// hauteur viewport. Photo de scène en arrière-plan flou (ou fond noir
/// si pas de backgroundImageAsset), polaroid du speaker, boîte de
/// dialogue en bas avec speaker label en small caps + texte typewriter.
/// Tap n'importe où pour avancer (ou skipper le typewriter en cours).
/// Quand `staticReplay` est true, on affiche directement la dernière
/// réplique sans animation — usage relecture du journal.
class _SceneDialogue extends StatefulWidget {
  const _SceneDialogue({
    super.key,
    required this.location,
    required this.lines,
    this.backgroundImageAsset,
    this.staticReplay = false,
  });

  final String location;
  final String? backgroundImageAsset;
  final List<DialogueLine> lines;
  final bool staticReplay;

  @override
  State<_SceneDialogue> createState() => _SceneDialogueState();
}

class _SceneDialogueState extends State<_SceneDialogue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _typeCtrl;
  late Animation<int> _chars;
  int _lineIndex = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _typeCtrl = AnimationController(vsync: this);
    if (widget.lines.isEmpty) {
      _finished = true;
    } else if (widget.staticReplay) {
      // Relecture : on saute à la dernière ligne, entièrement révélée.
      _lineIndex = widget.lines.length - 1;
      _finished = true;
    } else {
      _startLine(0);
    }
  }

  void _startLine(int i) {
    _lineIndex = i;
    final text = widget.lines[i].text;
    final cleaned = _stripMarkers(text);
    _typeCtrl.duration =
        Duration(milliseconds: (cleaned.length * 28).clamp(800, 5000));
    _chars = IntTween(begin: 0, end: cleaned.length)
        .animate(CurvedAnimation(parent: _typeCtrl, curve: Curves.easeOut));
    _typeCtrl.reset();
    _typeCtrl.forward();
  }

  /// Pour le compteur typewriter on retire les marqueurs `**`/`*` :
  /// on veut révéler le texte « visible », pas les caractères de balise.
  static String _stripMarkers(String s) =>
      s.replaceAll('**', '').replaceAll('*', '');

  void _onTap() {
    if (_finished) {
      // Plus rien à faire : on est sur la dernière ligne déjà complète.
      // (Le bouton "Skip" disparaît à ce stade.)
      return;
    }
    final lineDone = _typeCtrl.value >= 1.0;
    if (!lineDone) {
      // Termine le typewriter sur la ligne courante.
      _typeCtrl.value = 1.0;
      return;
    }
    // Ligne entièrement révélée → passer à la suivante.
    if (_lineIndex + 1 >= widget.lines.length) {
      setState(() => _finished = true);
      return;
    }
    setState(() => _startLine(_lineIndex + 1));
  }

  void _skipAll() {
    _typeCtrl.value = 1.0;
    setState(() {
      _lineIndex = widget.lines.length - 1;
      _finished = true;
    });
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lines.isEmpty) return const SizedBox.shrink();
    final viewportH = MediaQuery.of(context).size.height;
    final sceneHeight = viewportH * 0.8;

    final line = widget.lines[_lineIndex];
    final speakerInfo = _resolveSpeaker(line.speaker);

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: sceneHeight,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Arrière-plan : photo de scène floutée si dispo, sinon noir.
            if (widget.backgroundImageAsset != null)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Image.asset(
                  widget.backgroundImageAsset!,
                  fit: BoxFit.cover,
                  cacheWidth: 1200,
                  errorBuilder: (_, __, ___) => Container(color: Colors.black),
                ),
              ),
            // Voile sombre pour faire ressortir le texte.
            Container(color: Colors.black.withValues(alpha: 0.45)),

            // Header location + bouton skip (en haut).
            Positioned(
              top: 12,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.location,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                  if (!_finished)
                    InkWell(
                      onTap: _skipAll,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          'Passer',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Polaroid speaker au centre.
            Positioned.fill(
              top: 40,
              bottom: 180,
              child: Center(
                child: _ScenePortrait(
                  key: ValueKey('portrait-$_lineIndex-${line.speaker}'),
                  speakerInfo: speakerInfo,
                ),
              ),
            ),

            // Boîte de dialogue en bas.
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: AnimatedBuilder(
                animation: _typeCtrl,
                builder: (context, _) {
                  final clean = _stripMarkers(line.text);
                  final shown = clean.substring(
                    0,
                    _chars.value.clamp(0, clean.length),
                  );
                  final lineDone = _typeCtrl.value >= 1.0 || widget.staticReplay;
                  return Container(
                    padding:
                        const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF5E5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          line.label,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          shown,
                          style: GoogleFonts.crimsonPro(
                            fontSize: 17,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _finished
                                  ? '— fin de scène —'
                                  : (lineDone
                                      ? 'tap →'
                                      : '...'),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.7),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Portrait centré dans la scène : la photo du speaker rendue
/// polaroid (cadre blanc, ombre), à environ 180dp de large.
class _ScenePortrait extends StatelessWidget {
  const _ScenePortrait({super.key, required this.speakerInfo});
  final ({String? photo, String? emoji})? speakerInfo;

  @override
  Widget build(BuildContext context) {
    final inner = speakerInfo?.photo != null
        ? Image.asset(
            speakerInfo!.photo!,
            fit: BoxFit.cover,
            cacheWidth: 600,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE3D9C2),
              alignment: Alignment.center,
              child: Text(
                speakerInfo?.emoji ?? '?',
                style: const TextStyle(fontSize: 64),
              ),
            ),
          )
        : Container(
            color: const Color(0xFFE3D9C2),
            alignment: Alignment.center,
            child: Text(
              speakerInfo?.emoji ?? '?',
              style: const TextStyle(fontSize: 64),
            ),
          );
    return Container(
      width: 180,
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: inner,
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
