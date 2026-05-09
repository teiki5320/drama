import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/day_entry.dart';
import '../../models/sms_message.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/scenario_provider.dart';
import '../carnet/sms_bubble.dart';

/// Displays every SMS block addressed to a given conversation up to and
/// including the current day. Inline-only blocks (`_inline`) are skipped.
class ConversationView extends ConsumerWidget {
  const ConversationView({
    super.key,
    required this.conversationId,
    required this.title,
  });

  final String conversationId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenario = ref.watch(scenarioProvider);
    final state = ref.watch(gameStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: scenario.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur : $e')),
        data: (days) {
          final messages = <SmsMessage>[];
          for (final d in days) {
            if (d.id > state.currentDay) break;
            for (final block in d.narrative) {
              if (block.type != NarrativeBlockType.sms) continue;
              if (block.conversation != conversationId) continue;
              if (block.messages != null) messages.addAll(block.messages!);
            }
          }

          if (messages.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Text(
                  'Pas encore de message dans cette conversation.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              for (final m in messages) SmsBubble(message: m),
            ],
          );
        },
      ),
    );
  }
}
