import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/episode.dart';
import '../../providers/transition_provider.dart';

/// Écran de transition entre deux beats — fond noir, serif italique
/// blanc qui fade in, reste ~3.5s, puis fade out. Sert à raconter ce
/// que Shen vit pendant le saut de temps (collision, contrat signé,
/// arrivée à un dîner…).
///
/// Le joueur peut tapper l'écran pour passer plus vite.
class TransitionScreen extends ConsumerStatefulWidget {
  const TransitionScreen({super.key, required this.transition});
  final BeatTransition transition;

  @override
  ConsumerState<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends ConsumerState<TransitionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final AnimationController _typeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  Timer? _autoClose;

  void _start() {
    HapticFeedback.lightImpact();
    _fadeCtrl.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _typeCtrl.forward(from: 0);
    });
    // Auto-close après ~4.5s total (fade-in 700 + lecture 3500 + close 300).
    _autoClose?.cancel();
    _autoClose = Timer(const Duration(milliseconds: 5200), _close);
  }

  @override
  void didUpdateWidget(covariant TransitionScreen old) {
    super.didUpdateWidget(old);
    // Une nouvelle transition remplace l'ancienne dans le même State :
    // sans reset, le timer de la 1re écourtait la 2e.
    if (old.transition != widget.transition) _start();
  }

  void _close() async {
    if (!mounted) return;
    await _fadeCtrl.reverse();
    if (mounted) {
      ref.read(beatTransitionProvider.notifier).state = null;
    }
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    _fadeCtrl.dispose();
    _typeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _close,
      child: FadeTransition(
        opacity: _fadeCtrl,
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Timestamp en haut, blanc tamisé
                  AnimatedBuilder(
                    animation: _typeCtrl,
                    builder: (_, __) {
                      final t = _typeCtrl.value;
                      final visible = t > 0.1;
                      return AnimatedOpacity(
                        opacity: visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          widget.transition.timestamp,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.65),
                            letterSpacing: 3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  // Corps texte serif italique blanc, ligne par ligne
                  AnimatedBuilder(
                    animation: _typeCtrl,
                    builder: (_, __) {
                      final lines = widget.transition.body.split('\n');
                      final t = _typeCtrl.value;
                      return Column(
                        children: List.generate(lines.length, (i) {
                          // Chaque ligne apparaît à i/n + un peu de marge
                          final start = (i + 1) / (lines.length + 2);
                          final lineT =
                              ((t - start) / 0.15).clamp(0.0, 1.0);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AnimatedOpacity(
                              opacity: lineT,
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                lines[i],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.crimsonPro(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  height: 1.45,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  if (widget.transition.coda != null) ...[
                    const SizedBox(height: 28),
                    AnimatedBuilder(
                      animation: _typeCtrl,
                      builder: (_, __) {
                        final t = _typeCtrl.value;
                        final visible = t > 0.85;
                        return AnimatedOpacity(
                          opacity: visible ? 0.55 : 0.0,
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            widget.transition.coda!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.crimsonPro(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              height: 1.4,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  const Spacer(flex: 3),
                  // Hint « tape pour passer »
                  Opacity(
                    opacity: 0.30,
                    child: Text(
                      'tape pour passer',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
