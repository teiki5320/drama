import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../models/character.dart';
import '../../models/day_entry.dart';
import '../../models/sms_message.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/scenario_provider.dart';
import 'conversation_view.dart';

const _displayNames = <String, String>{
  'maman': 'Maman ❤️',
  'camille': 'Camille',
  'tristan': 'Tristan',
  'vincent': 'Vincent',
};

const _convoCharacterId = <String, String>{
  'maman': 'maman',
  'camille': 'camille',
  'tristan': 'tristan',
  'vincent': 'vincent',
};

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final scenario = ref.watch(scenarioProvider);

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: scenario.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur : $e')),
        data: (days) {
          final convos = state.unlockedConversations
              .where((id) => _displayNames.containsKey(id))
              .map((id) => _ConvoSummary.compute(
                    id: id,
                    days: days,
                    currentDay: state.currentDay,
                    seen: state.seenMessageThreads.contains(id),
                  ))
              .toList()
            ..sort((a, b) => b.lastDay.compareTo(a.lastDay));

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const BigTitle('Messages'),
              for (final c in convos) _ConversationTile(summary: c),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _ConvoSummary {
  final String id;
  final SmsMessage? lastMessage;
  final int lastDay;
  final bool unread;

  const _ConvoSummary({
    required this.id,
    required this.lastMessage,
    required this.lastDay,
    required this.unread,
  });

  static _ConvoSummary compute({
    required String id,
    required List<DayEntry> days,
    required int currentDay,
    required bool seen,
  }) {
    SmsMessage? last;
    var lastDay = 0;
    for (final d in days) {
      if (d.id > currentDay) break;
      for (final block in d.narrative) {
        if (block.type != NarrativeBlockType.sms) continue;
        if (block.conversation != id) continue;
        if (block.messages == null || block.messages!.isEmpty) continue;
        last = block.messages!.last;
        lastDay = d.id;
      }
    }
    return _ConvoSummary(
      id: id,
      lastMessage: last,
      lastDay: lastDay,
      unread: !seen && last != null,
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.summary});
  final _ConvoSummary summary;

  @override
  Widget build(BuildContext context) {
    final character = characterById(_convoCharacterId[summary.id] ?? '');
    final tint = character?.tint ?? const Color(0xFFEFE7D6);
    final displayName = _displayNames[summary.id] ?? summary.id;
    final last = summary.lastMessage;
    final previewSender =
        last == null ? '' : (last.isMe ? 'Toi : ' : '');
    final preview = last == null
        ? 'Conversation débloquée'
        : '$previewSender${last.content}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConversationView(
                conversationId: summary.id,
                title: displayName,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0x141A1A1A)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tint,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: character?.photoAsset == null
                        ? Text(
                            character?.emoji ?? '?',
                            style: const TextStyle(fontSize: 22),
                          )
                        : Image.asset(
                            character!.photoAsset!,
                            fit: BoxFit.cover,
                            cacheWidth: 144,
                            errorBuilder: (_, __, ___) => Text(
                              character.emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                  ),
                  if (summary.unread)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.negative,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
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
                            displayName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (summary.lastDay > 0)
                          Text(
                            formatGameDateShort(summary.lastDay),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: summary.unread
                                  ? AppColors.accentOrange
                                  : AppColors.textSecondary,
                              fontWeight: summary.unread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: summary.unread
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: summary.unread
                            ? FontWeight.w600
                            : FontWeight.w400,
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
  }
}
