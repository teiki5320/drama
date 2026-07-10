import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/relationship.dart';
import '../../providers/call_log_provider.dart';
import '../../providers/incoming_call_provider.dart';
import '../../providers/phone_state_provider.dart';
import '../../providers/relationships_provider.dart';
import 'status_bar.dart';

/// Plein écran d'appel entrant style iPhone — fond sombre flouté,
/// gros nom, deux gros boutons rouge/vert. Vibre tant que l'appel
/// sonne, s'auto-coupe au bout de 18s si Shen ne décroche pas (et
/// laisse alors un appel manqué dans Téléphone). Décrocher passe en
/// mode « en ligne » : chrono + transcript de l'appelant ligne à ligne.
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
  // — état « en ligne » après décrochage —
  bool _accepted = false;
  int _seconds = 0;
  int _visibleLines = 0;
  Timer? _chrono;
  Timer? _lines;
  Timer? _autoEnd;
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
    _timeout = Timer(const Duration(seconds: 18), _hangUp);
  }

  /// Décroche : arrête la sonnerie, lance le chrono et fait défiler
  /// le transcript de l'appelant ligne à ligne. L'appelant raccroche
  /// tout seul quelques secondes après sa dernière phrase (ou presque
  /// tout de suite s'il n'a rien à dire — appel masqué).
  bool _logged = false;

  void _accept() {
    _vibrate?.cancel();
    _timeout?.cancel();
    HapticFeedback.mediumImpact();
    setState(() => _accepted = true);
    // Conséquences : décrocher rassure l'appelant (une seule fois).
    final callerId = widget.call.callerId;
    if (callerId != null && !_logged) {
      ref
          .read(relationshipsProvider.notifier)
          .apply(callerId, const RelationshipDelta(trust: 4));
    }
    _chrono = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    final lines = widget.call.transcript;
    if (lines.isEmpty) {
      _autoEnd = Timer(const Duration(seconds: 4), _hangUp);
      return;
    }
    _lines = Timer.periodic(const Duration(milliseconds: 2600), (t) {
      if (!mounted) return;
      if (_visibleLines < lines.length) {
        setState(() => _visibleLines++);
      } else {
        t.cancel();
        _autoEnd = Timer(const Duration(seconds: 3), _hangUp);
      }
    });
  }

  void _hangUp() {
    _vibrate?.cancel();
    _timeout?.cancel();
    _chrono?.cancel();
    _lines?.cancel();
    _autoEnd?.cancel();
    // Trace + conséquences (une seule fois par appel).
    if (!_logged) {
      _logged = true;
      final p = ref.read(phoneStateProvider);
      final callerId = widget.call.callerId;
      if (!_accepted && callerId != null) {
        // Ignorer/refuser l'appel de Maman à 4h du matin a un prix.
        ref.read(relationshipsProvider.notifier).apply(
            callerId, const RelationshipDelta(trust: -3, suspicion: 6));
      }
      ref.read(callLogProvider.notifier).log(DynamicCall(
            day: p.currentDay,
            time: p.timeLabel,
            label: widget.call.masked
                ? 'Numéro masqué'
                : widget.call.displayName,
            kind: _accepted ? 'accepted' : 'missed',
            durationLabel: _accepted ? _chronoLabel : '0:00',
            transcript: _accepted && widget.call.transcript.isNotEmpty
                ? widget.call.transcript.join('\n')
                : null,
          ));
    }
    ref.read(incomingCallProvider.notifier).state = null;
  }

  @override
  void dispose() {
    _vibrate?.cancel();
    _timeout?.cancel();
    _chrono?.cancel();
    _lines?.cancel();
    _autoEnd?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String get _chronoLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
              _accepted ? _chronoLabel : 'Appel entrant',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white70,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            // Avatar avec halo pulsant (immobile une fois en ligne)
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (context, child) {
                final t = _accepted ? 0.0 : _pulseCtrl.value;
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
            // En ligne : les phrases de l'appelant apparaissent une à une.
            if (_accepted)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 28, 36, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _visibleLines; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              c.transcript[i],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      if (_visibleLines == 0)
                        Text(
                          '…',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            color: Colors.white38,
                          ),
                        ),
                    ],
                  ),
                ),
              )
            else
              const Spacer(),
            // Boutons : rouge/vert qui sonne, rouge seul en ligne.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: _accepted
                  ? Center(
                      child: _CallButton(
                        color: const Color(0xFFE53935),
                        icon: Icons.call_end,
                        label: 'Raccrocher',
                        onTap: _hangUp,
                      ),
                    )
                  : Row(
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
                          onTap: _accept,
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
