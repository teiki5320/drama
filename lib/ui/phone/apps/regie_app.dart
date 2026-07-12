import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/episodes.dart';
import '../../../models/episode.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// RÉGIE — outil d'AUTEUR (pas du contenu joueur). Affiche TOUTE la
/// narration du jeu (les écrans de transition = la voix de Shen) dans
/// l'ordre J1 → J112, épisode par épisode, pour relire le fil d'un bloc
/// et voir immédiatement les trous (« rien n'arrive au bon moment » =
/// beats sans narration, signalés en rouge).
class RegieApp extends ConsumerWidget {
  const RegieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var total = 0, withNar = 0;
    for (final e in kEpisodes) {
      for (final b in e.beats) {
        total++;
        if (b.transition != null) withNar++;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFFD97757), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text(
                  'Régie — Narration',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${kEpisodes.length} épisodes · $total beats · '
                '$withNar avec narration · ${total - withNar} sans',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 48),
              children: [
                for (final e in kEpisodes) ..._episode(e),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _episode(Episode e) => [
        const SizedBox(height: 18),
        Text(
          'ÉPISODE ${e.number} · ${e.title}',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFD97757),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(e.subtitle,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white38)),
        const SizedBox(height: 10),
        for (final b in e.beats) _beat(b),
      ];

  Widget _beat(Beat b) {
    final t = b.transition;
    final hh = b.hour.toString().padLeft(2, '0');
    final mm = b.minute.toString().padLeft(2, '0');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: t == null ? const Color(0xFF6B3A3A) : Colors.white12,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A3F6E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'J${b.day} · $hh:$mm',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  b.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (b.requiresChoice != null) ...[
            const SizedBox(height: 6),
            Text(
              '↩ attend la réponse : ${b.requiresChoice}',
              style:
                  GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6EC1E4)),
            ),
          ],
          if (b.unlocksApps.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '🔓 débloque : ${b.unlocksApps.join(", ")}',
              style: GoogleFonts.inter(fontSize: 10, color: Colors.white38),
            ),
          ],
          const SizedBox(height: 8),
          if (t != null) ...[
            Text(
              t.timestamp,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.white38,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              t.body,
              style: GoogleFonts.crimsonPro(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            if (t.coda != null) ...[
              const SizedBox(height: 6),
              Text(
                t.coda!,
                style: GoogleFonts.crimsonPro(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.white54,
                ),
              ),
            ],
          ] else
            Text(
              '— pas de narration sur ce beat —',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFCB7A7A),
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
