import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../data/ace_j1.dart';
import '../../models/ace_scene.dart';
import 'ace_audio.dart';

/// Écran ACE — BD animée à la Ace Attorney.
///
/// Empile : background flouté → sprite(s) → cartouche dialogue en bas.
/// Tap n'importe où pour avancer au beat suivant.
class AceScreen extends StatefulWidget {
  const AceScreen({super.key});

  @override
  State<AceScreen> createState() => _AceScreenState();
}

class _AceScreenState extends State<AceScreen> {
  late final AceScene scene;
  int beatIndex = 0;

  /// Notifie le pourcentage de texte révélé (0.0 → 1.0). On l'utilise
  /// pour décider si un tap doit "compléter le texte" ou "avancer".
  final ValueNotifier<double> _typeProgress = ValueNotifier(0.0);

  /// Ambiance courante. Mémorisée parce que `BeatAmbient` peut être
  /// `null` sur un beat (= "garde la précédente").
  BeatAmbient _currentAmbient = BeatAmbient.none;

  @override
  void initState() {
    super.initState();
    scene = aceJ1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyBeatAudio(scene.beats.first);
    });
  }

  @override
  void dispose() {
    AceAudio.instance.stopAll();
    _typeProgress.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_typeProgress.value < 1.0) {
      // Texte en cours de frappe : on saute à la fin.
      _typeProgress.value = 1.0;
      return;
    }
    _next();
  }

  void _applyBeatAudio(AceBeat beat) {
    if (beat.sfx == BeatSfx.impact) {
      AceAudio.instance.playSfx(AceSfx.impact, volume: 0.8);
    } else if (beat.sfx == BeatSfx.ring) {
      AceAudio.instance.playSfx(AceSfx.ring, volume: 0.6);
    }
    if (beat.ambient != null && beat.ambient != _currentAmbient) {
      _currentAmbient = beat.ambient!;
      AceAudio.instance.setAmbient(_mapAmbient(beat.ambient!));
    }
  }

  AceAmbient _mapAmbient(BeatAmbient a) => switch (a) {
        BeatAmbient.none => AceAmbient.none,
        BeatAmbient.rain => AceAmbient.rain,
      };

  void _next() {
    if (beatIndex < scene.beats.length - 1) {
      HapticFeedback.selectionClick();
      AceAudio.instance.playSfx(AceSfx.advance, volume: 0.5);
      setState(() {
        beatIndex++;
        _typeProgress.value = 0.0;
      });
      _applyBeatAudio(scene.beats[beatIndex]);
    }
  }

  void _prev() {
    if (beatIndex > 0) {
      HapticFeedback.selectionClick();
      AceAudio.instance.playSfx(AceSfx.advance, volume: 0.4);
      setState(() {
        beatIndex--;
        _typeProgress.value = 0.0;
      });
      _applyBeatAudio(scene.beats[beatIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final beat = scene.beats[beatIndex];
    final isLast = beatIndex == scene.beats.length - 1;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      onHorizontalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) > 200) {
          _prev();
        } else if ((details.primaryVelocity ?? 0) < -200) {
          _next();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _Background(asset: beat.background, key: ValueKey(beat.background)),
          _SpriteLayer(sprites: beat.sprites),
          _TopBar(
            title: scene.title,
            location: scene.location,
            progress: (beatIndex + 1) / scene.beats.length,
            muted: AceAudio.instance.muted,
            onToggleMute: () {
              setState(() {
                AceAudio.instance.muted = !AceAudio.instance.muted;
                if (AceAudio.instance.muted) {
                  AceAudio.instance.stopAll();
                } else {
                  AceAudio.instance.setAmbient(_mapAmbient(_currentAmbient));
                }
              });
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: _DialogueBox(
                beat: beat,
                isLast: isLast,
                typeProgress: _typeProgress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({super.key, required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: SizedBox.expand(
        key: ValueKey(asset),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black87),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withValues(alpha: 0.18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpriteLayer extends StatelessWidget {
  const _SpriteLayer({required this.sprites});
  final List<AceSprite> sprites;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final h = c.maxHeight;
      // Hauteur cible du sprite ≈ 65% de l'écran (haut du corps grand).
      final spriteHeight = h * 0.65;
      return Stack(
        fit: StackFit.expand,
        children: [
          for (final s in sprites)
            _SpriteWidget(
              sprite: s,
              height: spriteHeight,
              parentWidth: c.maxWidth,
            ),
        ],
      );
    });
  }
}

class _SpriteWidget extends StatelessWidget {
  const _SpriteWidget({
    required this.sprite,
    required this.height,
    required this.parentWidth,
  });

  final AceSprite sprite;
  final double height;
  final double parentWidth;

  @override
  Widget build(BuildContext context) {
    Alignment align;
    EdgeInsets pad;
    switch (sprite.position) {
      case SpritePosition.left:
        align = Alignment.bottomLeft;
        pad = const EdgeInsets.only(left: 12, bottom: 180);
        break;
      case SpritePosition.right:
        align = Alignment.bottomRight;
        pad = const EdgeInsets.only(right: 12, bottom: 180);
        break;
      case SpritePosition.center:
        align = Alignment.bottomCenter;
        pad = const EdgeInsets.only(bottom: 180);
        break;
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Padding(
        key: ValueKey('${sprite.asset}-${sprite.position}'),
        padding: pad,
        child: Align(
          alignment: align,
          child: Image.asset(
            sprite.asset,
            height: height * sprite.scale,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.location,
    required this.progress,
    required this.muted,
    required this.onToggleMute,
  });

  final String title;
  final String location;
  final double progress;
  final bool muted;
  final VoidCallback onToggleMute;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.crimsonPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          location,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.white70,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _RoundIconBtn(
                  icon: muted ? Icons.volume_off : Icons.volume_up,
                  onTap: onToggleMute,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accentOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconBtn extends StatelessWidget {
  const _RoundIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class _DialogueBox extends StatelessWidget {
  const _DialogueBox({
    required this.beat,
    required this.isLast,
    required this.typeProgress,
  });
  final AceBeat beat;
  final bool isLast;
  final ValueNotifier<double> typeProgress;

  @override
  Widget build(BuildContext context) {
    final isThought = beat.kind == BeatKind.thought;
    final isNarration = beat.kind == BeatKind.narration;
    final bgColor = isThought
        ? const Color(0xFF1B1B2E).withValues(alpha: 0.92)
        : isNarration
            ? const Color(0xFF181818).withValues(alpha: 0.88)
            : const Color(0xFF111418).withValues(alpha: 0.92);
    final borderColor = isThought
        ? Colors.purple.withValues(alpha: 0.4)
        : AppColors.accentOrange.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (beat.speakerLabel != null && !isThought && !isNarration)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  beat.speakerLabel!.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.accentOrange,
                  ),
                ),
              )
            else if (isThought)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '· pensée ·',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: Colors.purple.shade200,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            _TypewriterText(
              text: beat.text,
              italic: isThought,
              progress: typeProgress,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isLast ? 'Fin de J1 — retour Carnet' : 'Tap pour continuer',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white54,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isLast ? Icons.check_circle_outline : Icons.touch_app,
                  size: 12,
                  color: Colors.white54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypewriterText extends StatefulWidget {
  const _TypewriterText({
    required this.text,
    required this.italic,
    required this.progress,
  });
  final String text;
  final bool italic;

  /// Notifie [_AceScreenState] de l'avancement de la frappe (0..1). Un
  /// tap qui force `.value = 1.0` saute à la fin de la frappe sans
  /// avancer au beat suivant.
  final ValueNotifier<double> progress;

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _lastTickChar = 0;

  @override
  void initState() {
    super.initState();
    _start();
    widget.progress.addListener(_handleExternal);
  }

  void _handleExternal() {
    if (widget.progress.value >= 1.0 && _ctrl.value < 1.0) {
      _ctrl.value = 1.0;
    }
  }

  void _start() {
    final ms = (widget.text.length * 18).clamp(400, 2400);
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ms),
    );
    _ctrl.addListener(() {
      widget.progress.value = _ctrl.value;
      _maybeTick();
    });
    widget.progress.value = 0.0;
    _lastTickChar = 0;
    _ctrl.forward();
  }

  /// Joue un petit "tick" toutes les 3 lettres (utilisable comme machine
  /// à écrire). On évite de jouer sur les espaces, et on cap à ~1 tick
  /// toutes les 60 ms pour ne pas saturer.
  void _maybeTick() {
    final n = (widget.text.length * _ctrl.value).round();
    if (n <= _lastTickChar) return;
    if (n - _lastTickChar < 3) return;
    final c = n - 1 < widget.text.length ? widget.text[n - 1] : ' ';
    if (c == ' ' || c == '\n') {
      _lastTickChar = n;
      return;
    }
    _lastTickChar = n;
    AceAudio.instance.playSfx(AceSfx.tick, volume: 0.20);
  }

  @override
  void didUpdateWidget(_TypewriterText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      _ctrl.dispose();
      _start();
    }
    if (old.progress != widget.progress) {
      old.progress.removeListener(_handleExternal);
      widget.progress.addListener(_handleExternal);
    }
  }

  @override
  void dispose() {
    widget.progress.removeListener(_handleExternal);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final n = (widget.text.length * _ctrl.value).round();
        return Text(
          widget.text.substring(0, n),
          style: GoogleFonts.crimsonPro(
            fontSize: 17,
            height: 1.35,
            fontStyle: widget.italic ? FontStyle.italic : FontStyle.normal,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        );
      },
    );
  }
}
