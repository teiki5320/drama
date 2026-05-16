import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/messages_arc.dart';
import '../../../../providers/messages_arcs_provider.dart';
import '../../../../providers/phone_state_provider.dart';
import '../../status_bar.dart';

/// Vue conversation pour un arc Messages dynamique — bulles iMessage
/// classiques (bleu Shen / gris l'autre), panneau de choix 2-4 options
/// quand un beat de choix est en attente.
class ArcThreadView extends ConsumerStatefulWidget {
  const ArcThreadView({super.key, required this.instanceId});
  final String instanceId;

  @override
  ConsumerState<ArcThreadView> createState() => _ArcThreadViewState();
}

class _ArcThreadViewState extends ConsumerState<ArcThreadView> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(phoneStateProvider);
      ref.read(messagesArcsProvider.notifier).tickAll(
            day: p.currentDay,
            hour: p.hour,
            minute: p.minute,
          );
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messagesArcsProvider);
    final notifier = ref.read(messagesArcsProvider.notifier);
    final inst = state.instances
        .where((i) => i.id == widget.instanceId)
        .cast<MessagesArcInstance?>()
        .firstWhere((_) => true, orElse: () => null);
    if (inst == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
      return const Scaffold(backgroundColor: Colors.white);
    }
    final template = notifier.templateOf(inst);
    final contact = template.contact;
    final pendingChoices = notifier.pendingChoices(inst);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          // Header
          SafeArea(
            bottom: false,
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0xFF007AFF), size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                '0xFF${contact.avatarTint.substring(1)}')),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(contact.emoji,
                              style: const TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        if (contact.subtitle != null)
                          Text(
                            contact.subtitle!,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
          const Divider(height: 0.5, color: Color(0xFFE5E5E5)),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: inst.playedMessages.length +
                  (inst.ended ? 1 : 0) +
                  1,
              itemBuilder: (context, i) {
                if (inst.ended && i == inst.playedMessages.length) {
                  return _EndingBanner(endingId: inst.endingId);
                }
                if (i >= inst.playedMessages.length) {
                  return const SizedBox(height: 16);
                }
                final m = inst.playedMessages[i];
                final prev =
                    i > 0 ? inst.playedMessages[i - 1] : null;
                final showDateSep =
                    prev == null || prev.day != m.day;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateSep) _DateSep(day: m.day),
                    _ArcBubble(msg: m, contact: contact),
                  ],
                );
              },
            ),
          ),
          if (pendingChoices != null && !inst.ended)
            _ArcChoicePanel(
              choices: pendingChoices,
              onTap: (idx) {
                HapticFeedback.selectionClick();
                final p = ref.read(phoneStateProvider);
                notifier.respondToChoice(
                  instanceId: inst.id,
                  choiceIdx: idx,
                  day: p.currentDay,
                  hour: p.hour,
                  minute: p.minute,
                );
                _scrollToBottom();
              },
            )
          else if (!inst.ended)
            const _InputBarMock(),
        ],
      ),
    );
  }
}

class _DateSep extends StatelessWidget {
  const _DateSep({required this.day});
  final int day;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          'J$day',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.grey.shade500,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ArcBubble extends StatelessWidget {
  const _ArcBubble({required this.msg, required this.contact});
  final MessagesArcPlayedMsg msg;
  final MessagesArcContact contact;

  @override
  Widget build(BuildContext context) {
    final isMe = !msg.fromThem;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildContent(isMe),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMe) {
    switch (msg.type) {
      case MessagesArcBeatType.text:
        return _textBubble(isMe, msg.text ?? '');
      case MessagesArcBeatType.photoShared:
        return _photoBubble(isMe);
      case MessagesArcBeatType.voiceNote:
        return _voiceBubble(isMe);
      case MessagesArcBeatType.typingThenNothing:
        return _ghostTyping();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _textBubble(bool isMe, String text) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      margin: EdgeInsets.only(
          left: isMe ? 60 : 0, right: isMe ? 0 : 60, top: 1, bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF007AFF) : const Color(0xFFE9E9EB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 15,
          color: isMe ? Colors.white : const Color(0xFF1A1A1A),
          height: 1.3,
        ),
      ),
    );
  }

  Widget _photoBubble(bool isMe) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(
          left: isMe ? 80 : 0, right: isMe ? 0 : 80, top: 4, bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(contact.gradient.first),
                      Color(contact.gradient.last),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(contact.emoji,
                    style: const TextStyle(fontSize: 56)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Text(
                    msg.photoLabel ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _voiceBubble(bool isMe) {
    final dur = msg.voiceDurationS ?? 30;
    final mm = dur ~/ 60;
    final ss = (dur % 60).toString().padLeft(2, '0');
    return Container(
      margin: EdgeInsets.only(
          left: isMe ? 80 : 0, right: isMe ? 0 : 80, top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF007AFF) : const Color(0xFFE9E9EB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow,
              size: 20,
              color: isMe ? Colors.white : const Color(0xFF1A1A1A)),
          const SizedBox(width: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(16, (i) {
              final h = 4.0 + (i * 37 % 11);
              return Container(
                width: 2,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: isMe
                    ? Colors.white.withValues(alpha: 0.8)
                    : const Color(0xFF1A1A1A).withValues(alpha: 0.6),
              );
            }),
          ),
          const SizedBox(width: 8),
          Text(
            '$mm:$ss',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isMe ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ghostTyping() {
    return Container(
      margin: const EdgeInsets.only(right: 60, top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9EB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '· · ·  tape… puis efface',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontStyle: FontStyle.italic,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

class _EndingBanner extends StatelessWidget {
  const _EndingBanner({required this.endingId});
  final String? endingId;

  String _labelFor(String? id) {
    switch (id) {
      case 'voisine_alliée':
        return 'Mme Dubreuil est devenue une alliée silencieuse.';
      case 'voisine_dignite_blessee':
        return 'Mme Dubreuil ne vous écrira plus. La fuite a été réparée à votre place.';
      case 'voisine_distance':
        return 'Vous avez tenu vos distances. Le colis a été déposé sans un mot.';
      default:
        return 'Conversation close.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Center(
          child: Text(
            _labelFor(endingId),
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcChoicePanel extends StatelessWidget {
  const _ArcChoicePanel({required this.choices, required this.onTap});
  final List<MessagesArcChoice> choices;
  final void Function(int idx) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              'Tu réponds quoi ?',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade600,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (var i = 0; i < choices.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _ArcChoiceButton(
                choice: choices[i],
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArcChoiceButton extends StatelessWidget {
  const _ArcChoiceButton({required this.choice, required this.onTap});
  final MessagesArcChoice choice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              choice.label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF007AFF),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              choice.reply.isEmpty ? '(silence)' : choice.reply,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF1A1A1A),
                fontStyle: choice.reply.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBarMock extends StatelessWidget {
  const _InputBarMock();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAFA),
          border:
              Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: const Color(0xFFE5E5E5), width: 0.5),
                ),
                child: Text(
                  'En attente…',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
