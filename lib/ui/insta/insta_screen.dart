import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';
import 'post_card.dart';
import 'profile_header.dart';

class InstaScreen extends ConsumerWidget {
  const InstaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final async = ref.watch(instaSeedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Instagram')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur : $e')),
        data: (posts) {
          final visible = posts
              .where((p) => p.day <= state.currentDay)
              .toList(growable: false)
            ..sort((a, b) => b.day.compareTo(a.day));

          return ListView(
            children: [
              const ProfileHeader(),
              const Divider(height: 1),
              const SizedBox(height: 12),
              if (visible.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Pas encore de publications.')),
                )
              else
                for (final p in visible) PostCard(post: p),
            ],
          );
        },
      ),
    );
  }
}
