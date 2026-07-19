import 'dart:async';

import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../notifications.dart';
import '../palette.dart';
import '../sfx.dart';
import 'bank_screen.dart';
import 'gallery_screen.dart';
import 'home_screen.dart';
import 'sudoku_screen.dart';
import 'intro_card.dart';
import 'lock_screen.dart';
import 'springboard.dart';
import 'thread_screen.dart';
import 'widgets.dart';

/// La coquille du jeu : écran verrouillé, accueil du téléphone, apps
/// (Messages, Ma Banque), et bannières de notification.
class GameShell extends StatefulWidget {
  const GameShell({super.key});

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> with WidgetsBindingObserver {
  GameEngine _engine = GameEngine()..sfx = Sfx.play;
  bool _showIntro = false;
  Timer? _introTimer;

  /// L'app ouverte : 'home', 'messages', 'banque', 'photos' ou 'sudoku'.
  String _app = 'home';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _restart() {
    _introTimer?.cancel();
    setState(() {
      _engine = GameEngine()..sfx = Sfx.play;
      _showIntro = false;
      _app = 'home';
    });
  }

  void _onUnlock() {
    _engine.unlock();
    setState(() => _showIntro = true);
    _introTimer = Timer(const Duration(milliseconds: 3600), _dismissIntro);
  }

  void _dismissIntro() {
    _introTimer?.cancel();
    if (!mounted || !_showIntro) return;
    setState(() => _showIntro = false);
    _engine.startStory();
  }

  void _debugJump(int day) {
    _introTimer?.cancel();
    setState(() {
      _engine = GameEngine()..sfx = Sfx.play;
      _showIntro = false;
      _app = 'messages';
    });
    _engine.debugStart(day);
  }

  void _openFromBanner(String threadId) {
    _engine.openThread(threadId);
    if (_app != 'messages') setState(() => _app = 'messages');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _scheduleComeback();
    } else if (state == AppLifecycleState.resumed) {
      Notifications.cancelAll();
    }
  }

  /// Programme les rappels « comme de vrais messages » quand on quitte l'app.
  void _scheduleComeback() {
    if (_engine.locked || _engine.ended) return;
    ThreadState? pendingT;
    ThreadState? unreadT;
    for (final t in _engine.threads.values) {
      if (t.pending != null) pendingT ??= t;
      if (t.unread > 0) unreadT ??= t;
    }
    if (pendingT != null) {
      Notifications.comeback(
        id: 1,
        title: pendingT.effectiveDef.name,
        body: 'attend toujours ta réponse…',
        delay: const Duration(minutes: 45),
      );
    } else if (unreadT != null) {
      Notifications.comeback(
        id: 1,
        title: unreadT.effectiveDef.name,
        body: unreadT.unread == 1
            ? '1 message non lu'
            : '${unreadT.unread} messages non lus',
        delay: const Duration(minutes: 45),
      );
    }
    Notifications.comeback(
      id: 2,
      title: 'Drama',
      body: 'Shen a besoin de toi. La suite t’attend.',
      delay: const Duration(hours: 23),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _introTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_engine.currentThreadId != null) {
          _engine.goHome();
        } else if (_app != 'home') {
          setState(() => _app = 'home');
        }
      },
      child: Scaffold(
        body: ListenableBuilder(
          listenable: _engine,
          builder: (context, _) {
            final tid = _engine.currentThreadId;
            final Widget page;
            if (_app == 'banque') {
              page = BankScreen(
                engine: _engine,
                onBack: () => setState(() => _app = 'home'),
              );
            } else if (_app == 'photos') {
              page = GalleryScreen(
                onBack: () => setState(() => _app = 'home'),
              );
            } else if (_app == 'sudoku') {
              page = SudokuScreen(
                onBack: () => setState(() => _app = 'home'),
                onGallery: () => setState(() => _app = 'photos'),
              );
            } else if (_app == 'messages') {
              page = tid == null
                  ? HomeScreen(
                      engine: _engine,
                      onDebugJump: _debugJump,
                      onExit: () => setState(() => _app = 'home'),
                    )
                  : ThreadScreen(
                      key: ValueKey(tid),
                      engine: _engine,
                      threadId: tid,
                      onRestart: _restart,
                    );
            } else {
              page = Springboard(
                engine: _engine,
                onOpenApp: (a) => setState(() => _app = a),
              );
            }
            return Stack(
              children: [
                Positioned.fill(child: page),
                if (_engine.banner != null)
                  _BannerOverlay(engine: _engine, onOpen: _openFromBanner),
                if (_showIntro)
                  Positioned.fill(child: IntroCard(onDone: _dismissIntro)),
                AnimatedSlide(
                  offset: _engine.locked
                      ? Offset.zero
                      : const Offset(0, -1.1),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  child: IgnorePointer(
                    ignoring: !_engine.locked,
                    child: LockScreen(onUnlock: _onUnlock),
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
  const _BannerOverlay({required this.engine, required this.onOpen});

  final GameEngine engine;
  final ValueChanged<String> onOpen;

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
          onTap: () => onOpen(banner.threadId),
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
