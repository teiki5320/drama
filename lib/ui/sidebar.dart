import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';
import '../providers/game_state_provider.dart';
import '../providers/ui_provider.dart';
import 'settings_sheet.dart';
import 'stat_popups.dart';

/// Left rail: stats chips at top, nav buttons below, gear at the bottom.
/// Width is fixed at 84 dp — works on iPhone (just) and looks clean on iPad.
class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  static const double width = 84;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameStateProvider);
    final selected = ref.watch(selectedTabProvider);
    final unread = s.unlockedConversations
        .where((c) => !s.seenMessageThreads.contains(c))
        .length;

    return Container(
      width: width,
      color: const Color(0xFFF3EEDF),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Column(
        children: [
          _StatChip(
            label: 'J${s.currentDay}',
            accent: AppColors.accentOrange,
            onTap: () {
              HapticFeedback.selectionClick();
              showDayStatPopup(context, s.currentDay);
            },
          ),
          const SizedBox(height: 8),
          _StatChip(
            label: _formatMoney(s.argent),
            onTap: () {
              HapticFeedback.selectionClick();
              showArgentStatPopup(context, s.argent);
            },
          ),
          const SizedBox(height: 8),
          _StatChip(
            label: '${s.mood}/100',
            emoji: '😊',
            onTap: () {
              HapticFeedback.selectionClick();
              showMoodStatPopup(context, s.mood);
            },
          ),
          const SizedBox(height: 8),
          _StatChip(
            label: '${s.reputation}',
            emoji: '⭐',
            onTap: () {
              HapticFeedback.selectionClick();
              showReputationStatPopup(context, s.reputation, s.followers);
            },
          ),
          const Spacer(),
          _NavItem(
            icon: Icons.auto_stories,
            label: 'ACE',
            selected: selected == 0,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(selectedTabProvider.notifier).state = 0;
            },
          ),
          _NavItem(
            icon: Icons.menu_book,
            label: 'CARNET',
            selected: selected == 1,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(selectedTabProvider.notifier).state = 1;
            },
          ),
          _NavItem(
            icon: Icons.account_balance,
            label: 'BANQUE',
            selected: selected == 2,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(selectedTabProvider.notifier).state = 2;
            },
          ),
          _NavItem(
            icon: Icons.photo_library,
            label: 'INSTA',
            selected: selected == 3,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(selectedTabProvider.notifier).state = 3;
            },
          ),
          _NavItem(
            icon: Icons.chat_bubble,
            label: 'INVIT.',
            selected: selected == 4,
            badgeCount: unread,
            onTap: () async {
              HapticFeedback.selectionClick();
              ref.read(selectedTabProvider.notifier).state = 4;
              await ref
                  .read(gameStateProvider.notifier)
                  .markMessagesSeen();
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textSecondary),
            tooltip: 'Réglages',
            onPressed: () {
              HapticFeedback.selectionClick();
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: AppColors.paperCream,
                isScrollControlled: true,
                showDragHandle: false,
                builder: (_) => const SettingsSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  static String _formatMoney(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M€';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k€';
    return '$v€';
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    this.emoji,
    this.accent,
    this.onTap,
  });

  final String label;
  final String? emoji;
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isAccent = accent != null;
    final chip = Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isAccent
            ? accent!.withValues(alpha: 0.16)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAccent
              ? accent!.withValues(alpha: 0.4)
              : const Color(0x141A1A1A),
        ),
      ),
      child: Column(
        children: [
          if (emoji != null)
            Text(emoji!, style: const TextStyle(fontSize: 14))
          else if (isAccent)
            Icon(Icons.menu_book, size: 14, color: accent),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isAccent ? accent : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    if (onTap == null) return chip;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: chip,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentOrange : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accentOrange.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 22),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 16),
                      height: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.negative,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
