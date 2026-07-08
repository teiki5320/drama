import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/map_places.dart';
import '../../../models/map_place.dart';
import '../../../providers/map_visits_provider.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Plans — carte stylisée de Paris avec les lieux visités et
/// révélés. Pins par catégorie (Heng / Maman / Camille / Restaurant /
/// Client / Collision / etc.). Tap pin → bottom sheet détail.
///
/// Pas de tuiles réelles : on dessine Paris en CustomPainter avec la
/// Seine, quelques arrondissements clés, et on projete (lat, lng) sur
/// le canvas. Auto-sync depuis UberEats stats : course livrée = visite.
class PlansApp extends ConsumerStatefulWidget {
  const PlansApp({super.key});

  @override
  ConsumerState<PlansApp> createState() => _PlansAppState();
}

class _PlansAppState extends ConsumerState<PlansApp> {
  Set<PlaceCategory> _activeCategories = PlaceCategory.values.toSet();
  bool _showStats = false;

  @override
  void initState() {
    super.initState();
    // Force le sync auto au build initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapVisitsAutoSyncProvider);
    });
  }

  void _toggleCategory(PlaceCategory cat) {
    setState(() {
      if (_activeCategories.contains(cat)) {
        _activeCategories.remove(cat);
      } else {
        _activeCategories.add(cat);
      }
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final visiblePlaces = ref.watch(visiblePlacesProvider(day));
    final filtered = visiblePlaces
        .where((p) => _activeCategories.contains(p.category))
        .toList();
    final visits = ref.watch(mapVisitsProvider);
    final stats = ref.watch(mapStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF34A853), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text(
                  'Plans',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_showStats ? Icons.map : Icons.bar_chart,
                      color: const Color(0xFF34A853)),
                  onPressed: () =>
                      setState(() => _showStats = !_showStats),
                ),
              ],
            ),
          ),
          if (_showStats)
            Expanded(child: _StatsView(stats: stats))
          else
            Expanded(
              child: Stack(
                children: [
                  // Carte
                  Positioned.fill(
                    child: GestureDetector(
                      onTapUp: (details) {
                        final pin = _findPinAt(
                          details.localPosition,
                          context.size ?? Size.zero,
                          filtered,
                          visits,
                        );
                        if (pin != null) {
                          _showPlaceSheet(context, pin, visits);
                        }
                      },
                      child: CustomPaint(
                        painter: _ParisMapPainter(
                          places: filtered,
                          visited: visits.visitedPlaceIds,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  // Filtres en bas
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: _CategoryFilterBar(
                      active: _activeCategories,
                      onToggle: _toggleCategory,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  MapPlace? _findPinAt(
    Offset tap,
    Size canvasSize,
    List<MapPlace> places,
    MapVisitsState visits,
  ) {
    // On reprojette chaque pin et on cherche le plus proche dans
    // un rayon de 24 px.
    final size = canvasSize;
    for (final p in places) {
      final pt = _projectLatLng(p.lat, p.lng, size);
      if ((tap - pt).distance < 24) return p;
    }
    return null;
  }

  void _showPlaceSheet(BuildContext context, MapPlace p, MapVisitsState visits) {
    HapticFeedback.selectionClick();
    final visited = visits.visitedPlaceIds.contains(p.id);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color(colorForCategory(p.category))
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child:
                        Text(p.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          p.address,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: visited
                          ? const Color(0xFF34A853).withValues(alpha: 0.15)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      visited ? 'Visité' : 'Repéré',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: visited
                            ? const Color(0xFF34A853)
                            : Colors.grey.shade600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(colorForCategory(p.category))
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  labelForCategory(p.category),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(colorForCategory(p.category)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                p.detail,
                style: GoogleFonts.crimsonPro(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF1A1A1A),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView({required this.stats});
  final MapStats stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lieux',
            style: GoogleFonts.crimsonPro(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _StatRow(
            label: 'Lieux visités',
            value: '${stats.placesVisited} / ${stats.placesTotal}',
          ),
          _StatRow(
            label: 'Distance parcourue',
            value: '${stats.kmTotal.toStringAsFixed(1)} km',
          ),
          const SizedBox(height: 20),
          Text(
            'Par catégorie',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...stats.visitsPerCategory.entries.map(
            (e) => _StatRow(
              label: labelForCategory(e.key),
              value: '${e.value}',
              dotColor: Color(colorForCategory(e.key)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.dotColor});
  final String label;
  final String value;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (dotColor != null) ...[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.active,
    required this.onToggle,
  });
  final Set<PlaceCategory> active;
  final void Function(PlaceCategory) onToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: PlaceCategory.values.map((cat) {
          final isActive = active.contains(cat);
          final color = Color(colorForCategory(cat));
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onToggle(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? color : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive ? color : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  labelForCategory(cat),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Projection lat/lng → canvas ─────────────────────────────────

/// Paris bounding box approximative.
const _kLatMin = 48.815;
const _kLatMax = 48.905;
const _kLngMin = 2.225;
const _kLngMax = 2.420;

Offset _projectLatLng(double lat, double lng, Size canvasSize) {
  final x = (lng - _kLngMin) / (_kLngMax - _kLngMin) * canvasSize.width;
  final y = (1.0 - (lat - _kLatMin) / (_kLatMax - _kLatMin)) *
      canvasSize.height;
  return Offset(x, y);
}

// ─── Custom painter ─────────────────────────────────────────────

class _ParisMapPainter extends CustomPainter {
  _ParisMapPainter({required this.places, required this.visited});
  final List<MapPlace> places;
  final Set<String> visited;

  @override
  void paint(Canvas canvas, Size size) {
    // ── Fond crème ─────────────────────────────────────────────
    final bgPaint = Paint()..color = const Color(0xFFF2EFE8);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // ── Bois (Boulogne ouest, Vincennes est) ───────────────────
    final boisPaint = Paint()
      ..color = const Color(0xFFC8D8B8).withValues(alpha: 0.55);
    canvas.drawCircle(
        _projectLatLng(48.866, 2.247, size), 38, boisPaint);
    canvas.drawCircle(
        _projectLatLng(48.842, 2.435, size), 34, boisPaint);

    // ── Périphérique (cercle complet doux) ─────────────────────
    final periph = Paint()
      ..color = const Color(0xFFB8B4AA).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final periphCenter = _projectLatLng(48.857, 2.348, size);
    final periphRect = Rect.fromCenter(
      center: periphCenter,
      width: size.width * 0.92,
      height: size.height * 0.78,
    );
    canvas.drawOval(periphRect, periph);

    // ── 20 arrondissements (zones beiges très subtiles) ────────
    final arrPaint = Paint()
      ..color = const Color(0xFFE8E0CE).withValues(alpha: 0.45);
    // Centre 1er-4e (collés autour de la Seine)
    canvas.drawCircle(_projectLatLng(48.860, 2.341, size), 22, arrPaint);
    // 5e-6e rive gauche
    canvas.drawCircle(_projectLatLng(48.847, 2.345, size), 24, arrPaint);
    canvas.drawCircle(_projectLatLng(48.851, 2.333, size), 22, arrPaint);
    // 7e (Invalides)
    canvas.drawCircle(_projectLatLng(48.857, 2.317, size), 24, arrPaint);
    // 8e (Champs)
    canvas.drawCircle(_projectLatLng(48.873, 2.310, size), 30, arrPaint);
    // 9e (Opéra)
    canvas.drawCircle(_projectLatLng(48.876, 2.337, size), 22, arrPaint);
    // 10e (Gares)
    canvas.drawCircle(_projectLatLng(48.876, 2.361, size), 24, arrPaint);
    // 11e (Bastille / République)
    canvas.drawCircle(_projectLatLng(48.860, 2.380, size), 30, arrPaint);
    // 12e (Vincennes ouest)
    canvas.drawCircle(_projectLatLng(48.840, 2.395, size), 28, arrPaint);
    // 13e (Choisy)
    canvas.drawCircle(_projectLatLng(48.828, 2.362, size), 28, arrPaint);
    // 14e (Montparnasse)
    canvas.drawCircle(_projectLatLng(48.832, 2.326, size), 26, arrPaint);
    // 15e
    canvas.drawCircle(_projectLatLng(48.842, 2.298, size), 30, arrPaint);
    // 8e (Berri)
    canvas.drawCircle(_projectLatLng(48.860, 2.275, size), 32, arrPaint);
    // 17e
    canvas.drawCircle(_projectLatLng(48.886, 2.305, size), 26, arrPaint);
    // 18e (Montmartre)
    canvas.drawCircle(_projectLatLng(48.888, 2.343, size), 28, arrPaint);
    // 19e
    canvas.drawCircle(_projectLatLng(48.886, 2.382, size), 28, arrPaint);
    // 20e (Belleville)
    canvas.drawCircle(_projectLatLng(48.870, 2.395, size), 28, arrPaint);

    // ── La Seine (multi-courbes plus précises) ─────────────────
    final seinePaint = Paint()
      ..color = const Color(0xFF8FB4D2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final seine = Path();
    Offset s(double lat, double lng) => _projectLatLng(lat, lng, size);
    seine.moveTo(s(48.832, 2.420).dx, s(48.832, 2.420).dy);
    seine.cubicTo(
      s(48.840, 2.395).dx, s(48.840, 2.395).dy,
      s(48.850, 2.380).dx, s(48.850, 2.380).dy,
      s(48.852, 2.359).dx, s(48.852, 2.359).dy,
    );
    seine.cubicTo(
      s(48.857, 2.347).dx, s(48.857, 2.347).dy,
      s(48.858, 2.334).dx, s(48.858, 2.334).dy,
      s(48.860, 2.323).dx, s(48.860, 2.323).dy,
    );
    seine.cubicTo(
      s(48.865, 2.310).dx, s(48.865, 2.310).dy,
      s(48.864, 2.296).dx, s(48.864, 2.296).dy,
      s(48.860, 2.280).dx, s(48.860, 2.280).dy,
    );
    seine.cubicTo(
      s(48.855, 2.270).dx, s(48.855, 2.270).dy,
      s(48.848, 2.260).dx, s(48.848, 2.260).dy,
      s(48.842, 2.235).dx, s(48.842, 2.235).dy,
    );
    canvas.drawPath(seine, seinePaint);

    // ── Axes principaux ────────────────────────────────────────
    final axePaint = Paint()
      ..color = const Color(0xFFD0CBC0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final axeMinor = Paint()
      ..color = const Color(0xFFD8D2C5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Champs-Élysées (Concorde → Étoile)
    canvas.drawLine(s(48.865, 2.321), s(48.873, 2.295), axePaint);
    // rue de Berri (Champs-Élysées → Haussmann)
    canvas.drawLine(s(48.873, 2.295), s(48.872, 2.275), axePaint);
    // Avenue de la Grande Armée (Étoile → Neuilly)
    canvas.drawLine(s(48.873, 2.295), s(48.881, 2.282), axeMinor);
    // Rue de Rivoli (Concorde → Bastille)
    canvas.drawLine(s(48.865, 2.321), s(48.853, 2.369), axeMinor);
    // Bd Haussmann (Saint-Lazare → Opéra)
    canvas.drawLine(s(48.876, 2.325), s(48.876, 2.355), axeMinor);
    // Bd de Sébastopol
    canvas.drawLine(s(48.860, 2.350), s(48.873, 2.351), axeMinor);
    // Bd Magenta (République → Nord)
    canvas.drawLine(s(48.867, 2.363), s(48.880, 2.355), axeMinor);
    // Bd Saint-Germain
    canvas.drawLine(s(48.853, 2.323), s(48.851, 2.358), axeMinor);
    // Bd de Belleville
    canvas.drawLine(s(48.871, 2.378), s(48.872, 2.391), axeMinor);
    // Boulevard du Montparnasse
    canvas.drawLine(s(48.842, 2.323), s(48.842, 2.336), axeMinor);

    // ── Places principales (cercle gris) ───────────────────────
    void place(double lat, double lng, double r) {
      canvas.drawCircle(
        s(lat, lng),
        r,
        Paint()..color = const Color(0xFFD0CBC0),
      );
    }
    place(48.873, 2.295, 7);  // Étoile
    place(48.865, 2.321, 6);  // Concorde
    place(48.867, 2.363, 5);  // République
    place(48.853, 2.369, 5);  // Bastille
    place(48.876, 2.355, 4);  // Opéra
    place(48.842, 2.321, 4);  // Montparnasse
    place(48.880, 2.355, 4);  // Gare du Nord

    // ── Gares (petits carrés) ──────────────────────────────────
    void gare(double lat, double lng) {
      final rect = Rect.fromCenter(
          center: s(lat, lng), width: 6, height: 6);
      canvas.drawRect(rect, Paint()..color = const Color(0xFF8B6F47));
    }
    gare(48.880, 2.355);  // Nord
    gare(48.876, 2.359);  // Est
    gare(48.876, 2.325);  // Saint-Lazare
    gare(48.844, 2.374);  // Lyon
    gare(48.842, 2.321);  // Montparnasse

    // Pins par catégorie (visités = pleins, repérés = creux)
    for (final p in places) {
      final isVisited = visited.contains(p.id);
      final color = Color(colorForCategory(p.category));
      final pt = _projectLatLng(p.lat, p.lng, size);
      // Cercle externe (halo)
      canvas.drawCircle(
        pt,
        12,
        Paint()..color = color.withValues(alpha: 0.18),
      );
      // Cercle plein ou creux
      canvas.drawCircle(
        pt,
        8,
        Paint()
          ..color = isVisited ? color : Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        pt,
        8,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      // Pour les lieux spéciaux (collision), ajoute un anneau marqueur
      if (p.category == PlaceCategory.collision ||
          p.category == PlaceCategory.heng) {
        canvas.drawCircle(
          pt,
          16,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // ── Labels arrondissements numérotés ──────────────────────
    void arr(int n, double lat, double lng) {
      final tp = TextPainter(
        text: TextSpan(
          text: '${n}e',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final pt = _projectLatLng(lat, lng, size);
      tp.paint(canvas, Offset(pt.dx - tp.width / 2, pt.dy - tp.height / 2));
    }
    arr(1, 48.860, 2.341);
    arr(2, 48.866, 2.343);
    arr(3, 48.862, 2.362);
    arr(4, 48.857, 2.360);
    arr(5, 48.846, 2.349);
    arr(6, 48.851, 2.333);
    arr(7, 48.857, 2.317);
    arr(8, 48.873, 2.310);
    arr(9, 48.876, 2.337);
    arr(10, 48.876, 2.361);
    arr(11, 48.860, 2.380);
    arr(12, 48.840, 2.395);
    arr(13, 48.828, 2.362);
    arr(14, 48.832, 2.326);
    arr(15, 48.842, 2.298);
    arr(16, 48.860, 2.275);
    arr(17, 48.886, 2.305);
    arr(18, 48.888, 2.343);
    arr(19, 48.886, 2.382);
    arr(20, 48.870, 2.395);

    // ── Noms de quartiers en filigrane ────────────────────────
    void quartier(String name, double lat, double lng) {
      final tp = TextPainter(
        text: TextSpan(
          text: name,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 7,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final pt = _projectLatLng(lat, lng, size);
      tp.paint(canvas, Offset(pt.dx - tp.width / 2, pt.dy + 8));
    }
    quartier('Belleville', 48.870, 2.395);
    quartier('Berri', 48.873, 2.302);
    quartier('Marais', 48.860, 2.362);
    quartier('Bastille', 48.853, 2.378);
    quartier('Montmartre', 48.886, 2.342);
    quartier('Montparnasse', 48.838, 2.323);
    quartier('Saint-Germain', 48.853, 2.334);
    quartier('Champs-Élysées', 48.871, 2.305);
    quartier('Pigalle', 48.882, 2.336);

    // ── Bois (labels) ─────────────────────────────────────────
    quartier('Bois de Boulogne', 48.866, 2.247);
    quartier('Vincennes', 48.842, 2.435);

    // Label « PARIS » dans un coin
    final labelPainter = TextPainter(
      text: TextSpan(
        text: 'PARIS',
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 10,
          letterSpacing: 6,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset(16, size.height - 70));

    // Boussole simple en haut à droite
    final compassCenter = Offset(size.width - 26, 26);
    canvas.drawCircle(
      compassCenter,
      14,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      compassCenter,
      14,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke,
    );
    final compassPath = Path()
      ..moveTo(compassCenter.dx, compassCenter.dy - 10)
      ..lineTo(compassCenter.dx - 3, compassCenter.dy + 4)
      ..lineTo(compassCenter.dx, compassCenter.dy + 1)
      ..lineTo(compassCenter.dx + 3, compassCenter.dy + 4)
      ..close();
    canvas.drawPath(compassPath,
        Paint()..color = const Color(0xFFFD297B));
  }

  @override
  bool shouldRepaint(_ParisMapPainter old) =>
      old.places.length != places.length ||
      old.visited.length != visited.length;
}

