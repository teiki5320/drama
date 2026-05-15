import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/photos_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Photos — galerie regroupée par mois, filtrée par jour courant.
/// Pour l'instant les photos sont des placeholders gradient (les vraies
/// images seront générées plus tard si besoin).
class PhotosApp extends ConsumerStatefulWidget {
  const PhotosApp({super.key});

  @override
  ConsumerState<PhotosApp> createState() => _PhotosAppState();
}

class _PhotosAppState extends ConsumerState<PhotosApp> {
  /// 1, 3 ou 5 colonnes. Toggle via pinch (geste mobile) ou bouton
  /// segmenté en haut. Default 3 comme iOS.
  int _cols = 3;
  double _pinchStart = 1.0;

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final userPhotos =
        ref.watch(phoneStateProvider.select((s) => s.userPhotos));
    final canonVisible = kPhotos.where((p) => p.day <= day).toList();
    // Convertit les UserPhoto en PhotoItem pour l'affichage unifié.
    final userVisible = userPhotos.map((up) => PhotoItem(
          day: up.day,
          monthLabel: 'Juin · Caméra',
          title: 'Photo perso',
          subtitle: '📷 ${up.timeLabel} · ${up.caption}',
          gradient: up.gradient,
          isScreenshot: false,
        ));
    final visible = [...canonVisible, ...userVisible];

    // Group by month label
    final Map<String, List<PhotoItem>> byMonth = {};
    for (final p in visible) {
      byMonth.putIfAbsent(p.monthLabel, () => []).add(p);
    }

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
                      color: Color(0xFFFF6B6B), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  'Photos',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Icon(Icons.more_horiz, color: Colors.grey.shade400, size: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
            child: Row(
              children: [
                Text(
                  '${visible.length} photo${visible.length > 1 ? "s" : ""}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
                const Spacer(),
                _GridSwitcher(
                  cols: _cols,
                  onChange: (c) => setState(() => _cols = c),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onScaleStart: (_) {
                _pinchStart = _cols.toDouble();
              },
              onScaleUpdate: (d) {
                if (d.pointerCount < 2) return;
                // Pinch out (scale > 1) → moins de colonnes (zoom).
                // Pinch in (scale < 1) → plus de colonnes (vue d'ensemble).
                final target = (_pinchStart / d.scale).clamp(1.0, 5.0);
                int newCols;
                if (target < 1.8) {
                  newCols = 1;
                } else if (target < 4.0) {
                  newCols = 3;
                } else {
                  newCols = 5;
                }
                if (newCols != _cols) {
                  HapticFeedback.selectionClick();
                  setState(() => _cols = newCols);
                }
              },
              child: ListView(
                children: byMonth.entries.map((entry) {
                  return _MonthSection(
                    monthLabel: entry.key,
                    photos: entry.value,
                    cols: _cols,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridSwitcher extends StatelessWidget {
  const _GridSwitcher({required this.cols, required this.onChange});
  final int cols;
  final void Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [1, 3, 5].map((c) {
        final active = cols == c;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChange(c);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 6),
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: active ? Colors.white24 : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              c == 1
                  ? Icons.crop_din
                  : (c == 3 ? Icons.grid_view : Icons.grid_3x3),
              color: active ? Colors.white : Colors.white38,
              size: 16,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({
    required this.monthLabel,
    required this.photos,
    required this.cols,
  });
  final String monthLabel;
  final List<PhotoItem> photos;
  final int cols;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
            child: Text(
              monthLabel,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: photos.map((p) => _PhotoTile(photo: p)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo});
  final PhotoItem photo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => _PhotoFullView(photo: photo)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                photo.gradient.map((hex) => Color(hex)).toList(),
          ),
        ),
        child: Stack(
          children: [
            if (photo.isScreenshot)
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.photo_size_select_actual,
                    color: Colors.white70, size: 14),
              ),
            Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: Text(
                photo.title,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoFullView extends StatefulWidget {
  const _PhotoFullView({required this.photo});
  final PhotoItem photo;

  @override
  State<_PhotoFullView> createState() => _PhotoFullViewState();
}

class _PhotoFullViewState extends State<_PhotoFullView> {
  final _ctrl = TransformationController();
  String? _activeDetail;

  double get _scale => _ctrl.value.getMaxScaleOnAxis();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;
    final showHotspots = _scale > 1.4 && photo.hotspots.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // "Photo" = gradient, zoomable via InteractiveViewer
          Center(
            child: InteractiveViewer(
              transformationController: _ctrl,
              minScale: 1.0,
              maxScale: 4.0,
              clipBehavior: Clip.none,
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, c) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: photo.gradient
                                  .map((hex) => Color(hex))
                                  .toList(),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              photo.subtitle,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 36,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(color: Colors.black, blurRadius: 12),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (showHotspots)
                          for (final h in photo.hotspots)
                            Positioned(
                              left: h.x * c.maxWidth - 12,
                              top: h.y * c.maxHeight - 12,
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _activeDetail = h.detail);
                                },
                                child: const _PulseDot(),
                              ),
                            ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'J${photo.day}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      photo.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (_activeDetail != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Container(
                        key: ValueKey(_activeDetail),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white24, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.zoom_in,
                                color: Colors.white70, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _activeDetail!,
                                style: GoogleFonts.crimsonPro(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white70, size: 18),
                              onPressed: () =>
                                  setState(() => _activeDetail = null),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (photo.hotspots.isNotEmpty && !showHotspots)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Text(
                      'Zoome pour révéler ${photo.hotspots.length} détail${photo.hotspots.length > 1 ? "s" : ""}.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  child: Text(
                    photo.title,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 26,
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

/// Petit point pulsant indiquant un hotspot caché — visible quand on
/// zoome au-delà de 1.4x.
class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
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
      builder: (_, __) {
        final scale = 0.85 + 0.4 * _ctrl.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
