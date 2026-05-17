import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/calendar_data.dart';
import '../../../data/messages_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../providers/sent_replies_provider.dart';

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
                  color: Colors.white.withValues(alpha: 0.85),
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
                  color: Colors.white.withValues(alpha: 0.75),
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
              color: Colors.white.withValues(alpha: 0.65),
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
              color: Colors.white.withValues(alpha: 0.75),
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
                  color: Colors.white.withValues(alpha: 0.85),
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

/// Widget « Avancer / Terminer la journée » — bouton manuel pour avancer
/// vers le beat suivant. Deux états visuels :
///   - **Avancer** (orange pulse) tant que le prochain beat reste dans
///     la journée courante.
///   - **Terminer J{X}** (indigo nuit) quand le prochain beat tombe
///     sur le lendemain — c'est là qu'on déclenche la transition de
///     jour plein écran.
/// Le bouton est désactivé (grisé) si le beat courant attend une
/// réponse SMS-clé non encore donnée : il faut d'abord répondre.
class TimeSkipWidget extends ConsumerStatefulWidget {
  const TimeSkipWidget({super.key});
  @override
  ConsumerState<TimeSkipWidget> createState() => _TimeSkipWidgetState();
}

class _TimeSkipWidgetState extends ConsumerState<TimeSkipWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On regarde l'état du téléphone et les réponses envoyées pour
    // décider du mode (avancer / fin de journée / verrouillé).
    final p = ref.watch(phoneStateProvider);
    final notifier = ref.read(phoneStateProvider.notifier);
    final replies = ref.watch(sentRepliesProvider);

    final atEnd = notifier.isAtEndOfStory;
    final endsDay = notifier.nextBeatChangesDay;

    // Bloqué si le beat courant attend une réponse SMS pas encore
    // donnée : on veut d'abord conclure la conversation en cours.
    final requiresId = notifier.currentBeat?.requiresChoice;
    final waitingReply = requiresId != null && !replies.containsKey(requiresId);

    final disabled = atEnd || waitingReply;

    final color = disabled
        ? const Color(0xFF6B6B6B)
        : endsDay
            ? const Color(0xFF4A3F6E)
            : const Color(0xFFD97757);
    final label = atEnd
        ? 'Fin de l\'histoire'
        : waitingReply
            ? 'Réponds d\'abord'
            : endsDay
                ? 'Terminer J${p.currentDay}'
                : 'Avancer';
    final sub = atEnd
        ? '—'
        : waitingReply
            ? 'Une conversation t\'attend'
            : endsDay
                ? 'La nuit va passer'
                : 'Prochain moment';
    final icon = endsDay ? Icons.bedtime : Icons.fast_forward;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        // Pas de pulse quand grisé.
        final pulseT = disabled ? 0.0 : _pulse.value;
        final glow = 0.20 + 0.18 * pulseT;
        final borderGlow = 0.30 + 0.40 * pulseT;
        return GestureDetector(
          onTap: () {
            if (disabled) {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    waitingReply
                        ? 'Réponds au message en cours d\'abord.'
                        : 'L\'histoire est terminée.',
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(milliseconds: 1600),
                  backgroundColor: const Color(0xFF1A1A1A),
                ),
              );
              return;
            }
            HapticFeedback.mediumImpact();
            notifier.advanceToNextBeat();
          },
          child: Opacity(
            opacity: disabled ? 0.55 : 1.0,
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: glow),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: color.withValues(alpha: borderGlow), width: 1.5),
                boxShadow: disabled
                    ? null
                    : [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25 * pulseT),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sub,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bandeau « J-X · Traitement Maman » qui s'affiche en haut du home.
/// Couleur qui s'intensifie à mesure que J45 approche.
class DeadlineBanner extends ConsumerWidget {
  const DeadlineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    const targetDay = 45;
    final delta = targetDay - day;
    if (delta < -5) return const SizedBox.shrink();
    final isPast = delta < 0;
    final isUrgent = delta >= 0 && delta <= 14;
    final color = isPast
        ? const Color(0xFF1F2937)
        : isUrgent
            ? const Color(0xFFC62828)
            : const Color(0xFFD97757);
    final label = isPast
        ? 'Deadline dépassée'
        : delta == 0
            ? 'AUJOURD\'HUI · Traitement Maman'
            : delta == 1
                ? 'DEMAIN · Traitement Maman'
                : 'J-$delta · Traitement Maman';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.hourglass_bottom, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Text(
              '18 000 €',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.85),
                fontStyle: FontStyle.italic,
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
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.20), width: 1),
      ),
      child: child,
    );
  }
}
