import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mood_overlay.dart';
import '../../core/phone_apps.dart';
import '../../core/phone_theme.dart';
import '../../providers/phone_state_provider.dart';
import 'app_icon.dart';
import 'spotlight_search.dart';
import 'status_bar.dart';
import 'widgets/home_widgets.dart';

/// Home screen iOS-like : status bar, ligne de widgets, grille d'apps,
/// dock du bas. Le wallpaper change selon l'heure du jeu et se décale
/// avec parallax léger quand on scroll la grille.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _gridScroll = ScrollController();
  double _parallaxY = 0;

  @override
  void initState() {
    super.initState();
    _gridScroll.addListener(() {
      // Décalage du wallpaper de -16 à +16 px max selon le scroll.
      final off = (_gridScroll.offset / 8).clamp(-16.0, 16.0);
      if ((off - _parallaxY).abs() > 0.5) {
        setState(() => _parallaxY = -off);
      }
    });
  }

  @override
  void dispose() {
    _gridScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(phoneStateProvider);
    final palette = PhonePalette.forBand(p.band);

    return GestureDetector(
      // Pull-down depuis le haut → Spotlight (style iOS).
      onVerticalDragUpdate: (d) {
        if (d.delta.dy > 8 && d.globalPosition.dy < 200) {
          showDialog<void>(
            context: context,
            barrierColor: Colors.transparent,
            builder: (_) => const SpotlightSearch(),
          );
        }
      },
      child: Stack(
        children: [
          // Wallpaper avec parallax léger.
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            top: _parallaxY,
            left: 0,
            right: 0,
            bottom: -16 - _parallaxY.abs(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [palette.wallpaperTop, palette.wallpaperBottom],
                ),
              ),
            ),
          ),
          // Voile mood — assombrit / réchauffe selon l'état de Shen.
          IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              color: moodOverlay(p.mood),
            ),
          ),
          _HomeContent(palette: palette, gridScroll: _gridScroll),
        ],
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.palette, required this.gridScroll});
  final PhonePalette palette;
  final ScrollController gridScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(phoneStateProvider);
    final dockApps = kAllApps.where((a) => a.inDock).toList();
    final gridApps = kAllApps
        .where((a) => !a.inDock && p.unlockedApps.contains(a.id))
        .toList();
    return Column(
      children: [
        PhoneStatusBar(foreground: palette.statusBarFg),
        const DeadlineBanner(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: MeteoWidget()),
              SizedBox(width: 12),
              Expanded(child: PhotoMamanWidget()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: CalendarWidget()),
              SizedBox(width: 12),
              Expanded(child: TimeSkipWidget()),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              controller: gridScroll,
              crossAxisCount: 4,
              mainAxisSpacing: 18,
              crossAxisSpacing: 12,
              physics: const BouncingScrollPhysics(),
              children: gridApps.map((m) => AppIcon(meta: m)).toList(),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: dockApps
                    .map((m) => AppIcon(meta: m, showLabel: false))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
