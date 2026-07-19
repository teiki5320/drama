import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../palette.dart';
import 'contact_sheet.dart';
import 'widgets.dart';

/// L'écran unique du jeu : une conversation, les messages qui arrivent,
/// et le clavier remplacé par les choix de réponse.
class ThreadScreen extends StatefulWidget {
  const ThreadScreen({
    super.key,
    required this.engine,
    required this.threadId,
    required this.onRestart,
  });

  final GameEngine engine;
  final String threadId;
  final VoidCallback onRestart;

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  final ScrollController _scroll = ScrollController();
  int _lastCount = -1;

  /// Suit le bas du fil uniquement si le joueur y est déjà : s'il remonte
  /// lire le début, l'écran ne bouge plus et une pastille compte les
  /// nouveaux messages en bas.
  bool _stickToBottom = true;
  int _unseenBelow = 0;

  ThreadState get thread => widget.engine.thread(widget.threadId);

  @override
  void initState() {
    super.initState();
    _lastCount = thread.messages.length;
    widget.engine.addListener(_onEngine);
    _scroll.addListener(_onScroll);
    _scrollToBottom(animated: false);
  }

  @override
  void dispose() {
    widget.engine.removeListener(_onEngine);
    _scroll.dispose();
    super.dispose();
  }

  bool get _nearBottom {
    if (!_scroll.hasClients) return true;
    final pos = _scroll.position;
    return pos.maxScrollExtent - pos.pixels < 140;
  }

  void _onScroll() {
    final near = _nearBottom;
    if (near == _stickToBottom) return;
    _stickToBottom = near;
    if (near && _unseenBelow != 0) {
      setState(() => _unseenBelow = 0);
    }
  }

  void _onEngine() {
    final count = thread.messages.length;
    final added = count - _lastCount;
    _lastCount = count;
    if (_stickToBottom) {
      _scrollToBottom();
    } else if (added > 0) {
      setState(() => _unseenBelow += added);
    }
  }

  void _jumpToNew() {
    _stickToBottom = true;
    setState(() => _unseenBelow = 0);
    _scrollToBottom();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final target = _scroll.position.maxScrollExtent;
      if (animated) {
        _scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      } else {
        _scroll.jumpTo(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final t = thread;
    return Container(
      color: pal.threadBg,
      child: SafeArea(
        child: Column(
          children: [
            GameClockBar(engine: widget.engine),
            _Header(engine: widget.engine, thread: t),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                    itemCount: t.messages.length,
                    itemBuilder: (context, i) => _MessageItem(
                      msg: t.messages[i],
                      previous: i > 0 ? t.messages[i - 1] : null,
                      onRestart: widget.onRestart,
                    ),
                  ),
                  if (_unseenBelow > 0)
                    Positioned(
                      right: 12,
                      bottom: 10,
                      child: _NewMessagesPill(
                        count: _unseenBelow,
                        onTap: _jumpToNew,
                      ),
                    ),
                ],
              ),
            ),
            _ChoiceTray(engine: widget.engine, thread: t),
          ],
        ),
      ),
    );
  }
}

class _NewMessagesPill extends StatelessWidget {
  const _NewMessagesPill({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final label = count == 1 ? '1 nouveau message' : '$count nouveaux messages';
    return Material(
      color: pal.brand,
      shape: const StadiumBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_downward, color: Colors.white, size: 15),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.engine, required this.thread});

  final GameEngine engine;
  final ThreadState thread;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final def = thread.effectiveDef;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
      decoration: BoxDecoration(
        color: pal.headBg,
        border: Border(bottom: BorderSide(color: pal.headBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: engine.goHome,
            icon: Icon(Icons.arrow_back_ios_new, color: pal.chev, size: 22),
            tooltip: 'Messages',
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showContactSheet(context, thread),
              child: Column(
                children: [
                  GradientAvatar(def: def, size: 40),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        def.headerName,
                        style: TextStyle(
                          color: pal.headText,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: pal.meta, size: 13),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({
    required this.msg,
    required this.previous,
    required this.onRestart,
  });

  final Msg msg;
  final Msg? previous;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    switch (msg.kind) {
      case MsgKind.separator:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Column(
              children: [
                Text(
                  'iMessage',
                  style: TextStyle(
                    color: pal.meta,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  msg.text,
                  style: TextStyle(
                    color: pal.meta,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      case MsgKind.sysline:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              msg.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: pal.meta, fontSize: 12),
            ),
          ),
        );
      case MsgKind.endCard:
        return _EndCard(onRestart: onRestart);
      case MsgKind.incoming:
      case MsgKind.outgoing:
        final isOut = msg.kind == MsgKind.outgoing;
        final prevKind = previous?.kind;
        final tightTop = prevKind == msg.kind &&
            (prevKind == MsgKind.incoming || prevKind == MsgKind.outgoing);
        return Padding(
          padding: EdgeInsets.only(top: tightTop ? 2 : 10),
          child: Column(
            crossAxisAlignment:
                isOut ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Align(
                alignment:
                    isOut ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  child: msg.imageAsset != null && !msg.typing
                      ? _ImageBubble(asset: msg.imageAsset!, isOut: isOut)
                      : Container(
                          padding: msg.typing
                              ? const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12)
                              : const EdgeInsets.fromLTRB(13, 8, 13, 9),
                          decoration: BoxDecoration(
                            color: isOut ? pal.outBubble : pal.inBubble,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isOut ? 18 : 6),
                              bottomRight: Radius.circular(isOut ? 6 : 18),
                            ),
                          ),
                          child: msg.typing
                              ? TypingDots(color: pal.meta)
                              : Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: isOut ? pal.outText : pal.inText,
                                    fontSize: 16,
                                    height: 1.32,
                                  ),
                                ),
                        ),
                ),
              ),
              if (isOut && msg.receipt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 4),
                  child: Text(
                    msg.receipt!,
                    style: TextStyle(
                      color: pal.meta,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
    }
  }
}

class _ImageBubble extends StatelessWidget {
  const _ImageBubble({required this.asset, required this.isOut});

  final String asset;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final maxW = MediaQuery.of(context).size.width * 0.65;
    return GestureDetector(
      onTap: () => _openViewer(context),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isOut ? 18 : 6),
          bottomRight: Radius.circular(isOut ? 6 : 18),
        ),
        child: Image.asset(
          asset,
          width: maxW,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            width: maxW,
            height: maxW * 0.75,
            color: pal.inBubble,
            alignment: Alignment.center,
            child: Text('📷', style: TextStyle(fontSize: 28, color: pal.meta)),
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, _, __) => GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: InteractiveViewer(
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(
                          asset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stack) => const Text(
                            '📷',
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EndCard extends StatelessWidget {
  const _EndCard({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Column(
          children: [
            Text(
              'FIN DE L’ÉPISODE 1',
              style: TextStyle(
                color: pal.brand,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Demain, 11h30 : l’étude notariale.\n'
              'Quatorze pages entre Tenon et ta fierté.\n'
              'La suite dans la prochaine mise à jour.',
              textAlign: TextAlign.center,
              style: TextStyle(color: pal.meta, fontSize: 12.5, height: 1.7),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onRestart,
              style: OutlinedButton.styleFrom(
                foregroundColor: pal.brand,
                side: BorderSide(color: pal.brand, width: 1.5),
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              ),
              child: const Text(
                '↺  REJOUER L’ÉPISODE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTray extends StatelessWidget {
  const _ChoiceTray({required this.engine, required this.thread});

  final GameEngine engine;
  final ThreadState thread;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final pending = thread.pending;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: pal.headBg,
        border: Border(top: BorderSide(color: pal.headBorder, width: 0.5)),
      ),
      child: pending == null
          ? Center(
              child: Text(
                engine.ended
                    ? 'Drama — messagerie uniquement.'
                    : '…',
                style: TextStyle(color: pal.meta, fontSize: 12.5),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'À TOI DE RÉPONDRE',
                    style: TextStyle(
                      color: pal.meta,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                for (final opt in pending.options) ...[
                  _ChoiceButton(
                    option: opt,
                    onTap: () => engine.resolveChoice(thread.def.id, opt),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.option, required this.onTap});

  final ChoiceOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final color = option.silent ? pal.meta : pal.choiceText;
    return Material(
      color: option.silent ? Colors.transparent : pal.choiceBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: option.silent ? pal.meta : pal.choiceBorder,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            option.label,
            style: TextStyle(
              color: color,
              fontSize: 15,
              height: 1.3,
              fontStyle: option.silent ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }
}
