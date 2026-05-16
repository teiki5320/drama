import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/epilogues.dart';

/// Écran plein écran qui affiche un épilogue à la fin de la partie (J112).
/// Texte en serif italique, fond palette, fade-in progressif par paragraphe.
class EpilogueScreen extends StatefulWidget {
  const EpilogueScreen({super.key, required this.epilogue, this.onClose});
  final Epilogue epilogue;
  final VoidCallback? onClose;

  @override
  State<EpilogueScreen> createState() => _EpilogueScreenState();
}

class _EpilogueScreenState extends State<EpilogueScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final AnimationController _coda = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    _fade.forward();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) _coda.forward();
    });
  }

  @override
  void dispose() {
    _fade.dispose();
    _coda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.epilogue.colorHex);
    final paragraphs = widget.epilogue.body.split('\n\n');
    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            if (widget.onClose != null) widget.onClose!();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header : épisode + emoji
                Row(
                  children: [
                    Text(widget.epilogue.emoji,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Text(
                      'ÉPILOGUE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FadeTransition(
                  opacity: _fade,
                  child: Text(
                    widget.epilogue.title,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FadeTransition(
                  opacity: _fade,
                  child: Text(
                    widget.epilogue.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Corps : paragraphes serif italique
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < paragraphs.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: AnimatedBuilder(
                              animation: _fade,
                              builder: (context, _) {
                                final t = ((_fade.value - i * 0.15) /
                                        (1.0 - i * 0.15))
                                    .clamp(0.0, 1.0);
                                return Opacity(
                                  opacity: t,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - t) * 8),
                                    child: Text(
                                      paragraphs[i],
                                      style: GoogleFonts.crimsonPro(
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                        height: 1.55,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _coda,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 4),
                    child: Text(
                      widget.epilogue.coda,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _coda,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Center(
                      child: Text(
                        'Tap pour fermer',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.5),
                          letterSpacing: 1.5,
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
    );
  }
}
