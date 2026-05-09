import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../providers/game_state_provider.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.accentOrange, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              'S',
              style: GoogleFonts.crimsonPro(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.accentOrange,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@shen_y',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${s.followers} abonnés · ${engine.instaTagline(s.followers)}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
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
