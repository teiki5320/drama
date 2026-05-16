import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// WhatsApp — refuge familial. Tante Mei en mandarin (voix lettrée),
/// Camille en groupe privé avec Shen (off-record). L'app où la famille
/// distante et l'amie proche se croisent.
class WhatsAppApp extends ConsumerWidget {
  const WhatsAppApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final groups =
        _allGroups.where((g) => g.fromDay <= day).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          // Header WhatsApp vert
          Container(
            color: const Color(0xFF128C7E),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      ref.read(phoneStateProvider.notifier).closeApp();
                    },
                  ),
                  Text(
                    'WhatsApp',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 12),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: groups.length,
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Container(height: 0.5, color: Colors.grey.shade300),
              ),
              itemBuilder: (context, i) => _GroupTile(
                group: groups[i],
                day: day,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WAGroup {
  final String id;
  final String name;
  final String emoji;
  final int fromDay;
  final List<_WAMsg> messages;
  /// Avatar de groupe (ou principal participant). Fallback emoji si null.
  final String? avatarPath;
  const _WAGroup({
    required this.id,
    required this.name,
    required this.emoji,
    required this.fromDay,
    required this.messages,
    this.avatarPath,
  });
}

class _WAMsg {
  final String sender; // 'moi' ou nom affiché
  final String text;
  final String time;
  final int day;
  const _WAMsg({
    required this.sender,
    required this.text,
    required this.time,
    required this.day,
  });
}

const _allGroups = <_WAGroup>[
  _WAGroup(
    id: 'fujian',
    name: '家族福建 · Famille Fujian',
    emoji: '🌿',
    fromDay: 1,
    avatarPath: 'assets/photos/avatars/tante_mei.webp',
    messages: [
      _WAMsg(
        sender: '阿姨梅',
        text: '小诗。你妈妈怎么样？',
        time: '21:14',
        day: 3,
      ),
      _WAMsg(
        sender: 'moi',
        text: 'Elle va. Un peu fatiguée. Elle te salue.',
        time: '21:17',
        day: 3,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text:
            '别说「一点点」。「一点点」是大人的话。\n'
            '(Ne dis pas « un peu ». « Un peu », c\'est ce que disent les adultes.)',
        time: '21:18',
        day: 3,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '你什么时候来福建？',
        time: '21:18',
        day: 3,
      ),
      _WAMsg(
        sender: '伯伯文',
        text: '梅，让她吧。她忙。',
        time: '21:24',
        day: 3,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '🎙 vocal 38 s · « Petite, tu sais que ta mère ne mange plus la viande comme avant. Si tu veux je peux envoyer un colis de champignons séchés. »',
        time: '08:42',
        day: 5,
      ),
      _WAMsg(
        sender: 'moi',
        text: 'C\'est gentil. Pas la peine de payer le port, je trouverai à Belleville.',
        time: '12:14',
        day: 5,
      ),
      _WAMsg(
        sender: '表妹晖',
        text: '小诗姐姐，我考上了！',
        time: '09:18',
        day: 7,
      ),
      _WAMsg(
        sender: 'moi',
        text: 'Bravo Hui. Très fière de toi.',
        time: '14:22',
        day: 7,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '📷 Photo · le riz cette année est bon',
        time: '06:32',
        day: 8,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '🎙 vocal 1 min 24 s · « J\'ai rêvé de ta mère cette nuit. Elle marchait dans le parc, sans chaussures. Si tu as un moment, dis-lui de mettre quelque chose sur ses pieds. »',
        time: '07:48',
        day: 11,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '阿姨想你。',
        time: '07:50',
        day: 11,
      ),
      _WAMsg(
        sender: '伯伯文',
        text: '诗诗，你父亲的祭日下个月。',
        time: '18:32',
        day: 14,
      ),
      _WAMsg(
        sender: 'moi',
        text: '我知道，伯伯。',
        time: '19:08',
        day: 14,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '🎙 vocal 52 s · « Petite. J\'ai entendu quelque chose. Une jeune fille de Paris est venue chez nous, paraît-il. Elle s\'appelle comme ma sœur. C\'était toi ? »',
        time: '11:14',
        day: 35,
      ),
      _WAMsg(
        sender: 'moi',
        text: '...',
        time: '11:18',
        day: 35,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '小诗。ta mère a téléphoné hier soir.',
        time: '07:42',
        day: 39,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '🎙 vocal 18 s · « Je ne lui ai rien dit. Mais elle savait avant moi. »',
        time: '07:44',
        day: 39,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '📷 Photo · pivoines du jardin, mai 2026',
        time: '08:14',
        day: 60,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '🎙 vocal 1 min 12 s · « Petite. Ta mère va mieux. Le Dr Aubin a souri. Ramène-la chez nous quand vous serez prêtes. Le parc t\'attend. »',
        time: '21:32',
        day: 72,
      ),
      _WAMsg(
        sender: '表妹晖',
        text: '小诗姐姐，ma mère a préparé ta chambre.',
        time: '06:14',
        day: 78,
      ),
      _WAMsg(
        sender: '阿姨梅',
        text: '回家。',
        time: '06:15',
        day: 78,
      ),
    ],
  ),
  _WAGroup(
    id: 'camille_private',
    name: 'Camille (off-record)',
    emoji: '🥐',
    fromDay: 4,
    avatarPath: 'assets/photos/avatars/camille.webp',
    messages: [
      _WAMsg(
        sender: 'Camille',
        text:
            'Je sais que tu réponds plus à Maman sur iMessage parce qu\'elle fait des captures.\n'
            'Ici on est tranquilles. Disparition après 7 jours.',
        time: '14:12',
        day: 4,
      ),
      _WAMsg(
        sender: 'moi',
        text: 'Tu me prêtes 600 ?',
        time: '14:13',
        day: 4,
      ),
      _WAMsg(
        sender: 'Camille',
        text: 'Pas dit ça pour ça.\nMais oui.',
        time: '14:14',
        day: 4,
      ),
      _WAMsg(
        sender: 'Camille',
        text: 'Tu es OÙ là.',
        time: '23:42',
        day: 9,
      ),
      _WAMsg(
        sender: 'moi',
        text: 'Avenue Foch.',
        time: '23:44',
        day: 9,
      ),
      _WAMsg(
        sender: 'Camille',
        text:
            'Avenue Foch.\n'
            'Promets-moi que tu écris ce que tu vis.',
        time: '23:45',
        day: 9,
      ),
    ],
  ),
  _WAGroup(
    id: 'archi_2022',
    name: 'Promo Archi 2022',
    emoji: '📐',
    fromDay: 1,
    messages: [
      _WAMsg(
        sender: 'Léo',
        text: 'Quelqu\'un a le doc de M. Aubert ?',
        time: '11:42',
        day: 1,
      ),
      _WAMsg(
        sender: 'Marina',
        text: 'lol toujours toi qui demandes',
        time: '11:43',
        day: 1,
      ),
    ],
  ),
];

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group, required this.day});
  final _WAGroup group;
  final int day;

  @override
  Widget build(BuildContext context) {
    final visible =
        group.messages.where((m) => m.day <= day).toList();
    final last = visible.isNotEmpty ? visible.last : null;
    final unread = visible.where((m) => m.sender != 'moi').length > 0 &&
        last?.sender != 'moi'
        ? visible
            .where((m) => m.sender != 'moi' && m.day == day)
            .length
        : 0;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                _GroupThread(group: group, day: day),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: group.avatarPath == null
                    ? const Color(0xFFEFEFEF)
                    : null,
                shape: BoxShape.circle,
                image: group.avatarPath != null
                    ? DecorationImage(
                        image: AssetImage(group.avatarPath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: group.avatarPath != null
                  ? null
                  : Text(group.emoji, style: const TextStyle(fontSize: 22)),
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
                          group.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        last?.time ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: unread > 0
                              ? const Color(0xFF25D366)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          last == null
                              ? '—'
                              : (last.sender == 'moi'
                                  ? 'Vous : ${last.text.split('\n').first}'
                                  : '${last.sender} : ${last.text.split('\n').first}'),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unread',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
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
}

class _GroupThread extends StatelessWidget {
  const _GroupThread({required this.group, required this.day});
  final _WAGroup group;
  final int day;

  @override
  Widget build(BuildContext context) {
    final msgs = group.messages.where((m) => m.day <= day).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFE5DDD5),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          Container(
            color: const Color(0xFF128C7E),
            child: SafeArea(
              bottom: false,
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0x44FFFFFF),
                      backgroundImage: group.avatarPath != null
                          ? AssetImage(group.avatarPath!)
                          : null,
                      child: group.avatarPath != null
                          ? null
                          : Text(group.emoji,
                              style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        group.name,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: msgs.length,
              itemBuilder: (context, i) {
                final m = msgs[i];
                final isMe = m.sender == 'moi';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xFFDCF8C6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            m.sender,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE25C8B),
                            ),
                          ),
                        Text(
                          m.text,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF1A1A1A),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          m.time,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFFE5DDD5),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_emotions_outlined,
                      color: Color(0xFF8E8E93)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Message',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const Icon(Icons.mic, color: Color(0xFF8E8E93)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
