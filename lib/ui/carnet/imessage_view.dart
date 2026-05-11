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

class _BubbleThread extends StatefulWidget {
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
  State<_BubbleThread> createState() => _BubbleThreadState();
}

class _BubbleThreadState extends State<_BubbleThread> {
  int _visible = 0;
  bool _typingNext = false;
  bool _disposed = false;

  static const _typingDelay = Duration(milliseconds: 480);
  static const _bubbleDelay = Duration(milliseconds: 720);

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _scheduleNext() async {
    if (_visible >= widget.messages.length) return;
    final next = widget.messages[_visible];
    // Pas de "tape..." pour les bulles "Moi" — c'est l'utilisateur qui
    // les "envoie", pas la peine de simuler son propre tapotage.
    if (!next.isMe && next.imageAsset == null) {
      await Future.delayed(_typingDelay);
      if (_disposed) return;
      setState(() => _typingNext = true);
      await Future.delayed(_bubbleDelay);
    } else {
      await Future.delayed(const Duration(milliseconds: 280));
    }
    if (_disposed) return;
    setState(() {
      _typingNext = false;
      _visible++;
    });
    _scheduleNext();
  }

  @override
  Widget build(BuildContext context) {
    final shown = widget.messages.take(_visible).toList(growable: false);
    final children = <Widget>[];
    for (var i = 0; i < shown.length; i++) {
      children.add(_bubble(context, i, shown));
    }
    if (_typingNext && _visible < widget.messages.length) {
      final m = widget.messages[_visible];
      children.add(_TypingIndicator(
        bubbleColor: widget.otherBubble,
        senderName: widget.showSenderLabels ? m.sender : null,
        senderAvatar:
            widget.showSenderLabels ? _avatarForSender(m.sender) : null,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _bubble(BuildContext context, int i, List<SmsMessage> messages) {
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
        decoration: BoxDecoration(
            color: me ? widget.meBubble : widget.otherBubble,
            borderRadius: radius),
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
        widget.showSenderLabels && !me && !continuesAbove;
    final senderAvatar = showLabel ? _avatarForSender(m.sender) : null;

    return _BubbleAppear(
      key: ValueKey('bubble-$i-${m.sender}-${m.content.hashCode}'),
      isMe: me,
      child: Padding(
      padding: EdgeInsets.only(top: continuesAbove ? 2 : 8),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (senderAvatar != null) ...[
                    senderAvatar,
                    const SizedBox(width: 5),
                  ],
                  Text(
                    m.sender,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
      ),
    );
  }

  /// Mini avatar 18 dp en haut de bulle pour les conversations inline.
  /// Mappe un nom d'émetteur en clair vers le portrait perso si on en
  /// a un, sinon un emoji discret pour les inconnus / institutions.
  Widget? _avatarForSender(String sender) {
    String? photo;
    String? fallbackEmoji;
    final s = sender.toLowerCase();
    if (s == 'tristan' || s == 'lui') {
      photo = 'assets/photos/characters/t_heng.png';
    } else if (s == 'maman') {
      photo = 'assets/photos/characters/helene_marchand.png';
    } else if (s == 'camille') {
      photo = 'assets/photos/characters/camille_rx.png';
    } else if (s == 'vincent') {
      photo = 'assets/photos/characters/vincent_h.png';
    } else if (s == 'madame heng') {
      photo = 'assets/photos/characters/heng_lihua.png';
    } else if (s == 'tante mei') {
      photo = 'assets/photos/characters/mei_fujian.png';
    } else if (s == 'numéro inconnu') {
      fallbackEmoji = '☎️';
    } else if (s == 'banque') {
      fallbackEmoji = '🏦';
    } else if (s == 'le dr aubin' || s == 'dr aubin') {
      fallbackEmoji = '🩺';
    } else {
      return null;
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFEFE9D8),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: photo != null
          ? Image.asset(
              photo,
              fit: BoxFit.cover,
              cacheWidth: 96,
              errorBuilder: (_, __, ___) => Text(
                fallbackEmoji ?? '?',
                style: const TextStyle(fontSize: 10),
              ),
            )
          : Text(
              fallbackEmoji ?? '?',
              style: const TextStyle(fontSize: 10),
            ),
    );
  }
}

/// Animation d'apparition d'une bulle iMessage : pop léger + fade,
/// avec un point de pivot dans le coin "départ" de la bulle (en bas
/// à droite pour Moi, en bas à gauche pour l'autre).
class _BubbleAppear extends StatefulWidget {
  const _BubbleAppear({
    super.key,
    required this.child,
    required this.isMe,
  });

  final Widget child;
  final bool isMe;

  @override
  State<_BubbleAppear> createState() => _BubbleAppearState();
}

class _BubbleAppearState extends State<_BubbleAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        alignment:
            widget.isMe ? Alignment.bottomRight : Alignment.bottomLeft,
        child: widget.child,
      ),
    );
  }
}

/// Indicateur "tape…" : trois points qui rebondissent dans une bulle
/// grise, comme dans iMessage. Affiché brièvement avant chaque bulle
/// non-Moi pour donner l'impression que l'autre est en train d'écrire.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({
    required this.bubbleColor,
    this.senderName,
    this.senderAvatar,
  });

  final Color bubbleColor;
  final String? senderName;
  final Widget? senderAvatar;

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.senderAvatar != null) ...[
                    widget.senderAvatar!,
                    const SizedBox(width: 5),
                  ],
                  Text(
                    widget.senderName!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: widget.bubbleColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        if (i > 0) const SizedBox(width: 4),
                        _Dot(phase: (_ctrl.value + i * 0.18) % 1.0),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.phase});
  final double phase;

  @override
  Widget build(BuildContext context) {
    // Pulse vertical : opacité+translation au rythme phase ∈ [0..1].
    final t = (phase < 0.5 ? phase * 2 : (1 - phase) * 2);
    final dy = -2.0 * t;
    final opacity = 0.35 + 0.55 * t;
    return Transform.translate(
      offset: Offset(0, dy),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
