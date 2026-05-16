import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/romance.dart';
import '../../../../providers/phone_state_provider.dart';
import '../../../../providers/romance_threads_provider.dart';
import 'romance_profile_visual.dart';
import 'romance_thread_view.dart';

/// Onglet « Messages » de Tinder — liste des threads de romance (arcs
/// actifs en haut, terminés en bas en gris). Tap → ouvre la conversation.
class RomanceThreadsList extends ConsumerWidget {
  const RomanceThreadsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tick à chaque rebuild pour s'assurer que les threads sont à jour.
    final p = ref.watch(phoneStateProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(romanceThreadsProvider.notifier).tickAll(
            day: p.currentDay,
            hour: p.hour,
            minute: p.minute,
          );
    });
    final state = ref.watch(romanceThreadsProvider);
    final notifier = ref.read(romanceThreadsProvider.notifier);
    final all = [
      ...state.active,
      ...state.archived,
    ];

    if (all.isEmpty) {
      return _Empty();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: all.length,
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(left: 78),
        child: Container(height: 0.5, color: Colors.grey.shade200),
      ),
      itemBuilder: (context, i) {
        final inst = all[i];
        final profile = notifier.profileOf(inst);
        final last = inst.playedMessages.isNotEmpty
            ? inst.playedMessages.last
            : null;
        final hasPending =
            inst.pendingChoiceBeatIdx != null && !inst.ended;
        return _ThreadTile(
          profile: profile,
          last: last,
          ended: inst.ended,
          hasPending: hasPending,
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RomanceThreadView(instanceId: inst.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline,
              color: Colors.grey.shade300, size: 56),
          const SizedBox(height: 16),
          Text(
            'Aucun message pour l\'instant',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quand tu auras un match qui ne se ferme pas '
            'silencieusement, la conversation apparaîtra ici.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.profile,
    required this.last,
    required this.ended,
    required this.hasPending,
    required this.onTap,
  });
  final RomanceProfile profile;
  final PlayedMessage? last;
  final bool ended;
  final bool hasPending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final preview = _previewOf(last);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            // Avatar procédural bokeh
            Opacity(
              opacity: ended ? 0.4 : 1.0,
              child: RomanceAvatar(profile: profile),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight:
                                hasPending ? FontWeight.w800 : FontWeight.w600,
                            color: ended
                                ? Colors.grey.shade500
                                : const Color(0xFF1A1A1A),
                            decoration: ended
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      if (last != null)
                        Text(
                          'J${last!.day} · ${last!.time}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (hasPending)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFD297B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'À TOI',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          preview,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: ended
                                ? Colors.grey.shade400
                                : (hasPending
                                    ? const Color(0xFF1A1A1A)
                                    : Colors.grey.shade600),
                            fontWeight: hasPending
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _previewOf(PlayedMessage? m) {
    if (m == null) return 'Vous venez de matcher.';
    switch (m.type) {
      case RomanceBeatType.text:
        return (m.fromThem ? '' : 'Vous : ') + (m.text ?? '');
      case RomanceBeatType.voiceNote:
        return '🎙 Mémo vocal · ${m.voiceDurationS}s';
      case RomanceBeatType.photoShared:
        return '📷 Photo';
      case RomanceBeatType.mapLocation:
        return '📍 Lieu partagé';
      case RomanceBeatType.callRing:
        return m.callMissed ? '📞 Appel manqué' : '📞 Appel';
      case RomanceBeatType.typingThenNothing:
        return '· · · (effacé)';
      default:
        return '';
    }
  }
}
