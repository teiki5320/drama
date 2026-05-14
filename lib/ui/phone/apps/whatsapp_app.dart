import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// WhatsApp — 2 groupes : famille Fujian (mandarin), école d'archi.
/// Placeholder pour PR 5, contenu enrichi quand les voyages Fujian
/// arrivent dans le scénario (J85+).
class WhatsAppApp extends ConsumerWidget {
  const WhatsAppApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = [
      _Group(
        name: '家族福建 · Famille Fujian',
        lastMessage: '阿姨梅 : 妈妈好吗？',
        lastTime: 'Hier',
        unread: 2,
        emoji: '🌿',
      ),
      _Group(
        name: 'Promo Archi 2022',
        lastMessage: 'Léo : Quelqu\'un a le doc de M. Aubert ?',
        lastTime: '11:42',
        unread: 0,
        emoji: '📐',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
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
              itemBuilder: (context, i) => _GroupTile(group: groups[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Group {
  final String name;
  final String lastMessage;
  final String lastTime;
  final int unread;
  final String emoji;
  const _Group({
    required this.name,
    required this.lastMessage,
    required this.lastTime,
    required this.unread,
    required this.emoji,
  });
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group});
  final _Group group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFEFEFEF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(group.emoji, style: const TextStyle(fontSize: 22)),
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
                      group.lastTime,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: group.unread > 0
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
                        group.lastMessage,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (group.unread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${group.unread}',
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
    );
  }
}
