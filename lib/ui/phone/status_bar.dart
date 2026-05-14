import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/phone_state.dart';
import '../../providers/phone_state_provider.dart';

/// Barre d'état iOS-style : heure à gauche, signal/Wi-Fi/batterie à
/// droite. Réagit au PhoneState : l'heure défile, la batterie clignote
/// rouge sous 10 %, le signal change selon le contexte.
class PhoneStatusBar extends ConsumerWidget {
  const PhoneStatusBar({super.key, this.foreground});

  /// Couleur du texte (white sur wallpaper sombre, dark sur clair).
  final Color? foreground;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(phoneStateProvider);
    final fg = foreground ?? Colors.white;
    final batteryColor = p.battery <= 10 ? Colors.redAccent : fg;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              p.timeLabel,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: 0.2,
              ),
            ),
            Row(
              children: [
                _SignalIcon(signal: p.signal, color: fg),
                const SizedBox(width: 6),
                Icon(_signalLabelIcon(p.signal), size: 14, color: fg),
                const SizedBox(width: 6),
                _BatteryIcon(level: p.battery, color: batteryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static IconData _signalLabelIcon(SignalType s) {
    switch (s) {
      case SignalType.wifi:
        return Icons.wifi;
      case SignalType.fiveG:
        return Icons.signal_cellular_4_bar;
      case SignalType.lte:
        return Icons.signal_cellular_alt_2_bar;
      case SignalType.none:
        return Icons.signal_cellular_off;
    }
  }
}

/// Trois petites barres de signal (ou icône "no signal").
class _SignalIcon extends StatelessWidget {
  const _SignalIcon({required this.signal, required this.color});
  final SignalType signal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bars = switch (signal) {
      SignalType.wifi => 3,
      SignalType.fiveG => 3,
      SignalType.lte => 2,
      SignalType.none => 0,
    };
    return SizedBox(
      width: 18,
      height: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          final on = i < bars;
          return Container(
            width: 3,
            height: 4.0 + i * 2.5,
            decoration: BoxDecoration(
              color: on ? color : color.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(0.5),
            ),
          );
        }),
      ),
    );
  }
}

/// Icône batterie style iOS avec niveau rempli.
class _BatteryIcon extends StatelessWidget {
  const _BatteryIcon({required this.level, required this.color});
  final int level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$level',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 26,
          height: 12,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: color.withValues(alpha: 0.6)),
                ),
              ),
              Positioned(
                right: -3,
                top: 4,
                child: Container(
                  width: 2,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.6),
                    borderRadius:
                        const BorderRadius.horizontal(right: Radius.circular(1)),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (level / 100).clamp(0.05, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
