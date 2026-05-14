import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/phone_apps.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// Coquille générique « Bientôt disponible » utilisée en PR 1 pour
/// toutes les apps. Chaque app aura son écran dédié dans les PR
/// suivantes (Messages en PR 2, Photos+Notes en PR 3, etc.).
class ShellApp extends ConsumerWidget {
  const ShellApp({super.key, required this.meta});
  final AppMeta meta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7EF),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          // Header avec bouton retour
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF1A1A1A), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text(
                  meta.label,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: meta.color,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child:
                        Icon(meta.icon, color: meta.fgColor, size: 44),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bientôt disponible',
                    style: GoogleFonts.crimsonPro(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cette app sera remplie dans une prochaine étape.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
