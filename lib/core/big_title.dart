import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Big serif title at the top of every screen, replacing AppBar.
class BigTitle extends StatelessWidget {
  const BigTitle(this.text, {super.key, this.subtitle});

  final String text;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.crimsonPro(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.05,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
