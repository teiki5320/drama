import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';
import '../../providers/phone_state_provider.dart';

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
  });

  final AppMeta meta;
  final double size;
  final bool showLabel;

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
  int _lastBadge = 0;

  @override
  void initState() {
    super.initState();
    _lastBadge = ref.read(phoneStateProvider).badges[widget.meta.id] ?? 0;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badgeCount = ref.watch(
      phoneStateProvider.select((s) => s.badges[widget.meta.id] ?? 0),
    );
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

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(phoneStateProvider.notifier).openApp(widget.meta.id);
        ref.read(phoneStateProvider.notifier).clearBadge(widget.meta.id);
      },
      borderRadius: BorderRadius.circular(14),
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
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.meta.color,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(widget.meta.icon,
                      color: widget.meta.fgColor, size: widget.size * 0.55),
                ),
              ),
              if (badgeCount > 0)
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
    );
  }
}
