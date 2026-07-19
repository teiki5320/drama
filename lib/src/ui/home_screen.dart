import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../palette.dart';
import '../story.dart';
import 'contact_sheet.dart';
import 'widgets.dart';

/// La liste des conversations — l'écran d'accueil du jeu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.engine,
    required this.onDebugJump,
    required this.onExit,
  });

  final GameEngine engine;
  final ValueChanged<int> onDebugJump;

  /// Retour à l'écran d'accueil du téléphone.
  final VoidCallback onExit;

  void _showDebugMenu(BuildContext context) {
    final pal = Palette.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: pal.threadBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text(
              'MENU DEBUG — ALLER AU JOUR',
              style: TextStyle(
                color: pal.meta,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < kDayLabels.length; i++)
              ListTile(
                dense: true,
                leading: Text(
                  'J${i + 1}',
                  style: TextStyle(
                    color: pal.chev,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                title: Text(
                  kDayLabels[i],
                  style: TextStyle(color: pal.headText, fontSize: 15),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onDebugJump(i + 1);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

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
            GameClockBar(engine: engine),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onExit,
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: pal.chev, size: 22),
                    tooltip: 'Accueil',
                  ),
                  Expanded(
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
                  IconButton(
                    onPressed: () => _showDebugMenu(context),
                    icon: Icon(Icons.bug_report_outlined,
                        color: pal.meta, size: 22),
                    tooltip: 'Menu debug',
                  ),
                ],
              ),
            ),
            const _SelfCard(),
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

/// La carte « Ma fiche » — pour toujours savoir qui on est.
class _SelfCard extends StatelessWidget {
  const _SelfCard();

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Material(
        color: pal.inBubble.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => showSelfSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                const GradientAvatar(def: kShenDef, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shen Marchand',
                        style: TextStyle(
                          color: pal.headText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ma fiche',
                        style: TextStyle(color: pal.preview, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: pal.preview, size: 18),
              ],
            ),
          ),
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
    final def = thread.effectiveDef;
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
            GradientAvatar(def: def),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    def.name,
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
