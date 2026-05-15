import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Instagram — flux + stories interactives + commentaires. Pour
/// que l'app vive, l'utilisateur peut liker, double-tap heart, voir les
/// stories plein écran, lire les commentaires, ne plus suivre.
class InstagramApp extends ConsumerStatefulWidget {
  const InstagramApp({super.key});

  @override
  ConsumerState<InstagramApp> createState() => _InstagramAppState();
}

class _InstagramAppState extends ConsumerState<InstagramApp> {
  // État local : likes ajoutés par Shen, posts cachés (unfollow),
  // stories déjà vues (le ring devient gris).
  final Set<String> _liked = {};
  final Set<String> _hidden = {};
  final Set<String> _viewedStories = {};

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final allPosts = _allPosts.where((p) => p.atDay <= day).toList();
    final visiblePosts =
        allPosts.where((p) => !_hidden.contains(p.id)).toList();
    final activeStories = _allStories
        .where((s) => s.fromDay <= day && day - s.fromDay < 1)
        .toList();
    if (activeStories.where((s) => s.isMe).isEmpty) {
      activeStories.insert(
        0,
        const _Story(
          id: 'me',
          name: 'Toi',
          emoji: '🌿',
          isMe: true,
          fromDay: 1,
          frames: [],
        ),
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
          // Stories — fenêtre 24h. Tap = plein écran. Ring gris une fois vu.
          SizedBox(
            height: 92,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: activeStories.map((s) => _StoryView(
                    story: s,
                    viewed: _viewedStories.contains(s.id),
                    onTap: () => _openStories(activeStories, s.id),
                  )).toList(),
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
                  onComments: () => _openComments(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openStories(List<_Story> stories, String startId) {
    final playable = stories
        .where((s) => !s.isMe && s.frames.isNotEmpty)
        .toList();
    final startIdx = playable.indexWhere((s) => s.id == startId);
    if (startIdx < 0) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (_, __, ___) => _StoriesViewer(
          stories: playable,
          startIdx: startIdx,
          onViewed: (id) => setState(() => _viewedStories.add(id)),
        ),
        transitionsBuilder: (_, a, __, child) => FadeTransition(
          opacity: a,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(a),
            child: child,
          ),
        ),
      ),
    );
  }

  void _openComments(_Post p) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, scrollCtrl) => Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Commentaires',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 10),
                  for (final c in p.comments)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor:
                                Color(c.avatarColor).withValues(alpha: 0.4),
                            child: Text(c.emoji,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${c.author} ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      TextSpan(text: c.text),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.when,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.favorite_border,
                              size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  if (p.comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'Aucun commentaire.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _allStories = <_Story>[
  _Story(
    id: 'camille',
    name: 'camille_rx',
    emoji: '🥐',
    fromDay: 1,
    frames: [
      _StoryFrame(
        emoji: '🥐',
        body: 'Bus 81 — 12 mecs me regardent réviser le Code civil.',
        gradient: [0xFFFCE6D8, 0xFFFAE0CC],
      ),
      _StoryFrame(
        emoji: '☕',
        body: 'Hanami — long ! Long ! Long ! Espresso doppio. Toujours debout.',
        gradient: [0xFF8B6F47, 0xFFD4A574],
      ),
    ],
  ),
  _Story(
    id: 'heng_lihua',
    name: 'heng_lihua',
    emoji: '🍵',
    fromDay: 13,
    frames: [
      _StoryFrame(
        emoji: '🍵',
        body: 'Long Jing 2026, première récolte. Le thé qu\'on offre une fois.',
        gradient: [0xFFE7E1D2, 0xFFCFC8B5],
      ),
      // J14 frame — cliffhanger : photo mains Shen sur la tasse
      _StoryFrame(
        emoji: '🌿',
        body: '« Ma fille a reconnu la deuxième récolte. »',
        gradient: [0xFFCFC8B5, 0xFFE7D9C2],
      ),
    ],
  ),
  _Story(
    id: 't_heng',
    name: 't_heng',
    emoji: '🧊',
    fromDay: 9,
    frames: [
      _StoryFrame(
        emoji: '🏢',
        body: '47e étage. Ciel pollué. On ne voit pas la mer aujourd\'hui.',
        gradient: [0xFFD7DEE5, 0xFFB3BFC9],
      ),
    ],
  ),
  _Story(
    id: 'helene',
    name: 'helene_paris',
    emoji: '👩',
    fromDay: 1,
    frames: [
      _StoryFrame(
        emoji: '📖',
        body: 'Duras — relu trois fois. À chaque fois plus dur.',
        gradient: [0xFFE8E0D0, 0xFFF5EFE2],
      ),
    ],
  ),
  _Story(
    id: 'mei',
    name: 'mei_fujian',
    emoji: '🌿',
    fromDay: 1,
    frames: [],
  ),
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
    imagePath: 'assets/photos/ep1/post_camille_bureau_droit.webp',
    comments: [
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: 'Tu te tiens à carreau, ma grande.',
        when: 'il y a 1h',
      ),
      _Comment(
        author: 'antoine_blkbrd',
        emoji: '🎧',
        avatarColor: 0xFF1F2937,
        text: 'On boit un verre ce week-end ?',
        when: 'il y a 1h',
      ),
    ],
  ),
  _Post(
    id: 'camille_cafe_j4',
    author: 'camille_rx',
    emoji: '☕',
    when: 'il y a 4h',
    body: 'Hanami. Long ! Long ! Long ! Espresso doppio. Toujours debout.',
    gradient: [0xFF8B6F47, 0xFFD4A574],
    likes: 124,
    atDay: 4,
    imagePath: 'assets/photos/ep1/post_camille_cafe.webp',
    comments: [],
  ),
  // J5 — Camille révise un samedi, gag léger
  _Post(
    id: 'camille_revisions_j5',
    author: 'camille_rx',
    emoji: '📚',
    when: 'samedi soir',
    body: 'Samedi soir. Code civil. Le chat dort sur le Code civil. Je vis.',
    gradient: [0xFFFAE0CC, 0xFFFCE6D8],
    likes: 73,
    atDay: 5,
    imagePath: 'assets/photos/ep1/post_camille_bureau_droit.webp',
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: 'Je viens.',
        when: 'il y a 12 min',
      ),
    ],
  ),
  _Post(
    id: 't_heng_j10',
    author: 't_heng',
    emoji: '🥃',
    when: 'il y a 6h',
    body: 'La pluie au 47e étage ne fait pas le même bruit qu\'à Belleville.',
    gradient: [0xFF1F2937, 0xFF374151],
    likes: 982,
    atDay: 10,
    imagePath: 'assets/photos/ep1/post_escalier_helice.webp',
    comments: [
      _Comment(
        author: 'vincent_h',
        emoji: '💼',
        avatarColor: 0xFFE89B7F,
        text: 'Closing demain. On se cale.',
        when: 'il y a 4h',
      ),
    ],
  ),
  _Post(
    id: 'camille_montmartre_j11',
    author: 'camille_rx',
    emoji: '🌅',
    when: 'il y a 2j',
    body: 'Coucher de soleil sur Montmartre. Le Code civil peut attendre dix minutes.',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    likes: 156,
    atDay: 11,
    imagePath: 'assets/photos/ep1/post_camille_montmartre.webp',
    comments: [],
  ),
  _Post(
    id: 'shen_camille_j12',
    author: 'shen_marchand',
    emoji: '🥐',
    when: 'il y a 1j',
    body: 'Avec @camille_rx. Un croissant pour deux. Pas négociable.',
    gradient: [0xFFFCE6D8, 0xFFFAE0CC],
    likes: 67,
    atDay: 12,
    imagePath: 'assets/photos/ep1/post_shen_camille_croissants.webp',
    comments: [
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: 'Tu manges enfin.',
        when: 'il y a 12h',
      ),
    ],
  ),
  _Post(
    id: 'heng_lihua_j13',
    author: 'heng_lihua',
    emoji: '🍵',
    when: 'il y a 1 j',
    body: 'Le Long Jing première récolte sera servi chez nous ce soir.',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    likes: 312,
    atDay: 13,
    imagePath: 'assets/photos/ep1/post_cartier_cadeau.webp',
    comments: [
      _Comment(
        author: 'auntmei_fj',
        emoji: '🌿',
        avatarColor: 0xFFD4A574,
        text: '小心 (fais attention).',
        when: 'il y a 22h',
      ),
    ],
  ),
  _Post(
    id: 'maman_plat_j14',
    author: 'helene_paris',
    emoji: '🍲',
    when: 'aujourd\'hui',
    body: 'Soupe d\'orge. Pour le jour où ma fille passera.',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    likes: 28,
    atDay: 14,
    imagePath: 'assets/photos/ep1/post_maman_plat.webp',
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: 'Dimanche.',
        when: 'il y a 2h',
      ),
    ],
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
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: 'Sans moi.',
        when: 'il y a 14h',
      ),
    ],
  ),
];

class _Story {
  final String id;
  final String name;
  final String emoji;
  final bool isMe;
  final int fromDay;
  final List<_StoryFrame> frames;

  const _Story({
    required this.id,
    required this.name,
    required this.emoji,
    required this.fromDay,
    required this.frames,
    this.isMe = false,
  });
}

class _StoryFrame {
  final String emoji;
  final String body;
  final List<int> gradient;
  const _StoryFrame({
    required this.emoji,
    required this.body,
    required this.gradient,
  });
}

class _StoryView extends StatefulWidget {
  const _StoryView({
    required this.story,
    required this.viewed,
    required this.onTap,
  });
  final _Story story;
  final bool viewed;
  final VoidCallback onTap;

  @override
  State<_StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<_StoryView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringActive =
        !widget.story.isMe && !widget.viewed && widget.story.frames.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: Column(
          children: [
            // Ring rotative quand active (= non vue + a des frames)
            AnimatedBuilder(
              animation: _rotateCtrl,
              builder: (context, child) {
                return Transform.rotate(
                  angle: ringActive ? _rotateCtrl.value * 6.283 : 0,
                  child: child,
                );
              },
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget.story.isMe
                      ? null
                      : (widget.viewed
                          ? null
                          : const SweepGradient(
                              colors: [
                                Color(0xFFFD297B),
                                Color(0xFFFF5722),
                                Color(0xFFFFC837),
                                Color(0xFFFD297B),
                              ],
                            )),
                  color: widget.story.isMe
                      ? Colors.grey.shade300
                      : (widget.viewed ? Colors.grey.shade400 : null),
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
                    child: Text(widget.story.emoji,
                        style: const TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.story.name,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Visionneuse de stories plein écran — progress bar en haut, tap droit
/// pour avancer, tap gauche pour revenir, swipe down pour fermer.
class _StoriesViewer extends StatefulWidget {
  const _StoriesViewer({
    required this.stories,
    required this.startIdx,
    required this.onViewed,
  });
  final List<_Story> stories;
  final int startIdx;
  final void Function(String storyId) onViewed;

  @override
  State<_StoriesViewer> createState() => _StoriesViewerState();
}

class _StoriesViewerState extends State<_StoriesViewer>
    with SingleTickerProviderStateMixin {
  late int _storyIdx = widget.startIdx;
  int _frameIdx = 0;
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4500),
  )..addStatusListener(_onFrameDone);

  _Story get _story => widget.stories[_storyIdx];

  @override
  void initState() {
    super.initState();
    widget.onViewed(_story.id);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onFrameDone(AnimationStatus s) {
    if (s == AnimationStatus.completed) _next();
  }

  void _next() {
    if (_frameIdx + 1 < _story.frames.length) {
      setState(() => _frameIdx++);
      _ctrl
        ..reset()
        ..forward();
    } else if (_storyIdx + 1 < widget.stories.length) {
      setState(() {
        _storyIdx++;
        _frameIdx = 0;
      });
      widget.onViewed(_story.id);
      _ctrl
        ..reset()
        ..forward();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prev() {
    if (_frameIdx > 0) {
      setState(() => _frameIdx--);
      _ctrl
        ..reset()
        ..forward();
    } else if (_storyIdx > 0) {
      setState(() {
        _storyIdx--;
        _frameIdx = widget.stories[_storyIdx].frames.length - 1;
      });
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final frame = _story.frames[_frameIdx];
    return GestureDetector(
      onVerticalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) > 200) Navigator.of(context).pop();
      },
      onTapUp: (d) {
        final w = MediaQuery.of(context).size.width;
        if (d.localPosition.dx < w / 3) {
          _prev();
        } else {
          _next();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: frame.gradient.map((h) => Color(h)).toList(),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                frame.emoji,
                style: const TextStyle(fontSize: 180),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 80,
              child: Text(
                frame.body,
                style: GoogleFonts.crimsonPro(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.35,
                  shadows: const [
                    Shadow(color: Colors.black, blurRadius: 16),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(_story.frames.length, (i) {
                        return Expanded(
                          child: Container(
                            height: 2.5,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: AnimatedBuilder(
                              animation: _ctrl,
                              builder: (_, __) {
                                final pct = i < _frameIdx
                                    ? 1.0
                                    : (i == _frameIdx ? _ctrl.value : 0.0);
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: pct,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white24,
                          child: Text(_story.emoji,
                              style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _story.name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon:
                              const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
  final List<_Comment> comments;
  /// Chemin asset de l'image post si dispo, sinon fallback gradient.
  final String? imagePath;
  const _Post({
    required this.id,
    required this.author,
    required this.emoji,
    required this.when,
    required this.body,
    required this.gradient,
    required this.likes,
    required this.atDay,
    this.comments = const [],
    this.imagePath,
  });
}

class _Comment {
  final String author;
  final String emoji;
  final int avatarColor;
  final String text;
  final String when;
  const _Comment({
    required this.author,
    required this.emoji,
    required this.avatarColor,
    required this.text,
    required this.when,
  });
}

class _PostCard extends StatefulWidget {
  const _PostCard({
    required this.post,
    required this.liked,
    required this.onLike,
    required this.onHide,
    required this.onComments,
  });
  final _Post post;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onHide;
  final VoidCallback onComments;

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
                child: p.imagePath != null
                    ? Image.asset(p.imagePath!, fit: BoxFit.cover)
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors:
                                p.gradient.map((h) => Color(h)).toList(),
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
                  final t = _heartCtrl.value;
                  final scale = 0.6 + (1.4 * t);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 1 - t,
                        child: Transform.scale(
                          scale: scale,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 110,
                          ),
                        ),
                      ),
                      // Particules cœur qui s'envolent dans 6 directions
                      for (var i = 0; i < 6; i++)
                        _HeartParticle(progress: t, angleIndex: i),
                    ],
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
              GestureDetector(
                onTap: widget.onComments,
                child: const Icon(Icons.chat_bubble_outline, size: 24),
              ),
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
            '${p.likes + (widget.liked ? 1 : 0)} j\'aime',
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
        if (p.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: GestureDetector(
              onTap: widget.onComments,
              child: Text(
                'Voir les ${p.comments.length} commentaire${p.comments.length > 1 ? "s" : ""}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
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

/// Petit cœur rouge qui s'envole en arc selon un angle (6 particules
/// se répartissent autour du cœur central au double-tap).
class _HeartParticle extends StatelessWidget {
  const _HeartParticle({required this.progress, required this.angleIndex});
  final double progress;
  final int angleIndex;

  @override
  Widget build(BuildContext context) {
    // Angles : 6 particules → 60° d'écart, partant du haut.
    final angle = (-90 + angleIndex * 60) * 3.14159 / 180;
    final dist = 80 * progress;
    final dx = dist * cos(angle);
    final dy = dist * sin(angle) - (40 * progress * progress); // gravité inverse
    final scale = 0.4 + 0.4 * (1 - progress);
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Opacity(
        opacity: (1 - progress).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scale,
          child: const Icon(
            Icons.favorite,
            color: Color(0xFFFF3B5C),
            size: 24,
          ),
        ),
      ),
    );
  }
}
