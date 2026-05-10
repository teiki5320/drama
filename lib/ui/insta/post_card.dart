import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/insta_post.dart';

const _authorTints = <String, List<Color>>{
  '@camille_rx': [Color(0xFFFCE6D8), Color(0xFFFAD9C2)],
  '@heng_lihua': [Color(0xFFE7E1D2), Color(0xFFD9D0BD)],
  '@t_heng': [Color(0xFFD7DEE5), Color(0xFFBFC9D4)],
  '@vincent.h': [Color(0xFFEBD8E0), Color(0xFFDFC4CE)],
  '@mei_fujian': [Color(0xFFE0E7D7), Color(0xFFCCD6BC)],
};

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final InstaPost post;

  @override
  Widget build(BuildContext context) {
    final tint = _authorTints[post.author] ??
        const [Color(0xFFEFE7D6), Color(0xFFE3D9C2)];

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
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      AppColors.accentOrange.withValues(alpha: 0.18),
                  child: Text(
                    post.author.isNotEmpty ? post.author[1].toUpperCase() : '?',
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
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
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
            aspectRatio: 1.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: tint,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                post.emoji,
                style: const TextStyle(fontSize: 64),
              ),
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
