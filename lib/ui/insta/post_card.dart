import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/insta_post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final InstaPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      AppColors.accentOrange.withValues(alpha: 0.18),
                  child: Text(
                    post.author.isNotEmpty ? post.author[1] : '?',
                    style: const TextStyle(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  post.author,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13.5),
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
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              color: const Color(0xFFEFE7D6),
              alignment: Alignment.center,
              child: Text(post.emoji,
                  style: const TextStyle(fontSize: 76)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Text(
              post.caption,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
