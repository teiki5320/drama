import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/contact_states.dart';
import '../../../data/messages_data.dart';
import '../../../models/messages_arc.dart';
import '../../../providers/messages_arcs_provider.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';
import 'messages/arc_thread_view.dart';
import 'messages/thread_view.dart';

/// App Messages — liste des conversations (style iMessage). Filtre par
/// jour courant : on n'affiche que les messages déjà reçus jusqu'au
/// `currentDay` (pas de spoiler).
class MessagesApp extends ConsumerWidget {
  const MessagesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));

    // Threads canoniques (Maman, Camille, Tristan, Madame Heng, spam…)
    final visible = kContacts.where((c) {
      final msgs = (kThreads[c.id] ?? []).where((m) => m.day <= day).toList();
      return msgs.isNotEmpty;
    }).toList()
      ..sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return 0;
      });

    // Arcs Messages dynamiques (voisine, médecin, ami d'enfance…)
    final arcsState = ref.watch(messagesArcsProvider);
    final arcInstances = arcsState.instances
        .where((i) => i.playedMessages.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          // Header avec bouton retour + titre Messages
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF007AFF), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  'Messages',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Icon(Icons.edit_note,
                    color: Colors.grey.shade400, size: 24),
              ],
            ),
          ),
          // Barre de recherche style iOS
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade500, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Rechercher',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                HapticFeedback.lightImpact();
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: visible.length + arcInstances.length,
                separatorBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(left: 78),
                  child: Container(height: 0.5, color: Colors.grey.shade300),
                ),
                itemBuilder: (context, i) {
                  if (i < visible.length) {
                    final c = visible[i];
                    return _ThreadTile(contact: c, currentDay: day);
                  }
                  final inst = arcInstances[i - visible.length];
                  return _ArcThreadTile(instance: inst);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadTile extends ConsumerWidget {
  const _ThreadTile({required this.contact, required this.currentDay});
  final MsgContact contact;
  final int currentDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final msgs =
        (kThreads[contact.id] ?? []).where((m) => m.day <= currentDay).toList();
    if (msgs.isEmpty) return const SizedBox.shrink();
    final last = msgs.last;
    final unread = last.sender != 'moi' && last.status != MsgStatus.read;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ThreadView(contact: contact),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar : image si dispo, sinon emoji teinté
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: contact.avatarPath == null
                    ? Color(int.parse('0xFF${contact.avatarTint.substring(1)}'))
                    : null,
                shape: BoxShape.circle,
                image: contact.avatarPath != null
                    ? DecorationImage(
                        image: AssetImage(contact.avatarPath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: contact.avatarPath != null
                  ? null
                  : Text(contact.emoji,
                      style: const TextStyle(fontSize: 24)),
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
                          contact.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        last.time,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right,
                          color: Colors.grey.shade400, size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (unread)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Color(0xFF007AFF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          last.sender == 'moi' ? 'Vous : ${last.text}' : last.text,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: unread
                                ? const Color(0xFF1A1A1A)
                                : Colors.grey.shade600,
                            fontWeight: unread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Statut « vivant » du contact (en ligne, hors ligne, tape…)
                  Builder(builder: (_) {
                    final s = statusForContact(contact.id, currentDay);
                    if (s == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          if (s.emoji != null) ...[
                            Text(s.emoji!,
                                style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            s.label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcThreadTile extends ConsumerWidget {
  const _ArcThreadTile({required this.instance});
  final MessagesArcInstance instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(messagesArcsProvider.notifier);
    final template = notifier.templateOf(instance);
    final contact = template.contact;
    final last = instance.playedMessages.isNotEmpty
        ? instance.playedMessages.last
        : null;
    final hasPending =
        instance.pendingChoiceBeatIdx != null && !instance.ended;
    final preview = _previewOf(last);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArcThreadView(instanceId: instance.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(int.parse(
                    '0xFF${contact.avatarTint.substring(1)}')),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(contact.emoji,
                  style: const TextStyle(fontSize: 24)),
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
                          contact.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight:
                                hasPending ? FontWeight.w800 : FontWeight.w600,
                            color: instance.ended
                                ? Colors.grey.shade500
                                : const Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (last != null)
                        Text(
                          last.time,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right,
                          color: Colors.grey.shade400, size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (hasPending)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Color(0xFF007AFF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          preview,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: hasPending
                                ? const Color(0xFF1A1A1A)
                                : Colors.grey.shade600,
                            fontWeight: hasPending
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 2,
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

  String _previewOf(MessagesArcPlayedMsg? m) {
    if (m == null) return 'Nouvelle conversation';
    final type = m.type.toString();
    if (type.contains('text')) {
      return (m.fromThem ? '' : 'Vous : ') + (m.text ?? '');
    }
    if (type.contains('voiceNote')) return '🎙 Mémo vocal';
    if (type.contains('photoShared')) return '📷 Photo';
    return '';
  }
}

