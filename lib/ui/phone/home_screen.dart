import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/phone_apps.dart';
import '../../core/phone_theme.dart';
import '../../providers/phone_state_provider.dart';
import 'app_icon.dart';
import 'status_bar.dart';
import 'widgets/home_widgets.dart';

/// Home screen iOS-like : status bar, ligne de widgets, grille d'apps,
/// dock du bas. Le wallpaper change selon l'heure du jeu.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(phoneStateProvider);
    final palette = PhonePalette.forBand(p.band);
    final dockApps = kAllApps.where((a) => a.inDock).toList();
    final gridApps = kAllApps
        .where((a) => !a.inDock && p.unlockedApps.contains(a.id))
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.wallpaperTop, palette.wallpaperBottom],
        ),
      ),
      child: Column(
        children: [
          PhoneStatusBar(foreground: palette.statusBarFg),
          // Ligne de widgets (météo, photo Maman, calendrier, time skip)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
          // Grille d'apps
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 18,
                crossAxisSpacing: 12,
                physics: const BouncingScrollPhysics(),
                children: gridApps.map((m) => AppIcon(meta: m)).toList(),
              ),
            ),
          ),
          // Dock du bas
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.18), width: 1),
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
      ),
    );
  }
}
