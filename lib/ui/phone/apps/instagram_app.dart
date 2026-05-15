import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Instagram — flux, stories en haut, posts du fil. Posts depuis
/// l'app PR1 (Camille J1, autres viendront avec moteur événements).
class InstagramApp extends ConsumerStatefulWidget {
  const InstagramApp({super.key});

  @override
  ConsumerState<InstagramApp> createState() => _InstagramAppState();
}

class _InstagramAppState extends ConsumerState<InstagramApp> {
  // État local : likes ajoutés par Shen + posts cachés (unfollow).
  final Set<String> _liked = {};
  final Set<String> _hidden = {};

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final allPosts = _allPosts.where((p) => p.atDay <= day).toList();
    final visiblePosts =
        allPosts.where((p) => !_hidden.contains(p.id)).toList();
    final activeStories =
        _allStories.where((s) => s.fromDay <= day && day - s.fromDay < 1).toList();
    if (activeStories.where((s) => s.isMe).isEmpty) {
      activeStories.insert(
        0,
        const _Story(
            id: 'me', name: 'Toi', emoji: '🌿', isMe: true, fromDay: 1),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
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
          // Stories — uniquement celles « actives » (J - fromDay < 1)
          SizedBox(
            height: 92,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: activeStories.map((s) => _StoryView(story: s)).toList(),
            ),
          ),
          const Divider(height: 0.5, color: Color(0xFFE5E5E5)),
          Expanded(
            child: ListView.builder(
              itemCount: visiblePosts.length,
              itemBuilder: (context, i) {
                final p = visiblePosts[i];
                return _PostCard(
                  post: p,
                  liked: _liked.contains(p.id),
                  onLike: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (_liked.contains(p.id)) {
                        _liked.remove(p.id);
                      } else {
                        _liked.add(p.id);
                      }
                    });
                  },
                  onHide: () {
                    HapticFeedback.mediumImpact();
                    setState(() => _hidden.add(p.id));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _allStories = <_Story>[
  _Story(id: 'camille', name: 'camille_rx', emoji: '🥐', fromDay: 1),
  _Story(id: 'heng_lihua', name: 'heng_lihua', emoji: '🍵', fromDay: 13),
  _Story(id: 't_heng', name: 't_heng', emoji: '🧊', fromDay: 9),
  _Story(id: 'helene', name: 'helene_paris', emoji: '👩', fromDay: 1),
  _Story(id: 'mei', name: 'mei_fujian', emoji: '🌿', fromDay: 1),
];

const _allPosts = <_Post>[
  _Post(
    id: 'camille_j1',
    author: 'camille_rx',
    emoji: '🥐',
    when: 'il y a 2h',
    body: 'Code civil, 14h, je suis vivante par miracle ✏️',
    gradient: [0xFFFCE6D8, 0xFFFAE0CC],
    likes: 47,
    atDay: 1,
  ),
  _Post(
    id: 'heng_lihua_j13',
    author: 'heng_lihua',
    emoji: '🍵',
    when: 'il y a 1 j',
    body: 'Le thé Long Jing première récolte, c\'est chez nous ce soir.',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    likes: 312,
    atDay: 13,
  ),
  _Post(
    id: 't_heng_j20',
    author: 't_heng',
    emoji: '🧊',
    when: 'hier',
    body: 'Hong Kong la semaine prochaine.',
    gradient: [0xFFD7DEE5, 0xFFB3BFC9],
    likes: 1284,
    atDay: 20,
  ),
];

class _Story {
  final String id;
  final String name;
  final String emoji;
  final bool isMe;
  final int fromDay;

  const _Story({
    required this.id,
    required this.name,
    required this.emoji,
    required this.fromDay,
    this.isMe = false,
  });
}

class _StoryView extends StatelessWidget {
  const _StoryView({required this.story});
  final _Story story;

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
              gradient: story.isMe
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFFFD297B), Color(0xFFFF5722)]),
              color: story.isMe ? Colors.grey.shade300 : null,
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
                child: Text(story.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            story.name,
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
  final String id;
  final String author;
  final String emoji;
  final String when;
  final String body;
  final List<int> gradient;
  final int likes;
  final int atDay;
  const _Post({
    required this.id,
    required this.author,
    required this.emoji,
    required this.when,
    required this.body,
    required this.gradient,
    required this.likes,
    required this.atDay,
  });
}

class _PostCard extends StatefulWidget {
  const _PostCard({
    required this.post,
    required this.liked,
    required this.onLike,
    required this.onHide,
  });
  final _Post post;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onHide;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _doubleTap() {
    if (!widget.liked) widget.onLike();
    _heartCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
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
                  color: Color(p.gradient.first),
                ),
                alignment: Alignment.center,
                child: Text(p.emoji, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              Text(
                p.author,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showPostMenu(context),
                child: Icon(Icons.more_horiz,
                    color: Colors.grey.shade600, size: 20),
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: _doubleTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: p.gradient.map((h) => Color(h)).toList(),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    p.emoji,
                    style: const TextStyle(fontSize: 96),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _heartCtrl,
                builder: (_, __) {
                  if (_heartCtrl.value == 0) return const SizedBox.shrink();
                  final scale = 0.6 + (1.4 * _heartCtrl.value);
                  return Opacity(
                    opacity: 1 - _heartCtrl.value,
                    child: Transform.scale(
                      scale: scale,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 110,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onLike,
                child: Icon(
                  widget.liked ? Icons.favorite : Icons.favorite_border,
                  color: widget.liked ? const Color(0xFFE53935) : null,
                  size: 24,
                ),
              ),
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
            '${p.likes + (widget.liked ? 1 : 0)} mentions J\'aime',
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
                  text: '${p.author} ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: p.body),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Text(
            p.when,
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

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_remove, color: Color(0xFFE53935)),
              title: Text(
                'Ne plus suivre ${widget.post.author}',
                style: GoogleFonts.inter(color: const Color(0xFFE53935)),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                widget.onHide();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Annuler'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
