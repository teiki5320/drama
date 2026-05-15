import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/phone_state.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// Caméra — mode « mémoire » : pas de vraie image, juste un placeholder
/// gradient + emoji généré côté code selon l'heure / le mood. Permet à
/// Shen de prendre des photos non-canon entre les moments scriptés.
class CameraApp extends ConsumerStatefulWidget {
  const CameraApp({super.key});

  @override
  ConsumerState<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends ConsumerState<CameraApp>
    with TickerProviderStateMixin {
  late final AnimationController _flashCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  late final AnimationController _shutterCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  UserPhoto? _lastTaken;

  @override
  void dispose() {
    _flashCtrl.dispose();
    _shutterCtrl.dispose();
    super.dispose();
  }

  void _shoot() async {
    HapticFeedback.heavyImpact();
    _flashCtrl.forward(from: 0);
    _shutterCtrl.forward(from: 0);
    final photo = ref.read(phoneStateProvider.notifier).takePhoto();
    setState(() => _lastTaken = photo);
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(phoneStateProvider);
    final isNight = p.hour >= 20 || p.hour < 6;
    final viewfinderGradient = isNight
        ? const [Color(0xFF0A0E1F), Color(0xFF1A1E33)]
        : const [Color(0xFF3A4555), Color(0xFF6B7385)];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text(
                  'Caméra',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.flash_auto, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.flip_camera_ios, color: Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 0.7,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: viewfinderGradient,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Grille de cadrage
                      const Positioned.fill(child: _RuleOfThirds()),
                      // Heure courante en haut à droite
                      Positioned(
                        top: 12,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            p.timeLabel,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Lieu / contexte
                      Positioned(
                        bottom: 12,
                        left: 14,
                        child: Text(
                          isNight
                              ? 'Belleville · nuit'
                              : 'Belleville · jour',
                          style: GoogleFonts.crimsonPro(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                      // Flash blanc à la prise de photo
                      AnimatedBuilder(
                        animation: _flashCtrl,
                        builder: (_, __) {
                          if (_flashCtrl.value == 0) {
                            return const SizedBox.shrink();
                          }
                          return Positioned.fill(
                            child: Container(
                              color: Colors.white.withValues(
                                  alpha: 1 - _flashCtrl.value),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Vignette dernière photo + déclencheur + compteur
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LastPhotoVignette(photo: _lastTaken ?? (p.userPhotos.isNotEmpty ? p.userPhotos.last : null)),
                GestureDetector(
                  onTap: _shoot,
                  child: AnimatedBuilder(
                    animation: _shutterCtrl,
                    builder: (context, child) {
                      // Anim physique : punch in (scale 1→0.85→1) +
                      // l'iris intérieur se referme/rouvre.
                      final t = _shutterCtrl.value;
                      final scale = t == 0
                          ? 1.0
                          : (1.0 - 0.15 * (1 - (2 * t - 1).abs()));
                      final irisScale = t == 0
                          ? 1.0
                          : (1.0 - 0.4 * (1 - (2 * t - 1).abs()));
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 68,
                          height: 68,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 3),
                          ),
                          child: Center(
                            child: Transform.scale(
                              scale: irisScale,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text(
                    '${p.userPhotos.length}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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

class _RuleOfThirds extends StatelessWidget {
  const _RuleOfThirds();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 0.5;
    final w = size.width;
    final h = size.height;
    canvas.drawLine(Offset(w / 3, 0), Offset(w / 3, h), paint);
    canvas.drawLine(Offset(2 * w / 3, 0), Offset(2 * w / 3, h), paint);
    canvas.drawLine(Offset(0, h / 3), Offset(w, h / 3), paint);
    canvas.drawLine(Offset(0, 2 * h / 3), Offset(w, 2 * h / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LastPhotoVignette extends StatelessWidget {
  const _LastPhotoVignette({required this.photo});
  final UserPhoto? photo;

  @override
  Widget build(BuildContext context) {
    if (photo == null) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.photo_library_outlined,
            color: Colors.white54, size: 22),
      );
    }
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: photo!.imagePath == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: photo!.gradient.map((h) => Color(h)).toList(),
              )
            : null,
        image: photo!.imagePath != null
            ? DecorationImage(
                image: AssetImage(photo!.imagePath!),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      alignment: Alignment.center,
      child: photo!.imagePath != null
          ? null
          : Text(
        photo!.emoji,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}
