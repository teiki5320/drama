import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/character.dart';
import '../../models/insta_post.dart';
import 'character_profile.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final InstaPost post;

  @override
  Widget build(BuildContext context) {
    final character = characterByHandle(post.author);
    final tint = character?.tint ?? const Color(0xFFEFE7D6);
    final tintEnd = _darken(tint, 0.10);

    void openProfile() {
      if (character == null) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CharacterProfileScreen(character: character),
      ));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: openProfile,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Row(
                children: [
                  _AvatarChip(character: character, tint: tint),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character?.displayName ?? post.author,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      Text(
                        post.author,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'J${post.day}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.6,
            child: _PostImage(
              imageAsset: post.imageAsset,
              fallbackEmoji: post.emoji,
              tintStart: tint,
              tintEnd: tintEnd,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: _ReactionRow(post: post),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: post.author.replaceAll('@', ''),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const TextSpan(text: '  '),
                  TextSpan(text: post.caption),
                ],
              ),
            ),
          ),
          if (post.topComments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in post.topComments.take(2))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: c.author.replaceAll('@', ''),
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const TextSpan(text: '  '),
                            TextSpan(text: c.content),
                          ],
                        ),
                      ),
                    ),
                  if (post.commentsCount > post.topComments.length)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Voir les ${post.commentsCount - post.topComments.length} autres commentaires',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AvatarChip extends StatelessWidget {
  const _AvatarChip({required this.character, required this.tint});
  final Character? character;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final fallbackEmoji = character?.emoji ?? '?';
    final photo = character?.photoAsset;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: tint,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: photo == null
          ? Text(fallbackEmoji, style: const TextStyle(fontSize: 18))
          : Image.asset(
              photo,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Text(fallbackEmoji, style: const TextStyle(fontSize: 18)),
            ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({
    required this.imageAsset,
    required this.fallbackEmoji,
    required this.tintStart,
    required this.tintEnd,
  });

  final String? imageAsset;
  final String fallbackEmoji;
  final Color tintStart;
  final Color tintEnd;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tintStart, tintEnd],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        fallbackEmoji,
        style: const TextStyle(fontSize: 64),
      ),
    );
    if (imageAsset == null) return fallback;
    return Image.asset(
      imageAsset!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _ReactionRow extends StatelessWidget {
  const _ReactionRow({required this.post});
  final InstaPost post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.favorite_border,
            size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 6),
        Text(
          _formatCount(post.likes),
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 14),
        const Icon(Icons.mode_comment_outlined,
            size: 17, color: AppColors.textPrimary),
        const SizedBox(width: 6),
        Text(
          '${post.commentsCount}',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        const Icon(Icons.bookmark_border,
            size: 18, color: AppColors.textSecondary),
      ],
    );
  }

  static String _formatCount(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)} M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)} k';
    return '$v';
  }
}

Color _darken(Color c, double amount) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}
