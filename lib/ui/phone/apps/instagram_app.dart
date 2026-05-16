import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../../../providers/relationships_provider.dart';
import '../status_bar.dart';

/// Instagram — vraie app sociale dans le téléphone de Shen. 5 onglets :
/// Home / Reels / Suggestions / Activity / Profile.
/// 20 features : stories Tristan rares, Madame Heng architecte,
/// stories archivées, live Camille, Maman auto-likes Camille, suggestés,
/// tag retirable J14, reels, DM, activity, follower count dynamique,
/// Mei unfollow J12, like Tristan archived, hashtag FemmesHengParis,
/// caption Shen, brouillons, story bingo Maman, mode sombre 22h+,
/// loading shimmer.
class InstagramApp extends ConsumerStatefulWidget {
  const InstagramApp({super.key});

  @override
  ConsumerState<InstagramApp> createState() => _InstagramAppState();
}

class _InstagramAppState extends ConsumerState<InstagramApp> {
  final Set<String> _liked = {};
  final Set<String> _hidden = {};
  final Set<String> _viewedStories = {};
  final Set<String> _viewedReels = {};
  bool _tagRetire = false;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(phoneStateProvider);
    final day = p.currentDay;
    final hour = p.hour;
    final isDark = hour >= 22 || hour < 7;
    final suspicionMaman =
        ref.watch(relationshipsProvider)['maman']?.suspicion ?? 0;

    final bg = isDark ? Colors.black : Colors.white;
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final sep = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          PhoneStatusBar(foreground: fg),
          _Header(isDark: isDark, fg: fg, onClose: () {
            HapticFeedback.selectionClick();
            ref.read(phoneStateProvider.notifier).closeApp();
          }),
          Divider(height: 0.5, color: sep),
          Expanded(
            child: switch (_tab) {
              1 => _ReelsTab(
                  day: day,
                  isDark: isDark,
                  viewedReels: _viewedReels,
                  onView: (id) => setState(() => _viewedReels.add(id)),
                ),
              2 => _SuggestionsTab(day: day, isDark: isDark),
              3 => _ActivityTab(day: day, isDark: isDark, suspicion: suspicionMaman),
              4 => _ProfileTab(
                  day: day,
                  isDark: isDark,
                  posts: p.userPhotos.length,
                ),
              _ => _FeedTab(
                  day: day,
                  isDark: isDark,
                  liked: _liked,
                  hidden: _hidden,
                  viewedStories: _viewedStories,
                  tagRetire: _tagRetire,
                  suspicionMaman: suspicionMaman,
                  onLike: (id) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (_liked.contains(id)) {
                        _liked.remove(id);
                      } else {
                        _liked.add(id);
                      }
                    });
                  },
                  onHide: (id) {
                    HapticFeedback.mediumImpact();
                    setState(() => _hidden.add(id));
                  },
                  onViewStory: (id) =>
                      setState(() => _viewedStories.add(id)),
                  onRetireTag: () => setState(() => _tagRetire = true),
                ),
            },
          ),
          _BottomNav(
            tab: _tab,
            isDark: isDark,
            onChange: (i) {
              HapticFeedback.selectionClick();
              setState(() => _tab = i);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Header (logo + plane DM) ──────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.isDark, required this.fg, required this.onClose});
  final bool isDark;
  final Color fg;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: const Color(0xFFE1306C), size: 20),
            onPressed: onClose,
          ),
          Text(
            'Instagram',
            style: GoogleFonts.crimsonPro(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: fg,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Spacer(),
          Icon(Icons.favorite_border, color: fg, size: 24),
          const SizedBox(width: 16),
          Builder(builder: (ctx) {
            return GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: ctx,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _DMSheet(isDark: isDark),
              ),
              child: Icon(Icons.send_outlined, color: fg, size: 24),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Bottom nav 5 onglets ──────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.tab,
    required this.isDark,
    required this.onChange,
  });
  final int tab;
  final bool isDark;
  final void Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final muted = isDark ? Colors.white38 : Colors.grey.shade400;
    final icons = const [
      Icons.home_outlined,
      Icons.movie_outlined,
      Icons.search,
      Icons.favorite_outline,
      Icons.person_outline,
    ];
    final iconsFilled = const [
      Icons.home,
      Icons.movie,
      Icons.search,
      Icons.favorite,
      Icons.person,
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: isDark
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFE5E5E5),
                width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            final active = i == tab;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChange(i),
                child: Icon(
                  active ? iconsFilled[i] : icons[i],
                  color: active ? fg : muted,
                  size: 26,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// TAB 0 — FEED
// ════════════════════════════════════════════════════════════════

class _FeedTab extends ConsumerWidget {
  const _FeedTab({
    required this.day,
    required this.isDark,
    required this.liked,
    required this.hidden,
    required this.viewedStories,
    required this.tagRetire,
    required this.suspicionMaman,
    required this.onLike,
    required this.onHide,
    required this.onViewStory,
    required this.onRetireTag,
  });
  final int day;
  final bool isDark;
  final Set<String> liked;
  final Set<String> hidden;
  final Set<String> viewedStories;
  final bool tagRetire;
  final int suspicionMaman;
  final void Function(String) onLike;
  final void Function(String) onHide;
  final void Function(String) onViewStory;
  final VoidCallback onRetireTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPosts = _allPosts.where((p) => p.atDay <= day).toList();
    final visiblePosts =
        allPosts.where((p) => !hidden.contains(p.id)).toList();
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

    return Column(
      children: [
        SizedBox(
          height: 92,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: activeStories
                .map((s) => _StoryView(
                      story: s,
                      viewed: viewedStories.contains(s.id),
                      isDark: isDark,
                      onTap: () => _openStories(context, activeStories, s.id, onViewStory),
                    ))
                .toList(),
          ),
        ),
        Divider(
            height: 0.5,
            color: isDark
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFE5E5E5)),
        Expanded(
          child: ListView.builder(
            itemCount: visiblePosts.length,
            itemBuilder: (context, i) {
              final p = visiblePosts[i];
              // Tag Shen sur le post heng_lihua J14
              final hasTag = p.id == 'heng_lihua_j14_tag' && !tagRetire;
              return _PostCard(
                post: p,
                liked: liked.contains(p.id),
                isDark: isDark,
                hasTag: hasTag,
                suspicionMaman: suspicionMaman,
                onLike: () => onLike(p.id),
                onHide: () => onHide(p.id),
                onComments: () => _openComments(context, p, isDark),
                onRetireTag: onRetireTag,
                onHashtag: (h) => _openHashtag(context, h, isDark),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openStories(BuildContext context, List<_Story> stories, String startId,
      void Function(String) onView) {
    final playable =
        stories.where((s) => !s.isMe && s.frames.isNotEmpty).toList();
    final startIdx = playable.indexWhere((s) => s.id == startId);
    if (startIdx < 0) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (_, __, ___) => _StoriesViewer(
          stories: playable,
          startIdx: startIdx,
          onViewed: onView,
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

  void _openComments(BuildContext context, _Post p, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => _CommentsSheet(post: p, isDark: isDark),
    );
  }

  void _openHashtag(BuildContext context, String hashtag, bool isDark) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _HashtagView(hashtag: hashtag, isDark: isDark),
    ));
  }
}

// ─── Data : Stories ─────────────────────────────────────────────

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
        body: 'Hanami — long ! Long ! Long ! Espresso doppio. Toujours debout.',
        gradient: [0xFF8B6F47, 0xFFD4A574],
      ),
    ],
    viewerCount: 47,
  ),
  // Idée 5 — Live Camille J5 21h
  _Story(
    id: 'camille_live',
    name: 'camille_rx',
    emoji: '🔴',
    fromDay: 5,
    frames: [
      _StoryFrame(
        emoji: '📖',
        body: '🔴 EN DIRECT · Code civil samedi soir, je veux mourir.\n'
            '« 8 min · 23 spectateurs »',
        gradient: [0xFFFAE0CC, 0xFFE89B7F],
      ),
    ],
    viewerCount: 23,
    isLive: true,
  ),
  // Idée 18 — Bingo Maman J5
  _Story(
    id: 'helene',
    name: 'helene_paris',
    emoji: '👩',
    fromDay: 5,
    frames: [
      _StoryFrame(
        emoji: '👶',
        body: 'Petits-fils de mes amies ce week-end.\n'
            'Camille en a un. Béatrice en a deux.',
        gradient: [0xFFFCE6D8, 0xFFFAE0CC],
      ),
      _StoryFrame(
        emoji: '📖',
        body: 'Duras — relu trois fois. À chaque fois plus dur.',
        gradient: [0xFFE8E0D0, 0xFFF5EFE2],
      ),
    ],
    viewerCount: 8,
  ),
  // Idée 2 — Stories Madame Heng via architecte avec geo-tag
  _Story(
    id: 'mme_heng_archi',
    name: 'parisluxuryinteriors',
    emoji: '🏛️',
    fromDay: 8,
    frames: [
      _StoryFrame(
        emoji: '🪞',
        body: 'Projet récent · 16ᵉ arrondissement.\n'
            '📍 Avenue Foch, Paris',
        gradient: [0xFFE7E1D2, 0xFFCFC8B5],
      ),
      _StoryFrame(
        emoji: '🛋️',
        body: 'Salon · Long Jing au bar dressé.\n'
            '« La cliente, Mme Heng, choisit elle-même les fleurs. »',
        gradient: [0xFFCFC8B5, 0xFFE8E0D0],
      ),
    ],
    viewerCount: 412,
  ),
  // Idée 1 — Tristan rare (vu par X, dont vous)
  _Story(
    id: 't_heng',
    name: 't_heng',
    emoji: '🧊',
    fromDay: 9,
    frames: [
      _StoryFrame(
        emoji: '🏢',
        body: '47e étage. Ciel pollué.\n'
            'On ne voit pas la mer aujourd\'hui.',
        gradient: [0xFFD7DEE5, 0xFFB3BFC9],
      ),
    ],
    viewerCount: 1274,
    rare: true,
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
      _StoryFrame(
        emoji: '🌿',
        body: '« Ma fille a reconnu la deuxième récolte. »',
        gradient: [0xFFCFC8B5, 0xFFE7D9C2],
      ),
    ],
    viewerCount: 312,
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
        mamanAutoLike: true,
      ),
      _Comment(
        author: 'antoine_blkbrd',
        emoji: '🎧',
        avatarColor: 0xFF1F2937,
        text: 'On boit un verre ce week-end ?',
        when: 'il y a 1h',
      ),
    ],
  ),
  _Post(
    id: 'camille_cafe_j4',
    author: 'camille_rx',
    emoji: '☕',
    when: 'il y a 4h',
    body: 'Hanami. Long ! Long ! Long ! Espresso doppio. Toujours debout.',
    gradient: [0xFF8B6F47, 0xFFD4A574],
    likes: 124,
    atDay: 4,
    imagePath: 'assets/photos/ep1/post_camille_cafe.webp',
    comments: [
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: '❤️',
        when: 'il y a 3h',
        mamanAutoLike: true,
      ),
    ],
  ),
  _Post(
    id: 'camille_revisions_j5',
    author: 'camille_rx',
    emoji: '📚',
    when: 'samedi soir',
    body: 'Samedi soir. Code civil. Le chat dort sur le PVT. Je vis.',
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
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: 'Vous mangez bien au moins, les filles ?',
        when: 'il y a 8 min',
        mamanAutoLike: true,
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
    hashtag: 'FemmesHengParis',
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
    comments: [
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: 'C\'est beau.',
        when: 'il y a 1j',
        mamanAutoLike: true,
      ),
    ],
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
        mamanAutoLike: true,
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
    hashtag: 'FemmesHengParis',
  ),
  // Idée 8 — Post Shen identifiée par heng_lihua J14
  _Post(
    id: 'heng_lihua_j14_tag',
    author: 'heng_lihua',
    emoji: '🌿',
    when: 'hier soir',
    body: 'Avec @shen_marchand · Long Jing deuxième récolte.\n'
        'Bienvenue, ma fille.',
    gradient: [0xFFCFC8B5, 0xFFE7D9C2],
    likes: 487,
    atDay: 14,
    comments: [
      _Comment(
        author: 'vincent_h',
        emoji: '💼',
        avatarColor: 0xFFE89B7F,
        text: 'Welcome to the family.',
        when: 'il y a 2h',
      ),
      _Comment(
        author: 'auntmei_fj',
        emoji: '🌿',
        avatarColor: 0xFFD4A574,
        text: '...',
        when: 'il y a 1h',
      ),
    ],
    hashtag: 'FemmesHengParis',
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
  // ─── Posts antérieurs J-30 → J0 (texture du passé) ──────────────
  _Post(
    id: 'tristan_jm26',
    author: 't_heng',
    emoji: '🏙️',
    when: 'il y a 1 mois',
    body: 'Tour Heng, 47e étage. La vue, encore une fois.',
    gradient: [0xFF1F2937, 0xFF374151],
    likes: 10240,
    atDay: 1,
    imagePath: 'assets/photos/ep1/post_escalier_helice.webp',
    comments: [
      _Comment(
        author: 'sophie_lvf',
        emoji: '🥂',
        avatarColor: 0xFFD4A574,
        text: 'tu sors jamais d\'ici Tristan 😅',
        when: 'il y a 1 mois',
      ),
    ],
  ),
  _Post(
    id: 'vincent_jm24',
    author: 'vincent_h',
    emoji: '🍂',
    when: 'il y a 1 mois',
    body: 'Cigare cubain. Le bon, pas celui des autres.',
    gradient: [0xFF553C2A, 0xFF2D1F12],
    likes: 5870,
    atDay: 1,
    comments: [
      _Comment(
        author: 'laurent_bdx',
        emoji: '🥃',
        avatarColor: 0xFF553C2A,
        text: 'toi tu vas finir comme ton grand-père 🫠',
        when: 'il y a 4 sem.',
      ),
    ],
  ),
  _Post(
    id: 'madame_heng_jm22',
    author: 'heng_lihua',
    emoji: '🌅',
    when: 'il y a 3 sem.',
    body: 'Le matin chinois commence avant le soleil.',
    gradient: [0xFFCFC8B5, 0xFFE7D9C2],
    likes: 1820,
    atDay: 1,
    comments: [
      _Comment(
        author: 'madame_chen_paris',
        emoji: '🍵',
        avatarColor: 0xFFE7E1D2,
        text: 'toujours juste 🙏',
        when: 'il y a 3 sem.',
      ),
    ],
  ),
  _Post(
    id: 'helene_jm16',
    author: 'helene_paris',
    emoji: '🌸',
    when: 'il y a 2 sem.',
    body: 'Cinq pivoines blanches chez le syrien. Du courage en bouquet.',
    gradient: [0xFFFCE6D8, 0xFFE7B5C8],
    likes: 62,
    atDay: 1,
    comments: [
      _Comment(
        author: 'camille_rx',
        emoji: '🥐',
        avatarColor: 0xFFFCE6D8,
        text: 'vous me faites toujours pleurer pour rien madame Marchand 🤍',
        when: 'il y a 2 sem.',
      ),
    ],
  ),
  _Post(
    id: 'mei_fujian_jm18',
    author: 'auntmei_fj',
    emoji: '🌾',
    when: 'il y a 2 sem.',
    body: 'Le riz cette année est bon. Le vent vient du sud.',
    gradient: [0xFF8AA070, 0xFF40583A],
    likes: 184,
    atDay: 1,
    imagePath: 'assets/photos/ep1/post_oncle_fujian.webp',
    comments: [
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: '想念你。',
        when: 'il y a 2 sem.',
        mamanAutoLike: true,
      ),
    ],
  ),
  // ─── Posts Ép. 2 (J15 → J30) ─────────────────────────────────
  _Post(
    id: 'heng_lihua_j15',
    author: 'heng_lihua',
    emoji: '🍵',
    when: 'ce matin',
    body: 'Long Jing deuxième récolte d\'hier. Elle a su.',
    gradient: [0xFFCFC8B5, 0xFFE7D9C2],
    likes: 614,
    atDay: 15,
    imagePath: 'assets/photos/ep1/j14_boite_long_jing.webp',
    comments: [
      _Comment(
        author: 'vincent_h',
        emoji: '💼',
        avatarColor: 0xFFE89B7F,
        text: 'Mère, vous prenez vos décisions sans nous.',
        when: 'il y a 4h',
      ),
    ],
    hashtag: 'FemmesHengParis',
  ),
  _Post(
    id: 'camille_j16',
    author: 'camille_rx',
    emoji: '🥐',
    when: 'hier',
    body: 'Boot Café avec @shen_marchand. Elle a souri 1.5 fois en 2 heures. Record.',
    gradient: [0xFFFCE6D8, 0xFFE7C5A8],
    likes: 92,
    atDay: 16,
    imagePath: 'assets/photos/ep1/post_camille_cafe.webp',
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: '2.5 en fait.',
        when: 'il y a 3h',
      ),
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: '❤️',
        when: 'il y a 1h',
        mamanAutoLike: true,
      ),
    ],
  ),
  _Post(
    id: 'vincent_j18',
    author: 'vincent_h',
    emoji: '🥃',
    when: 'hier soir',
    body: 'Whisky japonais. Décision prise. Je serai à HK le 32.',
    gradient: [0xFF553C2A, 0xFF2D1F12],
    likes: 3210,
    atDay: 18,
    comments: [
      _Comment(
        author: 't_heng',
        emoji: '🥃',
        avatarColor: 0xFF1F2937,
        text: 'À mon avis non.',
        when: 'il y a 12h',
      ),
    ],
  ),
  _Post(
    id: 't_heng_j22',
    author: 't_heng',
    emoji: '🌃',
    when: 'aujourd\'hui',
    body: 'Quartier financier. Six heures de réunions. Trois heures de silence.',
    gradient: [0xFF1F2937, 0xFF111827],
    likes: 4108,
    atDay: 22,
    imagePath: 'assets/photos/ep1/j07_47e_etage_bureau_tristan.webp',
    comments: [],
  ),
  _Post(
    id: 'camille_j26',
    author: 'camille_rx',
    emoji: '😤',
    when: 'il y a 1j',
    body: 'Quand ton amie disparaît pendant 8 jours. Indice : ce n\'est pas drôle.',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    likes: 47,
    atDay: 26,
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: 'Pardon.',
        when: 'il y a 12h',
      ),
    ],
  ),
  _Post(
    id: 'heng_lihua_j30_gala',
    author: 'heng_lihua',
    emoji: '🎭',
    when: 'hier soir',
    body: 'Le gala 2026. Sept générations de pivoines au centre.',
    gradient: [0xFFCFC8B5, 0xFFE7D9C2],
    likes: 14820,
    atDay: 30,
    imagePath: 'assets/photos/ep1/post_cartier_cadeau.webp',
    comments: [
      _Comment(
        author: 'sophie_lvf',
        emoji: '🥂',
        avatarColor: 0xFFD4A574,
        text: 'la jeune fille à droite, elle est superbe',
        when: 'il y a 14h',
      ),
      _Comment(
        author: 'auntmei_fj',
        emoji: '🌿',
        avatarColor: 0xFFD4A574,
        text: '...',
        when: 'il y a 10h',
      ),
    ],
    hashtag: 'FemmesHengParis',
  ),
  // ─── Posts Ép. 3 (J32 → J40 Hong Kong) ───────────────────────
  _Post(
    id: 't_heng_j32',
    author: 't_heng',
    emoji: '✈️',
    when: 'aujourd\'hui',
    body: 'Vol Paris → HK. Première fois que j\'emporte quelqu\'un de Paris.',
    gradient: [0xFF1F2937, 0xFF374151],
    likes: 8240,
    atDay: 32,
    imagePath: 'assets/photos/ep1/pj_billet_avion_cdg.webp',
    comments: [
      _Comment(
        author: 'vincent_h',
        emoji: '💼',
        avatarColor: 0xFFE89B7F,
        text: 'On en reparle.',
        when: 'il y a 4h',
      ),
    ],
  ),
  _Post(
    id: 'helene_j33',
    author: 'helene_paris',
    emoji: '🤔',
    when: 'hier',
    body: 'Ma fille est en stage à Lyon depuis 12h. Le mistral est doux à Lyon.',
    gradient: [0xFFFCE6D8, 0xFFE7B5C8],
    likes: 18,
    atDay: 33,
    comments: [
      _Comment(
        author: 'camille_rx',
        emoji: '🥐',
        avatarColor: 0xFFFCE6D8,
        text: '❤️',
        when: 'il y a 8h',
      ),
    ],
  ),
  _Post(
    id: 'auntmei_j35',
    author: 'auntmei_fj',
    emoji: '🍵',
    when: 'aujourd\'hui',
    body: 'Une jeune fille de Paris est venue chez nous. Elle s\'appelle comme ma sœur.',
    gradient: [0xFF8AA070, 0xFF40583A],
    likes: 312,
    atDay: 35,
    imagePath: 'assets/photos/ep1/post_oncle_fujian.webp',
    comments: [
      _Comment(
        author: 'helene_paris',
        emoji: '👩',
        avatarColor: 0xFFFCE6D8,
        text: 'Quelle jeune fille ?',
        when: 'il y a 2h',
      ),
    ],
  ),
  _Post(
    id: 't_heng_j38',
    author: 't_heng',
    emoji: '🌃',
    when: 'cette nuit',
    body: 'Lan Kwai Fong. Plus tard.',
    gradient: [0xFF1F2937, 0xFF553C2A],
    likes: 6240,
    atDay: 38,
    comments: [],
  ),
  // ─── Posts Ép. 4 (J41 → J80) ──────────────────────────────────
  _Post(
    id: 'helene_j42',
    author: 'helene_paris',
    emoji: '🌧️',
    when: 'aujourd\'hui',
    body: 'La pluie ne s\'arrête pas. Je n\'ai rien à dire d\'autre.',
    gradient: [0xFF8AA070, 0xFF6B7280],
    likes: 24,
    atDay: 42,
    comments: [
      _Comment(
        author: 'camille_rx',
        emoji: '🥐',
        avatarColor: 0xFFFCE6D8,
        text: 'Je passe demain.',
        when: 'il y a 3h',
      ),
    ],
  ),
  _Post(
    id: 'helene_j45',
    author: 'helene_paris',
    emoji: '🌷',
    when: 'aujourd\'hui',
    body: 'Le traitement commence à 10h. Une fleur que je n\'avais pas demandée.',
    gradient: [0xFFFCE6D8, 0xFFE7B5C8],
    likes: 142,
    atDay: 45,
    imagePath: 'assets/photos/ep1/pj_maman_plat.webp',
    comments: [
      _Comment(
        author: 'camille_rx',
        emoji: '🥐',
        avatarColor: 0xFFFCE6D8,
        text: 'Tenez bon Madame Marchand 🤍',
        when: 'il y a 4h',
      ),
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: '❤️',
        when: 'il y a 2h',
      ),
    ],
  ),
  _Post(
    id: 'camille_j52',
    author: 'camille_rx',
    emoji: '🌧️',
    when: 'aujourd\'hui',
    body: 'Mon amie est devenue silencieuse. Je l\'attendrai.',
    gradient: [0xFFFCE6D8, 0xFFCFC8B5],
    likes: 81,
    atDay: 52,
    comments: [],
  ),
  _Post(
    id: 't_heng_j52',
    author: 't_heng',
    emoji: '📜',
    when: 'ce soir',
    body: 'Le contrat est échu. Le solde a été versé. Pas plus.',
    gradient: [0xFF1F2937, 0xFF111827],
    likes: 14000,
    atDay: 52,
    comments: [
      _Comment(
        author: 'vincent_h',
        emoji: '💼',
        avatarColor: 0xFFE89B7F,
        text: 'On ne ferme pas comme ça.',
        when: 'il y a 1h',
      ),
    ],
  ),
  _Post(
    id: 'camille_anniv_j60',
    author: 'camille_rx',
    emoji: '🎂',
    when: 'hier',
    body: '24 ans. Croissant pour deux mais elle n\'est pas venue.',
    gradient: [0xFFFCE6D8, 0xFFFAE0CC],
    likes: 218,
    atDay: 60,
    imagePath: 'assets/photos/ep1/post_camille_cafe.webp',
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: 'Je suis désolée.',
        when: 'il y a 12h',
      ),
    ],
  ),
  _Post(
    id: 'helene_j72',
    author: 'helene_paris',
    emoji: '🌿',
    when: 'aujourd\'hui',
    body: 'Bilan favorable. Le médecin a souri pour la première fois.',
    gradient: [0xFF8AA070, 0xFFC8D2A8],
    likes: 312,
    atDay: 72,
    imagePath: 'assets/photos/ep1/j11_maman_fenetre_paris.webp',
    comments: [
      _Comment(
        author: 'auntmei_fj',
        emoji: '🌿',
        avatarColor: 0xFFD4A574,
        text: '回家 (rentre à la maison).',
        when: 'il y a 8h',
      ),
    ],
  ),
  // ─── Posts Ép. 5 (J80 → J112 Fujian) ─────────────────────────
  _Post(
    id: 'helene_j80_vol',
    author: 'helene_paris',
    emoji: '✈️',
    when: 'aujourd\'hui',
    body: 'Premier vol depuis 1998. Ma fille me tient la main.',
    gradient: [0xFF8AA070, 0xFFE7D9C2],
    likes: 481,
    atDay: 80,
    imagePath: 'assets/photos/ep1/pj_billet_avion_cdg.webp',
    comments: [
      _Comment(
        author: 'camille_rx',
        emoji: '🥐',
        avatarColor: 0xFFFCE6D8,
        text: 'mes pensées partent avec vous ❤️',
        when: 'il y a 6h',
      ),
    ],
  ),
  _Post(
    id: 'auntmei_j86',
    author: 'auntmei_fj',
    emoji: '🌾',
    when: 'aujourd\'hui',
    body: 'Hélène est revenue. 28 ans qu\'elle n\'avait pas posé les pieds ici.',
    gradient: [0xFF8AA070, 0xFF40583A],
    likes: 642,
    atDay: 86,
    imagePath: 'assets/photos/ep1/post_oncle_fujian.webp',
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: 'Elle a pleuré dans la voiture.',
        when: 'il y a 4h',
      ),
    ],
  ),
  _Post(
    id: 'helene_j88_parc',
    author: 'helene_paris',
    emoji: '🍃',
    when: 'hier',
    body: 'Le parc où ton père m\'a dit qu\'il partait. L\'écho n\'a pas bougé.',
    gradient: [0xFFC4D2A8, 0xFF8AA070],
    likes: 1240,
    atDay: 88,
    comments: [
      _Comment(
        author: 'shen_marchand',
        emoji: '🌿',
        avatarColor: 0xFFFCE6D8,
        text: '...',
        when: 'il y a 1j',
      ),
    ],
  ),
  _Post(
    id: 't_heng_j95',
    author: 't_heng',
    emoji: '📱',
    when: 'aujourd\'hui',
    body: 'Tu reviens ?',
    gradient: [0xFF1F2937, 0xFF111827],
    likes: 0,
    atDay: 95,
    comments: [],
  ),
  _Post(
    id: 'camille_j105',
    author: 'camille_rx',
    emoji: '🌧️',
    when: 'hier',
    body: 'Trois mois. Et je ne sais toujours pas où est ta place.',
    gradient: [0xFFFCE6D8, 0xFFCFC8B5],
    likes: 142,
    atDay: 105,
    comments: [],
  ),
  _Post(
    id: 'helene_j110',
    author: 'helene_paris',
    emoji: '🌅',
    when: 'aujourd\'hui',
    body: 'Demain elle décide. Je n\'ai plus mon mot à dire — pour la première fois.',
    gradient: [0xFFE7D9C2, 0xFFFCC9A1],
    likes: 218,
    atDay: 110,
    imagePath: 'assets/photos/ep1/j11_maman_fenetre_paris.webp',
    comments: [],
  ),
];

// ─── Models ─────────────────────────────────────────────────────

class _Story {
  final String id;
  final String name;
  final String emoji;
  final bool isMe;
  final int fromDay;
  final List<_StoryFrame> frames;
  final int viewerCount;
  final bool rare;
  final bool isLive;

  const _Story({
    required this.id,
    required this.name,
    required this.emoji,
    required this.fromDay,
    required this.frames,
    this.isMe = false,
    this.viewerCount = 0,
    this.rare = false,
    this.isLive = false,
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
  final String? imagePath;
  final String? hashtag;
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
    this.hashtag,
  });
}

class _Comment {
  final String author;
  final String emoji;
  final int avatarColor;
  final String text;
  final String when;
  final bool mamanAutoLike; // Idée 6 — Maman like Camille systématiquement
  const _Comment({
    required this.author,
    required this.emoji,
    required this.avatarColor,
    required this.text,
    required this.when,
    this.mamanAutoLike = false,
  });
}

// ─── Story view (ring rotate + viewer count + rare/live badges) ──

class _StoryView extends StatefulWidget {
  const _StoryView({
    required this.story,
    required this.viewed,
    required this.isDark,
    required this.onTap,
  });
  final _Story story;
  final bool viewed;
  final bool isDark;
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
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
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
                              : widget.story.isLive
                                  ? const LinearGradient(colors: [
                                      Color(0xFFFD297B),
                                      Color(0xFFFD297B),
                                    ])
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isDark ? Colors.black : Colors.white,
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
                if (widget.story.isLive)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFD297B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'EN DIRECT',
                      style: GoogleFonts.inter(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.story.name,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: widget.isDark ? Colors.white70 : const Color(0xFF1A1A1A),
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

// ─── Stories viewer plein écran + viewer count ──────────────────

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
              child: Text(frame.emoji,
                  style: const TextStyle(fontSize: 180)),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 130,
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
            // Idée 1 — Viewer count en bas « vu par 1 274 dont vous »
            if (_story.viewerCount > 0)
              Positioned(
                bottom: 80,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Vu par ${_story.viewerCount}${_story.rare ? " — dont vous" : ""}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            // Idée 4 — Input réponse rapide
            Positioned(
              bottom: 28,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30),
                      width: 0.5),
                ),
                child: Row(
                  children: [
                    Text(
                      'Envoyer un message...',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.send_outlined,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18),
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 2),
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
                                        borderRadius:
                                            BorderRadius.circular(2),
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
                          icon: const Icon(Icons.close,
                              color: Colors.white),
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

// ─── PostCard avec halo doré pour les posts à tag retirable ─────

class _PostCard extends StatefulWidget {
  const _PostCard({
    required this.post,
    required this.liked,
    required this.isDark,
    required this.hasTag,
    required this.suspicionMaman,
    required this.onLike,
    required this.onHide,
    required this.onComments,
    required this.onRetireTag,
    required this.onHashtag,
  });
  final _Post post;
  final bool liked;
  final bool isDark;
  final bool hasTag;
  final int suspicionMaman;
  final VoidCallback onLike;
  final VoidCallback onHide;
  final VoidCallback onComments;
  final VoidCallback onRetireTag;
  final void Function(String) onHashtag;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  // Idée 20 — Loading shimmer pour l'image
  late final AnimationController _shimmerCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void dispose() {
    _heartCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _doubleTap() {
    if (!widget.liked) widget.onLike();
    _heartCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    final fg = widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
    final muted =
        widget.isDark ? Colors.white70 : Colors.grey.shade700;
    // Idée 12 — Si Tante Mei a unfollow (suspicion ≥ 30) → bandeau
    // sur les posts auntmei_fj
    final auntMeiUnfollowed = widget.suspicionMaman >= 30;
    // Idée 13 — Like Tristan sur le post heng_lihua_j13 (rumeur)
    final tristanLikeSubtle = p.id == 'heng_lihua_j13';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget.hasTag
                      ? const LinearGradient(colors: [
                          Color(0xFFD4AF37),
                          Color(0xFFFFD700),
                        ])
                      : null,
                  color: widget.hasTag ? null : Color(p.gradient.first),
                ),
                padding: widget.hasTag ? const EdgeInsets.all(2) : null,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(p.gradient.first),
                  ),
                  alignment: Alignment.center,
                  child: Text(p.emoji,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                p.author,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (widget.hasTag) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Vous identifie',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB8860B),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => _showPostMenu(context),
                child: Icon(Icons.more_horiz, color: muted, size: 20),
              ),
            ],
          ),
        ),
        // Image avec shimmer
        GestureDetector(
          onDoubleTap: _doubleTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: p.imagePath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedBuilder(
                            animation: _shimmerCtrl,
                            builder: (_, __) {
                              if (_shimmerCtrl.value >= 1) {
                                return Image.asset(p.imagePath!,
                                    fit: BoxFit.cover);
                              }
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(p.imagePath!,
                                      fit: BoxFit.cover),
                                  Opacity(
                                    opacity: 1 - _shimmerCtrl.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin:
                                              Alignment(-1 + _shimmerCtrl.value * 2, 0),
                                          end: Alignment(_shimmerCtrl.value * 2, 0),
                                          colors: [
                                            Colors.grey.shade300,
                                            Colors.grey.shade200,
                                            Colors.grey.shade300,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      )
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
                        child: Text(p.emoji,
                            style: const TextStyle(fontSize: 96)),
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
                          child: const Icon(Icons.favorite,
                              color: Colors.white, size: 110),
                        ),
                      ),
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
                  color: widget.liked ? const Color(0xFFE53935) : fg,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: widget.onComments,
                child:
                    Icon(Icons.chat_bubble_outline, size: 24, color: fg),
              ),
              const SizedBox(width: 14),
              Icon(Icons.send_outlined, size: 24, color: fg),
              const Spacer(),
              Icon(Icons.bookmark_border, size: 24, color: fg),
            ],
          ),
        ),
        // Likes count + Maman auto-like + Tristan subtle
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${p.likes + (widget.liked ? 1 : 0)} j\'aime',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              if (p.comments.any((c) => c.mamanAutoLike))
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'helene_paris a aimé',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (tristanLikeSubtle)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    't_heng et 312 autres ont aimé',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: muted,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
          child: RichText(
            text: TextSpan(
              style:
                  GoogleFonts.inter(fontSize: 13, color: fg),
              children: [
                TextSpan(
                  text: '${p.author} ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: p.body),
                if (p.hashtag != null)
                  TextSpan(
                    text: ' #${p.hashtag}',
                    style: const TextStyle(color: Color(0xFF007AFF)),
                    recognizer: null, // hashtag tap via onTap dans la image area
                  ),
              ],
            ),
          ),
        ),
        if (p.hashtag != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: GestureDetector(
              onTap: () => widget.onHashtag(p.hashtag!),
              child: Text(
                '#${p.hashtag}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF007AFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (widget.hasTag) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.onRetireTag();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 1800),
                  backgroundColor: const Color(0xFFB8860B),
                  content: Text(
                    'Tag retiré. Madame Heng -3 confiance.',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.white),
                  ),
                ));
              },
              child: Text(
                'Retirer le tag',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFB8860B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
        if (p.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: GestureDetector(
              onTap: widget.onComments,
              child: Text(
                'Voir les ${p.comments.length} commentaire${p.comments.length > 1 ? "s" : ""}',
                style: GoogleFonts.inter(fontSize: 13, color: muted),
              ),
            ),
          ),
        if (auntMeiUnfollowed && p.author == 'heng_lihua')
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Text(
              'auntmei_fj ne suit plus heng_lihua',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: muted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Text(
            p.when,
            style: GoogleFonts.inter(fontSize: 11, color: muted),
          ),
        ),
        Container(
          height: 4,
          color:
              widget.isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
        ),
      ],
    );
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.person_remove, color: Color(0xFFE53935)),
              title: Text(
                'Ne plus suivre ${widget.post.author}',
                style: GoogleFonts.inter(
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                ),
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

class _HeartParticle extends StatelessWidget {
  const _HeartParticle({required this.progress, required this.angleIndex});
  final double progress;
  final int angleIndex;

  @override
  Widget build(BuildContext context) {
    final angle = (-90 + angleIndex * 60) * 3.14159 / 180;
    final dist = 80 * progress;
    final dx = dist * cos(angle);
    final dy = dist * sin(angle) - (40 * progress * progress);
    final scale = 0.4 + 0.4 * (1 - progress);
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Opacity(
        opacity: (1 - progress).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scale,
          child: const Icon(Icons.favorite,
              color: Color(0xFFFF3B5C), size: 24),
        ),
      ),
    );
  }
}

// ─── Comments sheet ─────────────────────────────────────────────

class _CommentsSheet extends StatelessWidget {
  const _CommentsSheet({required this.post, required this.isDark});
  final _Post post;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    return DraggableScrollableSheet(
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
          Text('Commentaires',
              style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w700, color: fg)),
          const SizedBox(height: 4),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 10),
                for (final c in post.comments)
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
                                      fontSize: 13, color: fg),
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
                              Text(c.when,
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        Icon(
                          c.mamanAutoLike
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 14,
                          color: c.mamanAutoLike
                              ? const Color(0xFFE53935)
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                if (post.comments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text('Aucun commentaire.',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.grey.shade600)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// TAB 1 — REELS (idée 9)
// ════════════════════════════════════════════════════════════════

class _ReelsTab extends StatelessWidget {
  const _ReelsTab({
    required this.day,
    required this.isDark,
    required this.viewedReels,
    required this.onView,
  });
  final int day;
  final bool isDark;
  final Set<String> viewedReels;
  final void Function(String) onView;

  @override
  Widget build(BuildContext context) {
    final reels = _kReels.where((r) => r.atDay <= day).toList();
    if (reels.isEmpty) {
      return Center(
        child: Text(
          'Aucun reel à voir pour l\'instant.',
          style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.grey.shade600),
        ),
      );
    }
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reels.length,
      onPageChanged: (i) => onView(reels[i].id),
      itemBuilder: (context, i) => _ReelPage(reel: reels[i]),
    );
  }
}

class _Reel {
  final String id;
  final String author;
  final String emoji;
  final String body;
  final List<int> gradient;
  final int atDay;
  final int likes;
  const _Reel({
    required this.id,
    required this.author,
    required this.emoji,
    required this.body,
    required this.gradient,
    required this.atDay,
    required this.likes,
  });
}

const _kReels = <_Reel>[
  _Reel(
    id: 'camille_mandarin',
    author: 'camille_rx',
    emoji: '🥐',
    body: '10 trucs que je sais pas dire en mandarin\nmais que je vais devoir',
    gradient: [0xFFFCE6D8, 0xFFFAE0CC],
    atDay: 6,
    likes: 1248,
  ),
  _Reel(
    id: 'hanami_time_lapse',
    author: 'hanami_paris',
    emoji: '☕',
    body: 'Long Jing infuse en 4 minutes\ntime-lapse satisfaisant',
    gradient: [0xFF8B6F47, 0xFFD4A574],
    atDay: 7,
    likes: 8742,
  ),
  _Reel(
    id: 't_heng_silence',
    author: 't_heng',
    emoji: '🌃',
    body: '47e étage, 23h.\nLa ville parle moins fort qu\'on ne croit.',
    gradient: [0xFF1F2937, 0xFF374151],
    atDay: 10,
    likes: 4128,
  ),
  _Reel(
    id: 'heng_lihua_main',
    author: 'heng_lihua',
    emoji: '🍵',
    body: 'Comment tenir le gaiwan.\nLes deux mains. Sans toucher le bord.',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    atDay: 13,
    likes: 9842,
  ),
  _Reel(
    id: 'mei_rizieres',
    author: 'mei_fujian',
    emoji: '🌿',
    body: 'Rizières au lever du soleil.\n\'我等你回家\' (je t\'attends à la maison)',
    gradient: [0xFF66BB6A, 0xFF2E7D32],
    atDay: 8,
    likes: 312,
  ),
];

class _ReelPage extends StatelessWidget {
  const _ReelPage({required this.reel});
  final _Reel reel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: reel.gradient.map((h) => Color(h)).toList(),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(reel.emoji, style: const TextStyle(fontSize: 180)),
          ),
          Positioned(
            left: 16,
            right: 80,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reel.author,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reel.body,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 80,
            child: Column(
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 32),
                const SizedBox(height: 4),
                Text(
                  _fmtCount(reel.likes),
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Icon(Icons.chat_bubble_outline,
                    color: Colors.white, size: 32),
                const SizedBox(height: 16),
                const Icon(Icons.send_outlined,
                    color: Colors.white, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

// ════════════════════════════════════════════════════════════════
// TAB 2 — SUGGESTIONS (idée 7)
// ════════════════════════════════════════════════════════════════

class _SuggestionsTab extends StatelessWidget {
  const _SuggestionsTab({required this.day, required this.isDark});
  final int day;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Suggéré pour toi',
            style: GoogleFonts.inter(
                fontSize: 20, fontWeight: FontWeight.w800, color: fg)),
        const SizedBox(height: 14),
        for (final s in _kSuggestions.where((s) => s.fromDay <= day))
          _SuggestionRow(suggestion: s, isDark: isDark),
        const SizedBox(height: 20),
        Text('Tendances · Paris',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: fg.withValues(alpha: 0.7),
                letterSpacing: 0.4)),
        const SizedBox(height: 10),
        _TrendChip(label: '#FemmesHengParis', count: '12,4k posts', isDark: isDark),
        _TrendChip(label: '#LongJing2026', count: '8 312 posts', isDark: isDark),
        _TrendChip(label: '#AvenueFochLife', count: '4 821 posts', isDark: isDark),
        _TrendChip(label: '#FujianBack', count: '947 posts', isDark: isDark),
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion, required this.isDark});
  final _Suggestion suggestion;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Color(suggestion.color),
            child: Text(suggestion.emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestion.handle,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w700, color: fg)),
                Text(suggestion.reason,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('Suivre',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Suggestion {
  final String handle;
  final String emoji;
  final int color;
  final String reason;
  final int fromDay;
  const _Suggestion({
    required this.handle,
    required this.emoji,
    required this.color,
    required this.reason,
    required this.fromDay,
  });
}

const _kSuggestions = <_Suggestion>[
  _Suggestion(
    handle: 'auntmei_fj',
    emoji: '🌿',
    color: 0xFFD4A574,
    reason: 'Suivie par mei_fujian',
    fromDay: 1,
  ),
  _Suggestion(
    handle: 't_heng',
    emoji: '🧊',
    color: 0xFFD7DEE5,
    reason: 'Dans votre zone · 0 km',
    fromDay: 6,
  ),
  _Suggestion(
    handle: 'heng_lihua',
    emoji: '🍵',
    color: 0xFFE7E1D2,
    reason: 'Suivie par t_heng et vincent_h',
    fromDay: 8,
  ),
  _Suggestion(
    handle: 'shen_marchand_archi',
    emoji: '✏️',
    color: 0xFFFAE0CC,
    reason: 'Votre ancien compte · 4 abonnés',
    fromDay: 1,
  ),
  _Suggestion(
    handle: 'parisluxuryinteriors',
    emoji: '🏛️',
    color: 0xFFCFC8B5,
    reason: 'Aimée par 12 personnes que vous suivez',
    fromDay: 8,
  ),
];

class _TrendChip extends StatelessWidget {
  const _TrendChip(
      {required this.label, required this.count, required this.isDark});
  final String label;
  final String count;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
          const Spacer(),
          Text(count,
              style: GoogleFonts.inter(
                  fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// TAB 3 — ACTIVITY (idées 11, 12, 17)
// ════════════════════════════════════════════════════════════════

class _ActivityTab extends StatelessWidget {
  const _ActivityTab(
      {required this.day, required this.isDark, required this.suspicion});
  final int day;
  final bool isDark;
  final int suspicion;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    // Idée 11 — followers dynamiques : 308 au J1, +2/jour
    final followers = 308 + (day * 2);
    final activities = <_ActivityItem>[
      // Aujourd'hui
      const _ActivityItem(
        avatar: '🥐',
        avatarColor: 0xFFFCE6D8,
        text:
            '**camille_rx** a aimé votre photo et 3 autres publications.',
        when: '12 min',
        section: 'Aujourd\'hui',
      ),
      _ActivityItem(
        avatar: '👩',
        avatarColor: 0xFFFCE6D8,
        text:
            '**helene_paris** a aimé 8 publications de @camille_rx cette semaine.',
        when: '2 h',
        section: 'Aujourd\'hui',
      ),
      // Idée 12 — Mei unfollow si suspicion ≥ 30
      if (suspicion >= 30)
        const _ActivityItem(
          avatar: '🌿',
          avatarColor: 0xFFD4A574,
          text:
              '**auntmei_fj** ne suit plus votre compte.',
          when: '4 h',
          section: 'Cette semaine',
          alert: true,
        ),
      // Idée 13 — Tristan like archived story
      const _ActivityItem(
        avatar: '🧊',
        avatarColor: 0xFFD7DEE5,
        text:
            '**t_heng** a aimé votre story « Carte recollée » avant que vous la supprimiez.',
        when: '5 j',
        section: 'Cette semaine',
        alert: true,
      ),
      const _ActivityItem(
        avatar: '💼',
        avatarColor: 0xFFE89B7F,
        text:
            '**vincent_h** a commencé à vous suivre.',
        when: '6 j',
        section: 'Cette semaine',
      ),
      const _ActivityItem(
        avatar: '🍵',
        avatarColor: 0xFFE7E1D2,
        text:
            '**heng_lihua** vous a identifiée dans une publication.',
        when: '1 sem.',
        section: 'Plus ancien',
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE1306C), Color(0xFFFD297B)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.people_outline, color: Colors.white.withValues(alpha: 0.95), size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$followers abonnés',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  Text('+2 cette semaine',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (final section in {'Aujourd\'hui', 'Cette semaine', 'Plus ancien'})
          ...[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Text(section.toUpperCase(),
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                      letterSpacing: 1)),
            ),
            for (final a in activities.where((x) => x.section == section))
              _ActivityRow(item: a, fg: fg),
          ],
      ],
    );
  }
}

class _ActivityItem {
  final String avatar;
  final int avatarColor;
  final String text;
  final String when;
  final String section;
  final bool alert;
  const _ActivityItem({
    required this.avatar,
    required this.avatarColor,
    required this.text,
    required this.when,
    required this.section,
    this.alert = false,
  });
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item, required this.fg});
  final _ActivityItem item;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final parts = item.text.split('**');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                Color(item.avatarColor).withValues(alpha: 0.45),
            child: Text(item.avatar, style: const TextStyle(fontSize: 16)),
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
                        color: item.alert
                            ? const Color(0xFFE53935)
                            : fg,
                        height: 1.4),
                    children: List.generate(parts.length, (i) {
                      return TextSpan(
                        text: parts[i],
                        style: i.isOdd
                            ? const TextStyle(fontWeight: FontWeight.w700)
                            : null,
                      );
                    }),
                  ),
                ),
                Text(item.when,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// TAB 4 — PROFILE (idées 3, 15, 16)
// ════════════════════════════════════════════════════════════════

class _ProfileTab extends StatelessWidget {
  const _ProfileTab(
      {required this.day, required this.isDark, required this.posts});
  final int day;
  final bool isDark;
  final int posts;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final followers = 308 + (day * 2);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage('assets/photos/avatars/shen.webp'),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ProfileStat(value: '$posts', label: 'Publications', fg: fg),
                  _ProfileStat(
                      value: '$followers', label: 'Abonnés', fg: fg),
                  _ProfileStat(value: '124', label: 'Abonnements', fg: fg),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Shen Marchand',
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w700, color: fg)),
        Text('Étudiante archi · Livreuse vélo · Belleville',
            style: GoogleFonts.inter(fontSize: 12, color: fg.withValues(alpha: 0.7))),
        const SizedBox(height: 20),
        // Sections highlights : Brouillons + Archivées
        Row(
          children: [
            _HighlightCircle(
              label: 'Brouillons',
              emoji: '✎',
              color: const Color(0xFF8B8480),
              onTap: () => _showDrafts(context, isDark),
            ),
            const SizedBox(width: 18),
            _HighlightCircle(
              label: 'Archivées',
              emoji: '🗄️',
              color: const Color(0xFFCFC8B5),
              onTap: () => _showArchived(context, isDark),
            ),
            const SizedBox(width: 18),
            _HighlightCircle(
              label: 'Maman ❤',
              emoji: '💌',
              color: const Color(0xFFFCE6D8),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Divider(),
        const SizedBox(height: 10),
        Text(
          'Tu peux publier depuis l\'app Caméra > Partager.',
          style: GoogleFonts.inter(
              fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  void _showDrafts(BuildContext context, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? Colors.black : Colors.white,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Brouillons',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 14),
              _DraftItem(
                  caption:
                      'Vendredi 3 juin. Je crois que tout commence.',
                  when: 'Brouillon · J1'),
              _DraftItem(
                  caption: 'Quatorze pages. Mon stylo a tremblé.',
                  when: 'Brouillon · J8'),
              const SizedBox(height: 14),
              Text(
                'Tu commences à écrire et tu n\'envoies pas.\nC\'est ton droit.',
                style: GoogleFonts.crimsonPro(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArchived(BuildContext context, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? Colors.black : Colors.white,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stories archivées',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 56,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE8E0D0), Color(0xFFF5EFE2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('📇', style: TextStyle(fontSize: 24)),
                ),
                title: Text('Carte recollée',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black)),
                subtitle: Text('J1 23h47 · postée 30 min puis supprimée',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey.shade600)),
                trailing: Text('👁 1',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: const Color(0xFFE53935))),
              ),
              const SizedBox(height: 8),
              Text(
                't_heng a vu cette story.',
                style: GoogleFonts.crimsonPro(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFFE53935)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label, required this.fg});
  final String value;
  final String label;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w800, color: fg)),
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: fg.withValues(alpha: 0.7))),
      ],
    );
  }
}

class _HighlightCircle extends StatelessWidget {
  const _HighlightCircle(
      {required this.label,
      required this.emoji,
      required this.color,
      required this.onTap});
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.30),
              border: Border.all(color: color, width: 1),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11)),
        ],
      ),
    );
  }
}

class _DraftItem extends StatelessWidget {
  const _DraftItem({required this.caption, required this.when});
  final String caption;
  final String when;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.edit_note, color: Color(0xFF8B8480), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(caption,
                    style: GoogleFonts.crimsonPro(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF8B8480),
                        decoration: TextDecoration.lineThrough)),
                Text(when,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── DM sheet (idée 10) ─────────────────────────────────────────

class _DMSheet extends StatelessWidget {
  const _DMSheet({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollCtrl,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Messages',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black)),
            ),
            const SizedBox(height: 14),
            _DMRow(
              avatar: '🥐',
              avatarColor: 0xFFFCE6D8,
              name: 'camille_rx',
              preview: 'Vu il y a 4 min',
              isDark: isDark,
            ),
            _DMRow(
              avatar: '💼',
              avatarColor: 0xFFE89B7F,
              name: 'vincent_h',
              preview: 'Welcome to the family.',
              isDark: isDark,
              unread: true,
            ),
            _DMRow(
              avatar: '🎧',
              avatarColor: 0xFF1F2937,
              name: 'antoine_blkbrd',
              preview: 'On boit un verre ce week-end ?',
              isDark: isDark,
              unread: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DMRow extends StatelessWidget {
  const _DMRow({
    required this.avatar,
    required this.avatarColor,
    required this.name,
    required this.preview,
    required this.isDark,
    this.unread = false,
  });
  final String avatar;
  final int avatarColor;
  final String name;
  final String preview;
  final bool isDark;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(avatarColor).withValues(alpha: 0.4),
            child: Text(avatar, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight:
                            unread ? FontWeight.w800 : FontWeight.w600,
                        color: fg)),
                Text(preview,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: unread ? fg : Colors.grey.shade600)),
              ],
            ),
          ),
          if (unread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFD297B),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Hashtag view (idée 14) ─────────────────────────────────────

class _HashtagView extends StatelessWidget {
  const _HashtagView({required this.hashtag, required this.isDark});
  final String hashtag;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? Colors.white : const Color(0xFF1A1A1A);
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Column(
        children: [
          PhoneStatusBar(foreground: fg),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: fg, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text('#$hashtag',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: fg)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '12 412 publications',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Suivre',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, i) {
                final colors = [
                  [0xFFE7E1D2, 0xFFCFC8B5],
                  [0xFFFCE6D8, 0xFFFAE0CC],
                  [0xFFD7DEE5, 0xFFB3BFC9],
                  [0xFFE89B7F, 0xFFFCC9A1],
                  [0xFFCFC8B5, 0xFFE7D9C2],
                  [0xFFD4A574, 0xFF8B6F47],
                ];
                final c = colors[i % colors.length];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(c[0]), Color(c[1])],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🍵',
                      style: TextStyle(fontSize: 28)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
