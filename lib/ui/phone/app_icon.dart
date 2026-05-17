import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';
import '../../providers/messages_arcs_provider.dart';
import '../../providers/phone_state_provider.dart';
import '../../providers/romance_threads_provider.dart';

/// Icône d'app iOS-style : carré arrondi coloré + nom dessous + badge
/// rouge optionnel. Tap → ouvre l'app via le PhoneStateNotifier.
///
/// Anim : quand le badge passe de 0 à >0 (nouvelle notif), l'icône
/// pulse 1× (scale 1.0 → 1.12 → 1.0 sur 600ms) et le badge fait un
/// scale-in spring depuis 0.
class AppIcon extends ConsumerStatefulWidget {
  const AppIcon({
    super.key,
    required this.meta,
    this.size = 56,
    this.showLabel = true,
    this.locked = false,
  });

  final AppMeta meta;
  final double size;
  final bool showLabel;
  /// Quand `true`, l'app apparaît grisée (saturation 0, opacité réduite)
  /// et le tap déclenche un snack « Pas encore disponible » au lieu
  /// d'ouvrir l'app.
  final bool locked;

  @override
  ConsumerState<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends ConsumerState<AppIcon>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final AnimationController _badgeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
    value: 1.0,
  );
  /// Anim de déverrouillage : flash blanc + pulse quand l'app passe
  /// de locked à unlocked (story moment).
  late final AnimationController _unlockCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  int _lastBadge = 0;
  bool _lastLocked = false;

  @override
  void initState() {
    super.initState();
    _lastBadge = ref.read(phoneStateProvider).badges[widget.meta.id] ?? 0;
    _lastLocked = widget.locked;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _badgeCtrl.dispose();
    _unlockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var badgeCount = ref.watch(
      phoneStateProvider.select((s) => s.badges[widget.meta.id] ?? 0),
    );
    // Cas spécial Tinder : on ajoute les arcs romance en attente.
    if (widget.meta.id == 'tinder') {
      badgeCount += ref.watch(romanceUnreadCountProvider);
    }
    // Cas spécial Messages : on ajoute les arcs Messages en attente.
    if (widget.meta.id == 'messages') {
      badgeCount += ref.watch(messagesArcsUnreadCountProvider);
    }
    // Détection : badge ↑ → pulse + scale-in
    if (badgeCount > _lastBadge) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pulseCtrl.forward(from: 0);
          _badgeCtrl.forward(from: 0);
        }
      });
    }
    _lastBadge = badgeCount;

    // Détection : locked → unlocked → flash + pulse de déverrouillage.
    if (_lastLocked && !widget.locked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          HapticFeedback.lightImpact();
          _unlockCtrl.forward(from: 0);
          _pulseCtrl.forward(from: 0);
        }
      });
    }
    _lastLocked = widget.locked;

    final iconTile = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.locked
            ? const Color(0xFF6B6B6B)
            : widget.meta.color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: widget.locked
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Icon(widget.meta.icon,
          color: widget.locked
              ? Colors.white.withValues(alpha: 0.55)
              : widget.meta.fgColor,
          size: widget.size * 0.55),
    );

    return InkWell(
      onTap: () {
        if (widget.locked) {
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Installe-la depuis l\'App Store.',
                style: GoogleFonts.inter(fontSize: 13),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 1600),
              backgroundColor: const Color(0xFF1A1A1A),
              action: SnackBarAction(
                label: 'Ouvrir',
                textColor: const Color(0xFF1DB1FF),
                onPressed: () {
                  ref.read(phoneStateProvider.notifier).openApp('appstore');
                },
              ),
            ),
          );
          return;
        }
        HapticFeedback.selectionClick();
        ref.read(phoneStateProvider.notifier).openApp(widget.meta.id);
        ref.read(phoneStateProvider.notifier).clearBadge(widget.meta.id);
      },
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: widget.locked ? 0.55 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, child) {
                    // Pulse : 0 → 1 → 0 sur la durée. Pic à 0.5.
                    final t = _pulseCtrl.value;
                    final pulse = t == 0
                        ? 1.0
                        : 1.0 + 0.12 * (1 - (2 * t - 1).abs());
                    return Transform.scale(scale: pulse, child: child);
                  },
                  child: iconTile,
                ),
                // Flash blanc « déverrouillage » par-dessus l'icône.
                // Toujours présent dans l'arbre — l'AnimatedBuilder tick
                // pendant l'animation et masque tout en dehors.
                AnimatedBuilder(
                  animation: _unlockCtrl,
                  builder: (_, __) {
                    final t = _unlockCtrl.value;
                    if (t == 0) return const SizedBox.shrink();
                    // Fade-in rapide jusqu'à 0.3, puis fade-out long.
                    final flashOpacity = t < 0.3
                        ? (t / 0.3) * 0.85
                        : (1 - (t - 0.3) / 0.7) * 0.85;
                    return IgnorePointer(
                      child: Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: flashOpacity.clamp(0.0, 1.0)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  },
                ),
                if (!widget.locked && badgeCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _badgeCtrl,
                      curve: Curves.easeOutBack,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 20),
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$badgeCount',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.locked)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A).withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 1),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.lock,
                          color: Colors.white, size: 11),
                    ),
                  ),
            ],
          ),
          if (widget.showLabel) ...[
            const SizedBox(height: 6),
            Text(
              widget.meta.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                shadows: const [
                  Shadow(color: Colors.black54, blurRadius: 4),
                ],
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
