import 'package:flutter/material.dart';

import '../engine.dart';
import '../palette.dart';
import 'widgets.dart';

/// L'écran d'identité, juste après le déverrouillage :
/// trois secondes pour savoir qui on est.
class IntroCard extends StatefulWidget {
  const IntroCard({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<IntroCard> createState() => _IntroCardState();
}

class _IntroCardState extends State<IntroCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onDone,
      child: Container(
        color: const Color(0xFF0B0E1A),
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DRAMA',
                style: TextStyle(
                  color: Palette.brandColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                ),
              ),
              SizedBox(height: 28),
              GradientAvatar(def: kShenDef, size: 128),
              SizedBox(height: 18),
              Text(
                'Shen Marchand',
                style: TextStyle(
                  color: Color(0xFFF4F5FA),
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '24 ans — livreuse à vélo, Paris',
                style: TextStyle(
                  color: Color(0xB3F4F5FA),
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 22),
              Text(
                'Ce téléphone est le tien.',
                style: TextStyle(
                  color: Color(0xFFF4F5FA),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
