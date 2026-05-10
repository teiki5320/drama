import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/character.dart';
import '../../models/insta_post.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';

class CharacterProfileScreen extends ConsumerWidget {
  const CharacterProfileScreen({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final seedAsync = ref.watch(instaSeedProvider);

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      appBar: AppBar(
        backgroundColor: AppColors.paperCream,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          character.handle,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: seedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur : $e')),
        data: (seed) {
          final all = <InstaPost>[
            ...seed,
            ...state.generatedInstaPosts,
          ]
              .where((p) =>
                  p.author == character.handle && p.day <= state.currentDay)
              .toList()
            ..sort((a, b) => b.day.compareTo(a.day));

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _ProfileHero(character: character, postsCount: all.length),
              const SizedBox(height: 18),
              if (all.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Pas encore de publications.',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                _PostsGrid(posts: all),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero(
      {required this.character, required this.postsCount});

  final Character character;
  final int postsCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              color: character.tint,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentOrange, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: character.photoAsset == null
                ? Text(character.emoji,
                    style: const TextStyle(fontSize: 56))
                : Image.asset(
                    character.photoAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(character.emoji,
                          style: const TextStyle(fontSize: 56)),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          character.displayName,
          style: GoogleFonts.crimsonPro(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          character.handle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: character.tint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            character.role,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            character.bio,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '$postsCount publication${postsCount == 1 ? '' : 's'}',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PostsGrid extends StatelessWidget {
  const _PostsGrid({required this.posts});
  final List<InstaPost> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final p = posts[i];
        return _PostThumb(post: p);
      },
    );
  }
}

class _PostThumb extends StatelessWidget {
  const _PostThumb({required this.post});
  final InstaPost post;

  @override
  Widget build(BuildContext context) {
    final character = characterByHandle(post.author);
    final tint = character?.tint ?? const Color(0xFFEFE7D6);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tint, _darken(tint, 0.10)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: post.imageAsset == null
          ? Text(post.emoji, style: const TextStyle(fontSize: 32))
          : Image.asset(
              post.imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Text(post.emoji, style: const TextStyle(fontSize: 32)),
            ),
    );
  }
}

Color _darken(Color c, double amount) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}
