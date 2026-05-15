import 'package:flutter/material.dart';

/// Cadre iPhone-like qui ne s'active que sur écrans larges (iPad,
/// desktop). Sur iPhone, l'app remplit l'écran comme avant.
///
/// Sur iPad : on dessine un faux téléphone centré (390 × 844 px, coins
/// arrondis 56 px, bord noir 6 px, Dynamic Island en haut). Le fond
/// hors-cadre est sombre, comme si le téléphone reposait sur un bureau.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child});
  final Widget child;

  /// Largeur seuil au-dessus de laquelle on dessine le cadre.
  static const double _threshold = 500;

  /// Dimensions iPhone 15 Pro (ratio 9:19.5).
  static const double _phoneWidth = 390;
  static const double _phoneHeight = 844;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Sur iPhone : pas de frame, on rend tel quel.
    if (size.width < _threshold) {
      return child;
    }

    // Sur iPad / desktop : on calcule la plus grande taille de phone
    // qui rentre dans l'écran (avec marge), en gardant l'aspect 9:19.5.
    final maxH = size.height - 80;
    final maxW = size.width - 80;
    final aspect = _phoneWidth / _phoneHeight;
    var w = maxW.clamp(280.0, _phoneWidth * 1.3);
    var h = w / aspect;
    if (h > maxH) {
      h = maxH;
      w = h * aspect;
    }

    return Container(
      color: const Color(0xFF0E0E10), // fond sombre type bureau
      alignment: Alignment.center,
      child: SizedBox(
        width: w + 12, // +12 pour la bordure
        height: h + 12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Bord extérieur du téléphone (alu/titane)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A2A2D), Color(0xFF1A1A1D)],
                ),
                borderRadius: BorderRadius.circular(58),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Écran (clip arrondi)
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(52),
                child: Stack(
                  children: [
                    SizedBox(width: w, height: h, child: child),
                    // Dynamic Island en haut au centre
                    Positioned(
                      top: 11,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 110,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
