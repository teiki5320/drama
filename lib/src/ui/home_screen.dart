import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../palette.dart';
import 'widgets.dart';

/// La liste des conversations — l'écran d'accueil du jeu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.engine});

  final GameEngine engine;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final threads = engine.visibleThreads;
    return Container(
      color: pal.threadBg,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Text(
                'Messages',
                style: TextStyle(
                  color: pal.headText,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: threads.length,
                itemBuilder: (context, i) =>
                    _ThreadRow(engine: engine, thread: threads[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadRow extends StatelessWidget {
  const _ThreadRow({required this.engine, required this.thread});

  final GameEngine engine;
  final ThreadState thread;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return InkWell(
      onTap: () => engine.openThread(thread.def.id),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 11, 16, 11),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: pal.rowBorder, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              child: thread.unread > 0
                  ? Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: pal.dot,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            GradientAvatar(def: thread.def),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.def.name,
                    style: TextStyle(
                      color: pal.headText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    thread.preview.isEmpty ? ' ' : thread.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: pal.preview,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  thread.previewTime,
                  style: TextStyle(
                    color: pal.preview,
                    fontSize: 13,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (thread.pending != null) ...[
                  const SizedBox(height: 5),
                  const ReplyPill(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
