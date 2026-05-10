import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';
import 'post_card.dart';

class InstaScreen extends ConsumerWidget {
  const InstaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final async = ref.watch(instaSeedProvider);

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur : $e')),
        data: (posts) {
          final visible = posts
              .where((p) => p.day <= state.currentDay)
              .toList(growable: false)
            ..sort((a, b) => b.day.compareTo(a.day));

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BigTitle('Instagram'),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 4, 20, 14),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFAE0CC),
                              Color(0xFFFCEBC9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.accentOrange
                                    .withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accentOrange,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'S',
                                style: GoogleFonts.crimsonPro(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentOrange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@shen_y',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${state.followers} abonnés · ${engine.instaTagline(state.followers)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (visible.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Text('Pas encore de publications.'),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, i) => PostCard(post: visible[i]),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}
