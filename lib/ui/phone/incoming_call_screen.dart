import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/incoming_call_provider.dart';
import 'status_bar.dart';

/// Plein écran d'appel entrant style iPhone — fond sombre flouté,
/// gros nom, deux gros boutons rouge/vert. Vibre tant que l'appel
/// sonne, s'auto-coupe au bout de 12s si Shen ne décroche pas (et
/// laisse alors un appel manqué dans Téléphone).
class IncomingCallScreen extends ConsumerStatefulWidget {
  const IncomingCallScreen({super.key, required this.call});
  final IncomingCall call;

  @override
  ConsumerState<IncomingCallScreen> createState() =>
      _IncomingCallScreenState();
}

class _IncomingCallScreenState extends ConsumerState<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  Timer? _vibrate;
  Timer? _timeout;
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _vibrate = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      HapticFeedback.heavyImpact();
    });
    _timeout = Timer(const Duration(seconds: 12), _hangUp);
  }

  void _hangUp() {
    _vibrate?.cancel();
    _timeout?.cancel();
    ref.read(incomingCallProvider.notifier).state = null;
  }

  @override
  void dispose() {
    _vibrate?.cancel();
    _timeout?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.call;
    final avatarColor = Color(c.avatarColor);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0A0F), Color(0xFF1F1F2A)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const PhoneStatusBar(foreground: Colors.white),
            const SizedBox(height: 30),
            Text(
              'Appel entrant',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white70,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            // Avatar avec halo pulsant
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (context, child) {
                final t = _pulseCtrl.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Halo extérieur 1
                    Container(
                      width: 110 + 60 * t,
                      height: 110 + 60 * t,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: avatarColor
                            .withValues(alpha: (1 - t) * 0.25),
                      ),
                    ),
                    // Halo extérieur 2
                    Container(
                      width: 110 + 30 * t,
                      height: 110 + 30 * t,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: avatarColor
                            .withValues(alpha: (1 - t) * 0.40),
                      ),
                    ),
                    if (child != null) child,
                  ],
                );
              },
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: avatarColor.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  c.emoji,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),
            const SizedBox(height: 22),
            // Nom
            Text(
              c.masked ? 'Numéro masqué' : c.displayName,
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            if (c.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                c.subtitle!,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ],
            const Spacer(),
            // Boutons rouge / vert
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CallButton(
                    color: const Color(0xFFE53935),
                    icon: Icons.call_end,
                    label: 'Refuser',
                    onTap: _hangUp,
                  ),
                  _CallButton(
                    color: const Color(0xFF34C759),
                    icon: Icons.call,
                    label: 'Accepter',
                    onTap: _hangUp, // pour l'instant on hang-up aussi
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
