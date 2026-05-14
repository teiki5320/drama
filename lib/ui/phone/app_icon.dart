import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';
import '../../providers/phone_state_provider.dart';

/// Icône d'app iOS-style : carré arrondi coloré + nom dessous + badge
/// rouge optionnel. Tap → ouvre l'app via le PhoneStateNotifier.
class AppIcon extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(phoneStateProvider.select((s) => s.badges));
    final badgeCount = badges[meta.id] ?? 0;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(phoneStateProvider.notifier).openApp(meta.id);
        ref.read(phoneStateProvider.notifier).clearBadge(meta.id);
      },
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: meta.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(meta.icon, color: meta.fgColor, size: size * 0.55),
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
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
            ],
          ),
          if (showLabel) ...[
            const SizedBox(height: 6),
            Text(
              meta.label,
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
