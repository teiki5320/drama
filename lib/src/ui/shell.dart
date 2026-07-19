import 'package:flutter/material.dart';

import '../engine.dart';
import '../palette.dart';
import 'home_screen.dart';
import 'lock_screen.dart';
import 'thread_screen.dart';
import 'widgets.dart';

/// La coquille du jeu : écran verrouillé, liste des conversations,
/// fil ouvert, et bannières de notification.
class GameShell extends StatefulWidget {
  const GameShell({super.key});

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  GameEngine _engine = GameEngine();

  void _restart() {
    setState(() => _engine = GameEngine());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _engine.currentThreadId != null) {
          _engine.goHome();
        }
      },
      child: Scaffold(
        body: ListenableBuilder(
          listenable: _engine,
          builder: (context, _) {
            final tid = _engine.currentThreadId;
            return Stack(
              children: [
                Positioned.fill(
                  child: tid == null
                      ? HomeScreen(engine: _engine)
                      : ThreadScreen(
                          key: ValueKey(tid),
                          engine: _engine,
                          threadId: tid,
                          onRestart: _restart,
                        ),
                ),
                if (_engine.banner != null)
                  _BannerOverlay(engine: _engine),
                AnimatedSlide(
                  offset: _engine.locked
                      ? Offset.zero
                      : const Offset(0, -1.1),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  child: IgnorePointer(
                    ignoring: !_engine.locked,
                    child: LockScreen(onUnlock: _engine.unlock),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BannerOverlay extends StatelessWidget {
  const _BannerOverlay({required this.engine});

  final GameEngine engine;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final banner = engine.banner!;
    final thread = engine.thread(banner.threadId);
    return Positioned(
      left: 10,
      right: 10,
      top: 0,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => engine.openThread(banner.threadId),
          child: Material(
            color: pal.bannerBg,
            elevation: 8,
            shadowColor: Colors.black45,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  GradientAvatar(def: thread.effectiveDef, size: 34),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thread.effectiveDef.name,
                          style: TextStyle(
                            color: pal.headText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          banner.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: pal.preview, fontSize: 13),
                        ),
                      ],
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
