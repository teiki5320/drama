import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';
import '../../providers/app_tutorials_provider.dart';

/// Wrapper qui affiche un popup d'explication la **première fois** que
/// le joueur ouvre une app. Le popup recouvre l'app à 65 % d'opacité,
/// avec une carte centrale (titre + body + bouton « OK »). Une fois
/// fermé, l'id de l'app est ajouté au set `appsOpenedProvider`.
class AppTutorialOverlay extends ConsumerWidget {
  const AppTutorialOverlay({
    super.key,
    required this.appId,
    required this.child,
  });

  final String appId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opened = ref.watch(appsOpenedProvider);
    final tut = kAppTutorials[appId];
    final showTut = tut != null && !opened.contains(appId);

    return Stack(
      children: [
        child,
        if (showTut) _TutorialModal(appId: appId, tutorial: tut),
      ],
    );
  }
}

class _TutorialModal extends ConsumerStatefulWidget {
  const _TutorialModal({required this.appId, required this.tutorial});
  final String appId;
  final ({String title, String body}) tutorial;

  @override
  ConsumerState<_TutorialModal> createState() => _TutorialModalState();
}

class _TutorialModalState extends ConsumerState<_TutorialModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _close() async {
    HapticFeedback.lightImpact();
    await _ctrl.reverse();
    if (mounted) {
      await ref.read(appsOpenedProvider.notifier).markOpened(widget.appId);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppMeta? meta;
    try {
      meta = appById(widget.appId);
    } catch (_) {}
    return Positioned.fill(
      child: FadeTransition(
        opacity: _ctrl,
        child: Container(
          color: Colors.black.withValues(alpha: 0.65),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ScaleTransition(
                scale:
                    Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(
                  parent: _ctrl,
                  curve: Curves.easeOutBack,
                )),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.30),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (meta != null)
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: meta.color,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(meta.icon,
                                  color: meta.fgColor, size: 26),
                            ),
                          if (meta != null) const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              widget.tutorial.title,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.tutorial.body,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF3A3A3A),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _close,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'OK, j\'ai compris',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
