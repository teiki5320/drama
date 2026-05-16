import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/romance.dart';
import '../../../../providers/phone_state_provider.dart';
import '../../../../providers/romance_threads_provider.dart';
import 'romance_profile_visual.dart';

/// Conversation Tinder DM — bulles bleu/gris pâle (différent des
/// Messages iMessage pour bien marquer la compartmentation mentale
/// de Shen), photos en placeholder doux, vocaux waveform mock, choix
/// Shen en bas, possibilité d'unmatch via menu header.
class RomanceThreadView extends ConsumerStatefulWidget {
  const RomanceThreadView({super.key, required this.instanceId});
  final String instanceId;

  @override
  ConsumerState<RomanceThreadView> createState() => _RomanceThreadViewState();
}

class _RomanceThreadViewState extends ConsumerState<RomanceThreadView> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // Tick immédiat à l'ouverture pour rattraper les beats en retard.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(phoneStateProvider);
      ref.read(romanceThreadsProvider.notifier).tickAll(
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
    final state = ref.watch(romanceThreadsProvider);
    final notifier = ref.read(romanceThreadsProvider.notifier);
    final inst = state.instances
        .where((i) => i.id == widget.instanceId)
        .cast<RomanceInstance?>()
        .firstWhere((_) => true, orElse: () => null);
    if (inst == null) {
      // L'instance a disparu (rare) — retour silencieux.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
      return const Scaffold(backgroundColor: Colors.white);
    }
    final profile = notifier.profileOf(inst);
    final pendingChoices = notifier.pendingChoices(inst);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _Header(
            profile: profile,
            ended: inst.ended,
            endingId: inst.endingId,
            onClose: () => Navigator.of(context).pop(),
            onUnmatch: inst.ended
                ? null
                : () {
                    HapticFeedback.heavyImpact();
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Unmatch ${profile.name} ?',
                            style: GoogleFonts.inter(fontSize: 16)),
                        content: Text(
                            'Vous ne pourrez plus vous écrire. Pas de retour.',
                            style: GoogleFonts.inter(fontSize: 13)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              notifier.unmatch(inst.id);
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Unmatch',
                                style: TextStyle(color: Color(0xFFFD297B))),
                          ),
                        ],
                      ),
                    );
                  },
          ),
          const Divider(height: 0.5, color: Color(0xFFE5E5E5)),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: inst.playedMessages.length +
                  (inst.ended ? 1 : 0) +
                  1, // padding du bas
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
                // Slide-in seulement sur le tout dernier message (pour
                // donner l'impression d'une arrivée "live" sans
                // animer rétroactivement tout l'historique).
                final isLastMsg = i == inst.playedMessages.length - 1;
                final bubble =
                    _MessageBubble(msg: m, profile: profile);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateSep)
                      _DateSep(day: m.day),
                    if (isLastMsg)
                      _SlideInBubble(child: bubble, key: ValueKey(i))
                    else
                      bubble,
                  ],
                );
              },
            ),
          ),
          if (pendingChoices != null && !inst.ended)
            _ChoicePanel(
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

class _Header extends StatelessWidget {
  const _Header({
    required this.profile,
    required this.ended,
    required this.endingId,
    required this.onClose,
    required this.onUnmatch,
  });
  final RomanceProfile profile;
  final bool ended;
  final String? endingId;
  final VoidCallback onClose;
  final VoidCallback? onUnmatch;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Color(0xFFFD297B), size: 20),
              onPressed: onClose,
            ),
            SizedBox(
              width: 36,
              height: 36,
              child: RomanceAvatar(profile: profile),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.name}, ${profile.age}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    ended
                        ? 'Arc terminé'
                        : '${profile.profession} · ${profile.quartier}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (onUnmatch != null)
              IconButton(
                icon: Icon(Icons.more_horiz, color: Colors.grey.shade500),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.heart_broken,
                                color: Color(0xFFFD297B)),
                            title: Text('Unmatch ${profile.name}',
                                style: GoogleFonts.inter(fontSize: 14)),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              onUnmatch!();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.report_outlined),
                            title: Text('Signaler',
                                style: GoogleFonts.inter(fontSize: 14)),
                            onTap: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Slide-in vertical 250 ms + fade-in pour les nouveaux messages.
class _SlideInBubble extends StatefulWidget {
  const _SlideInBubble({super.key, required this.child});
  final Widget child;
  @override
  State<_SlideInBubble> createState() => _SlideInBubbleState();
}

class _SlideInBubbleState extends State<_SlideInBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_ctrl.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 14),
            child: child,
          ),
        );
      },
      child: widget.child,
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.msg, required this.profile});
  final PlayedMessage msg;
  final RomanceProfile profile;

  @override
  Widget build(BuildContext context) {
    final isMe = !msg.fromThem;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: _buildContent(isMe),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMe) {
    switch (msg.type) {
      case RomanceBeatType.text:
        return _bubble(
          isMe: isMe,
          child: Text(
            msg.text ?? '',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isMe ? Colors.white : const Color(0xFF1A1A1A),
              height: 1.35,
            ),
          ),
        );
      case RomanceBeatType.voiceNote:
        return _bubble(
          isMe: isMe,
          child: _VoiceMock(durationS: msg.voiceDurationS ?? 30, isMe: isMe),
        );
      case RomanceBeatType.photoShared:
        return _photoCard(isMe);
      case RomanceBeatType.mapLocation:
        return _mapCard(isMe);
      case RomanceBeatType.callRing:
        return _callCard(isMe);
      case RomanceBeatType.typingThenNothing:
        return _ghostTyping();
      case RomanceBeatType.unmatch:
      case RomanceBeatType.choice:
      case RomanceBeatType.seenNoReply:
      case RomanceBeatType.cancelRdv:
        return const SizedBox.shrink();
    }
  }

  Widget _bubble({required bool isMe, required Widget child}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 260,
      ),
      margin: EdgeInsets.only(
        left: isMe ? 60 : 0,
        right: isMe ? 0 : 60,
        top: 1,
        bottom: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFFD297B) : const Color(0xFFF1F1F3),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMe ? 18 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 18),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              msg.time,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoCard(bool isMe) {
    // Index photo basé sur le hash du label : stable, varie selon le beat.
    final photoIdx = (msg.photoLabel?.hashCode ?? 0).abs() % 4;
    return Container(
      width: 220,
      margin: EdgeInsets.only(
        left: isMe ? 80 : 0,
        right: isMe ? 0 : 80,
        top: 4,
        bottom: 4,
      ),
      child: RomanceSharedPhoto(
        profile: profile,
        caption: msg.photoLabel ?? '',
        time: msg.time,
        photoIdx: photoIdx,
      ),
    );
  }

  Widget _mapCard(bool isMe) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(
        left: isMe ? 80 : 0,
        right: isMe ? 0 : 80,
        top: 4,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFE8F0E5),
        border: Border.all(color: const Color(0xFFCEDCC4), width: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place, size: 16, color: Color(0xFF7B8C6F)),
              const SizedBox(width: 4),
              Text(
                'Apple Plans',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7B8C6F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            msg.photoLabel ?? '',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF1A1A1A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            msg.time,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _callCard(bool isMe) {
    return _bubble(
      isMe: isMe,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            msg.callMissed ? Icons.call_missed : Icons.call,
            size: 14,
            color: isMe ? Colors.white : const Color(0xFF1A1A1A),
          ),
          const SizedBox(width: 6),
          Text(
            msg.callMissed
                ? 'Appel manqué'
                : 'Appel · ${(msg.callDurationS ?? 0) ~/ 60}:'
                    '${((msg.callDurationS ?? 0) % 60).toString().padLeft(2, '0')}',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isMe ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ghostTyping() {
    return const _TypingGhostBubble();
  }
}

/// Bulle "tape… puis efface" — 3 points qui pulse pendant 4 s puis fade-out.
/// Représente visuellement l'anxiété d'un message qui n'arrive pas.
class _TypingGhostBubble extends StatefulWidget {
  const _TypingGhostBubble();
  @override
  State<_TypingGhostBubble> createState() => _TypingGhostBubbleState();
}

class _TypingGhostBubbleState extends State<_TypingGhostBubble>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
    value: 1.0,
  );

  @override
  void initState() {
    super.initState();
    // Après 4s, on lance le fade-out (la bulle reste affichée mais grise)
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) _fade.reverse();
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fade,
      builder: (context, _) => Opacity(
        opacity: 0.35 + 0.65 * _fade.value,
        child: Container(
          margin: const EdgeInsets.only(right: 60, top: 4, bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final v =
                          ((_pulse.value * 3) - i).clamp(0, 1).toDouble();
                      final scale = 0.6 + 0.4 * v;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 6 * scale,
                        height: 6 * scale,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                _fade.value > 0.95
                    ? 'tape…'
                    : (_fade.value > 0.3 ? '…puis efface' : 'rien'),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoiceMock extends StatelessWidget {
  const _VoiceMock({required this.durationS, required this.isMe});
  final int durationS;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final mm = durationS ~/ 60;
    final ss = (durationS % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_arrow,
          size: 22,
          color: isMe ? Colors.white : const Color(0xFF1A1A1A),
        ),
        const SizedBox(width: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(18, (i) {
            final h = 4.0 + (i * 37 % 13);
            return Container(
              width: 2,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.85)
                    : const Color(0xFF1A1A1A).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(1),
              ),
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
    );
  }
}

class _EndingBanner extends StatelessWidget {
  const _EndingBanner({required this.endingId});
  final String? endingId;

  String _labelFor(String? id) {
    switch (id) {
      case 'rupture_honnete':
        return 'Rupture honnête. Il s\'éloigne.';
      case 'rupture_mutuelle':
        return 'Rupture mutuelle.';
      case 'rupture_tardive':
        return 'Rupture tardive. Pardon dit trop tard.';
      case 'shen_ghost_early':
        return 'Tu as ghost. Il est passé à autre chose.';
      case 'shen_ghost_pre_rdv':
        return 'Tu as ghost avant le RDV.';
      case 'shen_ghost_post_rdv':
        return 'Tu as ghost après le RDV.';
      case 'shen_unmatch':
        return 'Tu as unmatch.';
      case 'il_unmatch_silencieux':
        return 'Il a unmatch sans explication.';
      case 'il_fade_seche':
        return 'Il s\'est éteint après ta sécheresse.';
      default:
        return 'Arc terminé.';
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

class _ChoicePanel extends StatelessWidget {
  const _ChoicePanel({required this.choices, required this.onTap});
  final List<RomanceChoice> choices;
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
              child: _ChoiceButton(
                choice: choices[i],
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.choice, required this.onTap});
  final RomanceChoice choice;
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
                color: const Color(0xFFFD297B),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              choice.reply.isEmpty ? '(silence)' : choice.reply,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF1A1A1A),
                fontStyle:
                    choice.reply.isEmpty ? FontStyle.italic : FontStyle.normal,
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
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAFA),
          border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFE5E5E5), width: 0.5),
                ),
                child: Text(
                  'En attente…',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
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
