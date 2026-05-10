import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../models/character.dart';
import '../../models/insta_post.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';
import 'character_profile.dart';
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
        data: (seed) {
          final feed = <InstaPost>[
            ...seed,
            ...state.generatedInstaPosts,
          ]
              .where((p) => p.day <= state.currentDay)
              .toList(growable: false)
            ..sort((a, b) => b.day.compareTo(a.day));

          final shen = characterById('shen')!;
          final stories = kCharacters
              .where((c) => c.id != 'shen')
              .where((c) => c.appearsAtDay == null
                  ? true
                  : state.currentDay >= c.appearsAtDay!)
              .toList(growable: false);

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
                      child: _ShenProfileChip(
                        followers: state.followers,
                        tagline: engine.instaTagline(state.followers),
                        shen: shen,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                      child: SizedBox(
                        height: 92,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: stories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, i) =>
                              _Story(character: stories[i]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (feed.isEmpty)
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
                  itemCount: feed.length,
                  itemBuilder: (context, i) => PostCard(post: feed[i]),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _ShenProfileChip extends StatelessWidget {
  const _ShenProfileChip({
    required this.followers,
    required this.tagline,
    required this.shen,
  });

  final int followers;
  final String tagline;
  final Character shen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CharacterProfileScreen(character: shen),
      )),
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
                color: AppColors.accentOrange.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentOrange,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              child: shen.photoAsset == null
                  ? Text(
                      'S',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentOrange,
                      ),
                    )
                  : Image.asset(
                      shen.photoAsset!,
                      fit: BoxFit.cover,
                      cacheWidth: 192,
                      errorBuilder: (_, __, ___) => Text(
                        'S',
                        style: GoogleFonts.crimsonPro(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentOrange,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    '$followers abonnés · $tagline',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CharacterProfileScreen(character: character),
      )),
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD97757),
                    Color(0xFFE8AC83),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(2.5),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.paperCream,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: character.tint,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  child: character.photoAsset == null
                      ? Text(character.emoji,
                          style: const TextStyle(fontSize: 24))
                      : Image.asset(
                          character.photoAsset!,
                          fit: BoxFit.cover,
                          cacheWidth: 192,
                          errorBuilder: (_, __, ___) => Text(
                            character.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              character.handle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
