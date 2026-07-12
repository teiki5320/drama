import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/contact_states.dart';
import '../../../../data/messages_data.dart';
import '../../../../data/thread_render.dart';
import '../../../../providers/phone_state_provider.dart';
import '../../../../providers/relationships_provider.dart';
import '../../../../providers/sent_replies_provider.dart';
import 'choice_panel.dart';

/// Vue conversation iMessage : bulles bleues à droite (Shen), grises à
/// gauche (l'autre), barre du haut avec emoji + nom, indicateur de
/// frappe « tape... », statut « Lu / Délivré » sous le dernier message
/// de Shen.
class ThreadView extends ConsumerStatefulWidget {
  const ThreadView({super.key, required this.contact});
  final MsgContact contact;

  @override
  ConsumerState<ThreadView> createState() => _ThreadViewState();
}

/// Mémoire de session : combien de messages ont déjà « défilé » pour chaque
/// contact. Évite de rejouer l'animation d'arrivée quand on rouvre un fil —
/// seuls les messages réellement nouveaux arrivent un par un.
final Map<String, int> _revealedPerContact = {};

class _ThreadViewState extends ConsumerState<ThreadView> {
  final _scrollCtrl = ScrollController();

  /// Nombre de messages actuellement affichés (le reste arrive un par un).
  int _shown = -1;

  /// Un message reçu est « en train d'être écrit » (bulle « … » en bas).
  bool _typing = false;

  /// Une boucle de révélation est en cours (évite les doublons).
  bool _revealing = false;

  @override
  void initState() {
    super.initState();
    // Vibration différenciée par contact à l'ouverture
    _vibrateForContact(widget.contact.id);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  }

  void _scrollSoon() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

  /// Révèle les messages restants un par un. Les messages reçus sont
  /// précédés d'une bulle « … » et d'un délai proportionnel à leur longueur ;
  /// les réponses de Shen apparaissent presque aussitôt.
  void _maybeReveal(List<Msg> msgs) {
    if (_revealing || _shown >= msgs.length) return;
    _revealing = true;
    () async {
      while (mounted && _shown < msgs.length) {
        final next = msgs[_shown];
        if (next.sender != 'moi') {
          setState(() => _typing = true);
          _scrollSoon();
          final ms = (next.text.length * 22).clamp(600, 1600);
          await Future.delayed(Duration(milliseconds: ms));
          if (!mounted) break;
          HapticFeedback.lightImpact();
          setState(() {
            _typing = false;
            _shown++;
          });
        } else {
          await Future.delayed(const Duration(milliseconds: 280));
          if (!mounted) break;
          setState(() => _shown++);
        }
        _revealedPerContact[widget.contact.id] = _shown;
        _scrollSoon();
      }
      _revealing = false;
      if (mounted) setState(() {});
    }();
  }

  static void _vibrateForContact(String contactId) {
    switch (contactId) {
      case 'maman':
        HapticFeedback.lightImpact();
        break;
      case 'tristan':
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 120),
            HapticFeedback.heavyImpact);
        break;
      case 'camille':
        HapticFeedback.selectionClick();
        break;
      default:
        HapticFeedback.selectionClick();
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final sentReplies = ref.watch(sentRepliesProvider);
    // Suspicion du contact (pour filtrer les messages paranoïaques).
    final suspicion = ref
            .watch(relationshipsProvider)[widget.contact.id]
            ?.suspicion ??
        0;
    // Messages canoniques du thread + réponses dynamiques de Shen
    // intercalées après chaque beat répondu.
    // Calcul d'affichage (logique pure, testée dans test/thread_gating_test).
    final render = computeThreadRender(
      thread: kThreads[widget.contact.id] ?? const [],
      sentReplies: sentReplies,
      day: day,
      suspicion: suspicion,
    );
    final msgs = render.messages;
    final pendingMsg = render.pendingMsg;
    final pendingBeat = render.pendingBeatId;

    // Première ouverture : l'historique (jours précédents) s'affiche d'un
    // bloc, les messages du jour courant arrivent un par un. Une réouverture
    // ne rejoue que ce qui est réellement nouveau (mémoire de session).
    if (_shown < 0) {
      final history = msgs.where((m) => m.day < day).length;
      final revealed = _revealedPerContact[widget.contact.id] ?? 0;
      _shown = revealed > history ? revealed : history;
    }
    if (_shown > msgs.length) _shown = msgs.length;
    final revealDone = _shown >= msgs.length;
    if (!revealDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeReveal(msgs));
    }
    final visible = msgs.take(_shown).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0xFF007AFF), size: 20),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                    },
                  ),
                  // Avatar + nom (centré)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: widget.contact.avatarPath == null
                                ? Color(int.parse(
                                    '0xFF${widget.contact.avatarTint.substring(1)}'))
                                : null,
                            shape: BoxShape.circle,
                            image: widget.contact.avatarPath != null
                                ? DecorationImage(
                                    image:
                                        AssetImage(widget.contact.avatarPath!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: widget.contact.avatarPath != null
                              ? null
                              : Text(widget.contact.emoji,
                                  style: const TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.contact.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Builder(builder: (_) {
                          final s = statusForContact(widget.contact.id, day);
                          if (s == null) return const SizedBox.shrink();
                          return Text(
                            '${s.emoji ?? ''}${s.emoji != null ? ' ' : ''}${s.label}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam,
                        color: Color(0xFF007AFF), size: 22),
                    onPressed: () => HapticFeedback.selectionClick(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0.5, color: Color(0xFFE5E5E5)),
          // Messages — révélés un par un (voir _maybeReveal).
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: visible.length + 1,
              itemBuilder: (context, i) {
                if (i == visible.length) {
                  // Bulle « … » pendant qu'un message reçu s'écrit.
                  if (_typing) return const _TypingBubble();
                  return const SizedBox(height: 24);
                }
                final m = visible[i];
                final showStatus =
                    m.sender == 'moi' && revealDone && i == visible.length - 1;
                return _Bubble(msg: m, showStatus: showStatus);
              },
            ),
          ),
          // Le panneau de choix (ou l'input bar) n'apparaît qu'une fois toute
          // la séquence arrivée — sinon il surgirait pendant que ça « écrit ».
          if (revealDone && pendingBeat != null)
            ChoicePanel(
              beatId: pendingBeat,
              lastMessageTime: pendingMsg!.time,
              lastMessageDay: pendingMsg.day,
              promptText: pendingMsg.text,
            )
          else if (revealDone)
            _InputBar(),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.msg,
    required this.showStatus,
  });
  final Msg msg;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final isMe = msg.sender == 'moi';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            margin: EdgeInsets.only(left: isMe ? 60 : 0, right: isMe ? 0 : 60),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF007AFF) : const Color(0xFFE9E9EB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              msg.text,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: isMe ? Colors.white : const Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
          ),
          if (showStatus)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 6),
              child: Text(
                msg.status == MsgStatus.read
                    ? 'Lu'
                    : msg.status == MsgStatus.delivered
                        ? 'Délivré'
                        : 'Envoi…',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 12),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9EB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final v = ((_ctrl.value * 3) - i).clamp(0, 1).toDouble();
                    final scale = 0.6 + 0.4 * v;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      width: 7 * scale,
                      height: 7 * scale,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAFA),
          border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle, color: Colors.grey.shade400, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
                ),
                child: Text(
                  'iMessage',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.mic, color: Colors.grey.shade400, size: 26),
          ],
        ),
      ),
    );
  }
}
