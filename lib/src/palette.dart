import 'package:flutter/material.dart';

/// Couleurs du jeu, calquées sur une messagerie iOS, en clair et en sombre.
class Palette {
  const Palette({
    required this.threadBg,
    required this.inBubble,
    required this.inText,
    required this.outBubble,
    required this.outText,
    required this.meta,
    required this.headBg,
    required this.headBorder,
    required this.headText,
    required this.chev,
    required this.choiceText,
    required this.choiceBorder,
    required this.choiceBg,
    required this.rowBorder,
    required this.preview,
    required this.dot,
    required this.pill,
    required this.brand,
    required this.bannerBg,
  });

  final Color threadBg;
  final Color inBubble;
  final Color inText;
  final Color outBubble;
  final Color outText;
  final Color meta;
  final Color headBg;
  final Color headBorder;
  final Color headText;
  final Color chev;
  final Color choiceText;
  final Color choiceBorder;
  final Color choiceBg;
  final Color rowBorder;
  final Color preview;
  final Color dot;
  final Color pill;
  final Color brand;
  final Color bannerBg;

  static const light = Palette(
    threadBg: Color(0xFFFFFFFF),
    inBubble: Color(0xFFE9E9EB),
    inText: Color(0xFF101014),
    outBubble: Color(0xFF0A7CFF),
    outText: Color(0xFFFFFFFF),
    meta: Color(0xFF8A8A92),
    headBg: Color(0xFFF9F9FA),
    headBorder: Color(0xFFE3E3E8),
    headText: Color(0xFF101014),
    chev: Color(0xFF0A7CFF),
    choiceText: Color(0xFF0A7CFF),
    choiceBorder: Color(0x8C0A7CFF),
    choiceBg: Color(0x0F0A7CFF),
    rowBorder: Color(0xFFE7E7EC),
    preview: Color(0xFF8A8A92),
    dot: Color(0xFF0A7CFF),
    pill: Color(0xFFE33B4E),
    brand: Color(0xFFD91E4A),
    bannerBg: Color(0xFFF6F6F8),
  );

  static const dark = Palette(
    threadBg: Color(0xFF000000),
    inBubble: Color(0xFF26262B),
    inText: Color(0xFFF2F2F5),
    outBubble: Color(0xFF0A84FF),
    outText: Color(0xFFFFFFFF),
    meta: Color(0xFF7C7C85),
    headBg: Color(0xFF121214),
    headBorder: Color(0xFF232329),
    headText: Color(0xFFF2F2F5),
    chev: Color(0xFF409CFF),
    choiceText: Color(0xFF409CFF),
    choiceBorder: Color(0x8C409CFF),
    choiceBg: Color(0x1F409CFF),
    rowBorder: Color(0xFF1E1E24),
    preview: Color(0xFF7C7C85),
    dot: Color(0xFF0A84FF),
    pill: Color(0xFFE33B4E),
    brand: Color(0xFFD91E4A),
    bannerBg: Color(0xFF1C1C20),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
