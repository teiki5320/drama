import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/character.dart';
import '../../models/sms_message.dart';

/// Renders a chat block in iOS Messages style: white card with a status
/// bar, contact header (avatar + name + call/video icons), and a bubble
/// thread (blue right for "Moi", gray left for the other side, photo
/// attachments rendered as image bubbles).
class IMessageView extends StatelessWidget {
  const IMessageView({
    super.key,
    required this.conversationId,
    required this.messages,
  });

  final String? conversationId;
  final List<SmsMessage> messages;

  static const _bgGray = Color(0xFFF2F2F7);
  static const _otherBubble = Color(0xFFE9E9EB);
  static const _meBubble = Color(0xFF007AFF);
  static const _accentTeal = Color(0xFF00B0BD);

  Character? get _contact {
    if (conversationId == null || conversationId == '_inline') return null;
    return characterById(conversationId!);
  }

  @override
  Widget build(BuildContext context) {
    final contact = _contact;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x141A1A1A)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            if (contact != null) ...[
              const _StatusBar(),
              _ContactHeader(contact: contact),
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Color(0x14000000),
              ),
            ],
            Container(
              color: _bgGray,
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
              width: double.infinity,
              child: _BubbleThread(
                messages: messages,
                otherBubble: _otherBubble,
                meBubble: _meBubble,
                showSenderLabels: contact == null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        children: [
          Text(
            '9:41',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          const Icon(Icons.signal_cellular_4_bar, size: 13),
          const SizedBox(width: 4),
          const Icon(Icons.wifi, size: 13),
          const SizedBox(width: 4),
          const Icon(Icons.battery_full, size: 14),
        ],
      ),
    );
  }
}

class _ContactHeader extends StatelessWidget {
  const _ContactHeader({required this.contact});
  final Character contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 10),
      child: Row(
        children: [
          const Icon(
            Icons.chevron_left,
            size: 28,
            color: IMessageView._meBubble,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                _Avatar(contact: contact, size: 36),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _shortDisplayName(contact),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (contact.id == 'maman') ...[
                      const SizedBox(width: 3),
                      const Text('❤️', style: TextStyle(fontSize: 11)),
                    ],
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.videocam_outlined,
            size: 22,
            color: IMessageView._accentTeal,
          ),
          const SizedBox(width: 14),
          const Icon(
            Icons.call_outlined,
            size: 20,
            color: IMessageView._accentTeal,
          ),
        ],
      ),
    );
  }

  static String _shortDisplayName(Character c) {
    // "Hélène Marchand" → "Maman" sounds odd; use the role for parents.
    if (c.id == 'maman') return 'Maman';
    return c.displayName.split(' ').first;
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.contact, required this.size});
  final Character contact;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Text(
      contact.emoji,
      style: TextStyle(fontSize: size * 0.55),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: contact.tint,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: contact.photoAsset == null
          ? fallback
          : Image.asset(
              contact.photoAsset!,
              fit: BoxFit.cover,
              cacheWidth: 192,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}

class _BubbleThread extends StatelessWidget {
  const _BubbleThread({
    required this.messages,
    required this.otherBubble,
    required this.meBubble,
    this.showSenderLabels = false,
  });

  final List<SmsMessage> messages;
  final Color otherBubble;
  final Color meBubble;

  /// Quand on est en mode `_inline` (pas de header contact en haut),
  /// afficher le nom de l'émetteur au-dessus de chaque bulle non-Moi
  /// dont l'auteur change. Sinon le joueur ne sait pas qui parle.
  final bool showSenderLabels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < messages.length; i++)
          _bubble(context, i),
      ],
    );
  }

  Widget _bubble(BuildContext context, int i) {
    final m = messages[i];
    final me = m.isMe;
    final prev = i > 0 ? messages[i - 1] : null;
    final next = i < messages.length - 1 ? messages[i + 1] : null;
    final continuesAbove = prev != null && prev.isMe == me;
    final continuesBelow = next != null && next.isMe == me;

    final radius = BorderRadius.only(
      topLeft: Radius.circular(continuesAbove && !me ? 6 : 18),
      topRight: Radius.circular(continuesAbove && me ? 6 : 18),
      bottomLeft: Radius.circular(continuesBelow && !me ? 6 : (me ? 18 : 4)),
      bottomRight: Radius.circular(continuesBelow && me ? 6 : (me ? 4 : 18)),
    );

    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.65;
    Widget child;
    if (m.imageAsset != null) {
      child = ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          m.imageAsset!,
          fit: BoxFit.cover,
          cacheWidth: 600,
          errorBuilder: (_, __, ___) => Container(
            width: 200,
            height: 140,
            color: const Color(0xFFE3D9C2),
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined,
                color: AppColors.textSecondary),
          ),
        ),
      );
    } else {
      child = Container(
        decoration: BoxDecoration(color: me ? meBubble : otherBubble, borderRadius: radius),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Text(
          m.content,
          style: TextStyle(
            color: me ? Colors.white : AppColors.textPrimary,
            fontSize: 15,
            height: 1.32,
          ),
        ),
      );
    }

    final showLabel =
        showSenderLabels && !me && !continuesAbove;

    return Padding(
      padding: EdgeInsets.only(top: continuesAbove ? 2 : 8),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Text(
                m.sender,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          Align(
            alignment: me ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
