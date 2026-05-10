import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../providers/game_state_provider.dart';
import 'conversation_view.dart';

const _avatars = <String, String>{
  'maman': '👩',
  'camille': '🥐',
  'tristan': '🧊',
  'vincent': '🥂',
};

const _displayNames = <String, String>{
  'maman': 'Maman ❤️',
  'camille': 'Camille',
  'tristan': 'Tristan',
  'vincent': 'Vincent',
};

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    // Skip raw scene flags ("tristan_sms", "scene_dimanche", …) that aren't
    // real conversations; show only ones we know how to render.
    final convos = state.unlockedConversations
        .where(_displayNames.containsKey)
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.separated(
        itemCount: convos.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 76),
        itemBuilder: (context, i) {
          final id = convos[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundColor:
                  AppColors.accentOrange.withValues(alpha: 0.18),
              child: Text(_avatars[id] ?? '?',
                  style: const TextStyle(fontSize: 20)),
            ),
            title: Text(_displayNames[id] ?? id,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            subtitle: Text(
              'Conversation débloquée',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ConversationView(
                    conversationId: id,
                    title: _displayNames[id] ?? id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
