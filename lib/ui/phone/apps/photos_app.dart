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
class PhotosApp extends ConsumerWidget {
  const PhotosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final visible = kPhotos.where((p) => p.day <= day).toList();

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
            child: Text(
              '${visible.length} photo${visible.length > 1 ? "s" : ""}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: byMonth.entries.map((entry) {
                return _MonthSection(
                  monthLabel: entry.key,
                  photos: entry.value,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.monthLabel, required this.photos});
  final String monthLabel;
  final List<PhotoItem> photos;

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
              crossAxisCount: 3,
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

class _PhotoFullView extends StatelessWidget {
  const _PhotoFullView({required this.photo});
  final PhotoItem photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // "Photo" = gradient, zoomable via InteractiveViewer
          Center(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              clipBehavior: Clip.none,
              child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        photo.gradient.map((hex) => Color(hex)).toList(),
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
