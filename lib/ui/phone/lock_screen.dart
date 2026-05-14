import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_theme.dart';
import '../../models/phone_state.dart';
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
                const SizedBox(height: 30),
                // Espace réservé aux notifications (vide en PR 1)
                Expanded(
                  child: Center(
                    child: _LockScreenWidgets(palette: palette),
                  ),
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
