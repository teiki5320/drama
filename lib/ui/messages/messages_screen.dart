import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
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

const _tints = <String, Color>{
  'maman': Color(0xFFFCE6D8),
  'camille': Color(0xFFE0E7D7),
  'tristan': Color(0xFFD7DEE5),
  'vincent': Color(0xFFEBD8E0),
};

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final convos = state.unlockedConversations
        .where((id) => _displayNames.containsKey(id))
        .toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const BigTitle('Messages'),
          for (final id in convos) _ConversationTile(id: id),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
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
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0x141A1A1A)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _tints[id] ?? const Color(0xFFEFE7D6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _avatars[id] ?? '?',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayNames[id] ?? id,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Conversation débloquée',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
