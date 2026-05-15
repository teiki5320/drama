import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/calendar_data.dart';
import '../../../data/messages_data.dart';
import '../../../providers/phone_state_provider.dart';

/// Widget Météo grand format pour le home screen.
class MeteoWidget extends StatelessWidget {
  const MeteoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Belleville',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '13°',
                style: GoogleFonts.inter(
                  fontSize: 38,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pluie',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text(
                'Min : 11°  ·  Max : 15°',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.umbrella, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}

/// Widget cadre photo « Maman » — lit le dernier SMS de Maman dans le
/// fil et l'affiche. Voix Maman, mise en italique serif.
class PhotoMamanWidget extends ConsumerWidget {
  const PhotoMamanWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    // Dernier message reçu de Maman (sender != 'moi') visible jusqu'ici.
    final mamanMsgs = (kThreads['maman'] ?? [])
        .where((m) => m.day <= day && m.sender == 'maman')
        .toList();
    final last = mamanMsgs.isNotEmpty ? mamanMsgs.last : null;
    final body = last?.text ?? 'Couvre-toi.';
    final stamp = last == null
        ? '—'
        : (last.day == day ? 'Aujourd\'hui, ${last.time}' : 'J${last.day}, ${last.time}');

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFCE6D8), Color(0xFFFAE0CC)],
                  ),
                ),
                child: const Icon(Icons.favorite,
                    color: Color(0xFFD97757), size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Maman',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.crimsonPro(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stamp,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget Calendrier — montre le prochain RDV à venir (ou « aujourd'hui »).
/// Lit `kEvents` filtré sur `currentDay`.
class CalendarWidget extends ConsumerWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final upcoming = kEvents.where((e) => e.day >= day).toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    final next = upcoming.isNotEmpty ? upcoming.first : null;

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            next == null
                ? 'CALENDRIER'
                : (next.urgent ? 'URGENT' : 'PROCHAIN'),
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF6B6B),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            next?.title ?? 'Aucun rendez-vous',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            next?.location ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                _whenLabel(next, day),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _whenLabel(CalendarEvent? e, int day) {
    if (e == null) return '—';
    final delta = e.day - day;
    final time = e.startTime;
    if (delta == 0) return 'Aujourd\'hui $time';
    if (delta == 1) return 'Demain $time';
    return 'Dans $delta j · $time';
  }
}

/// Widget « Prochain moment » — bouton manuel pour avancer vers le beat
/// suivant. La progression est aussi automatique quand Shen répond au
/// SMS-clé du beat courant ; ce widget sert quand il n'y a pas de SMS
/// gate, ou pour reprendre la main si le joueur veut presser.
class TimeSkipWidget extends ConsumerWidget {
  const TimeSkipWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(phoneStateProvider.notifier).advanceToNextBeat();
      },
      child: _GlassCard(
        child: Row(
          children: [
            const Icon(Icons.fast_forward, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prochain moment',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Saute au beat suivant',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte glassmorphism semi-transparente commune à tous les widgets.
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: Colors.white.withOpacity(0.20), width: 1),
      ),
      child: child,
    );
  }
}
