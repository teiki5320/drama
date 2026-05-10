import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/day_entry.dart';
import '../../models/sms_message.dart';
import 'sms_bubble.dart';

class DayNarrativeView extends StatelessWidget {
  const DayNarrativeView({super.key, required this.day});

  final DayEntry day;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    for (final b in day.narrative) {
      switch (b.type) {
        case NarrativeBlockType.prose:
          blocks.add(_Prose(text: b.content ?? ''));
          break;
        case NarrativeBlockType.sectionTitle:
          blocks.add(_SectionTitle(text: b.content ?? ''));
          break;
        case NarrativeBlockType.sms:
          blocks.add(_SmsCluster(messages: b.messages ?? const []));
          break;
        case NarrativeBlockType.image:
          blocks.add(_NarrativeImage(
            imageAsset: b.imageAsset,
            caption: b.content,
          ));
          break;
      }
      blocks.add(const SizedBox(height: 14));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: blocks,
    );
  }
}

class _Prose extends StatelessWidget {
  const _Prose({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 15.5,
        height: 1.6,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: GoogleFonts.crimsonPro(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SmsCluster extends StatelessWidget {
  const _SmsCluster({required this.messages});
  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEDF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x141A1A1A)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final m in messages) SmsBubble(message: m),
        ],
      ),
    );
  }
}

class _NarrativeImage extends StatelessWidget {
  const _NarrativeImage({required this.imageAsset, required this.caption});

  final String? imageAsset;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3EEDF),
            Color(0xFFE3D9C2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 42,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    );

    final image = imageAsset == null
        ? fallback
        : ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        image,
        if (caption != null && caption!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            caption!,
            style: GoogleFonts.inter(
              fontStyle: FontStyle.italic,
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
