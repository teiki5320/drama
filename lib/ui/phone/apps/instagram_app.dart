import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Instagram — flux, stories en haut, posts du fil. Posts depuis
/// l'app PR1 (Camille J1, autres viendront avec moteur événements).
class InstagramApp extends ConsumerWidget {
  const InstagramApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final posts = _postsForDay(day);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          // Header Instagram
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFFE1306C), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text(
                  'Instagram',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Icon(Icons.send_outlined,
                    color: Colors.grey.shade700, size: 22),
              ],
            ),
          ),
          // Stories
          SizedBox(
            height: 90,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: const [
                _Story(name: 'Toi', emoji: '🌿', isMe: true),
                _Story(name: 'camille', emoji: '🥐'),
                _Story(name: 'heng_lihua', emoji: '🍵'),
                _Story(name: 't_heng', emoji: '🧊'),
                _Story(name: 'helene', emoji: '👩'),
                _Story(name: 'mei_fujian', emoji: '🌿'),
              ],
            ),
          ),
          const Divider(height: 0.5, color: Color(0xFFE5E5E5)),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, i) => _PostCard(post: posts[i]),
            ),
          ),
        ],
      ),
    );
  }

  List<_Post> _postsForDay(int day) {
    final all = const [
      _Post(
        author: 'camille_rx',
        emoji: '🥐',
        when: 'il y a 2h',
        body: 'Code civil, 14h, je suis vivante par miracle ✏️',
        gradient: [0xFFFCE6D8, 0xFFFAE0CC],
        likes: 47,
        atDay: 1,
      ),
      _Post(
        author: 't_heng',
        emoji: '🧊',
        when: 'hier',
        body: 'Hong Kong la semaine prochaine.',
        gradient: [0xFFD7DEE5, 0xFFB3BFC9],
        likes: 1284,
        atDay: 20,
      ),
      _Post(
        author: 'heng_lihua',
        emoji: '🍵',
        when: 'il y a 1 j',
        body: 'Le thé Long Jing première récolte, c\'est chez nous ce soir.',
        gradient: [0xFFE7E1D2, 0xFFCFC8B5],
        likes: 312,
        atDay: 13,
      ),
    ];
    return all.where((p) => p.atDay <= day).toList();
  }
}

class _Story extends StatelessWidget {
  const _Story({required this.name, required this.emoji, this.isMe = false});
  final String name;
  final String emoji;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isMe
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFFFD297B), Color(0xFFFF5722)]),
              color: isMe ? Colors.grey.shade300 : null,
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEFEFEF),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF1A1A1A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Post {
  final String author;
  final String emoji;
  final String when;
  final String body;
  final List<int> gradient;
  final int likes;
  final int atDay;
  const _Post({
    required this.author,
    required this.emoji,
    required this.when,
    required this.body,
    required this.gradient,
    required this.likes,
    required this.atDay,
  });
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final _Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(post.gradient.first),
                ),
                alignment: Alignment.center,
                child:
                    Text(post.emoji, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              Text(
                post.author,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Icon(Icons.more_horiz,
                  color: Colors.grey.shade600, size: 20),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: post.gradient.map((h) => Color(h)).toList(),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              post.emoji,
              style: const TextStyle(fontSize: 96),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(
            children: [
              const Icon(Icons.favorite_border, size: 24),
              const SizedBox(width: 14),
              const Icon(Icons.chat_bubble_outline, size: 24),
              const SizedBox(width: 14),
              const Icon(Icons.send_outlined, size: 24),
              const Spacer(),
              const Icon(Icons.bookmark_border, size: 24),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          child: Text(
            '${post.likes} mentions J\'aime',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF1A1A1A),
              ),
              children: [
                TextSpan(
                  text: '${post.author} ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: post.body),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Text(
            post.when,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(height: 4, color: Colors.grey.shade100),
      ],
    );
  }
}
