import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';
import '../../core/phone_theme.dart';
import '../../providers/lock_notifications_provider.dart';
import '../../providers/phone_state_provider.dart';
import 'status_bar.dart';

/// Lock screen : grand wallpaper (gradient time-of-day), grosse horloge,
/// date, ligne de notifications, swipe vers le haut pour déverrouiller.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with SingleTickerProviderStateMixin {
  double _dragY = 0;

  void _onDragEnd(DragEndDetails d) {
    if (_dragY < -80) {
      HapticFeedback.mediumImpact();
      ref.read(phoneStateProvider.notifier).unlock();
    }
    setState(() => _dragY = 0);
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(phoneStateProvider);
    final palette = PhonePalette.forBand(p.band);
    final dayLabel = _frenchDay(p.currentDay);

    return GestureDetector(
      onVerticalDragUpdate: (d) =>
          setState(() => _dragY = (_dragY + d.delta.dy).clamp(-400, 0)),
      onVerticalDragEnd: _onDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.wallpaperTop, palette.wallpaperBottom],
          ),
        ),
        child: Transform.translate(
          offset: Offset(0, _dragY),
          child: SafeArea(
            child: Column(
              children: [
                PhoneStatusBar(foreground: palette.statusBarFg),
                const SizedBox(height: 30),
                // Date courte
                Text(
                  dayLabel.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: palette.statusBarFg.withOpacity(0.85),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                // Grande horloge
                Text(
                  p.timeLabel,
                  style: GoogleFonts.inter(
                    fontSize: 86,
                    fontWeight: FontWeight.w200,
                    color: palette.statusBarFg,
                    letterSpacing: -2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 22),
                // Météo compacte
                _LockScreenWidgets(palette: palette),
                const SizedBox(height: 14),
                // Pile de notifications (du plus récent au plus ancien)
                Expanded(
                  child: _NotificationsList(palette: palette),
                ),
                // Indicateur swipe up
                _SwipeUpHint(palette: palette),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _frenchDay(int dayIndex) {
    // J1 = vendredi 3 juin 2026 (canonique scenario).
    // DateTime n'a pas de constructeur const → final.
    final start = DateTime(2026, 6, 3);
    final d = start.add(Duration(days: dayIndex - 1));
    const jours = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche'
    ];
    const mois = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return '${jours[d.weekday - 1]} ${d.day} ${mois[d.month - 1]}';
  }
}

/// Bloc widget central du lock screen (météo + photo Maman placeholder).
/// Volontairement sobre en PR 1, sera enrichi en PR 3 (notifs).
class _LockScreenWidgets extends StatelessWidget {
  const _LockScreenWidgets({required this.palette});
  final PhonePalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.umbrella, color: palette.statusBarFg, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Belleville',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: palette.statusBarFg.withOpacity(0.85),
                  ),
                ),
                Text(
                  'Pluie · 13°',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: palette.statusBarFg,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pile de notifications iOS-like sur le lock screen.
class _NotificationsList extends ConsumerWidget {
  const _NotificationsList({required this.palette});
  final PhonePalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifs = ref.watch(lockNotificationsProvider);
    if (notifs.isEmpty) return const SizedBox.shrink();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: notifs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, i) => _NotifCard(n: notifs[i]),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.n});
  final LockNotif n;

  @override
  Widget build(BuildContext context) {
    AppMeta? meta;
    try {
      meta = appById(n.appId);
    } catch (_) {}
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: meta?.color ?? Colors.white24,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(meta?.icon ?? Icons.notifications,
                color: meta?.fgColor ?? Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      n.timeLabel,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  n.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.92),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Texte « Glisse vers le haut pour déverrouiller » animé.
class _SwipeUpHint extends StatefulWidget {
  const _SwipeUpHint({required this.palette});
  final PhonePalette palette;

  @override
  State<_SwipeUpHint> createState() => _SwipeUpHintState();
}

class _SwipeUpHintState extends State<_SwipeUpHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Opacity(
          opacity: 0.5 + 0.4 * _ctrl.value,
          child: Column(
            children: [
              Icon(Icons.keyboard_arrow_up,
                  color: widget.palette.statusBarFg, size: 22),
              Text(
                'Glisse pour déverrouiller',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: widget.palette.statusBarFg,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
