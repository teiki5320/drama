import 'package:flutter/material.dart';

import '../palette.dart';
import '../rewards.dart';

/// L'app Photos — la galerie des souvenirs débloqués par le sudoku,
/// et le choix du fond d'écran.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Container(
      color: pal.threadBg,
      child: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: Rewards.instance,
          builder: (context, _) {
            final r = Rewards.instance;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: pal.chev, size: 22),
                      tooltip: 'Accueil',
                    ),
                    Text(
                      'Photos',
                      style: TextStyle(
                        color: pal.headText,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      Text(
                        'SOUVENIRS · ${r.souvenirsDebloques}/${kSouvenirs.length}',
                        style: TextStyle(
                          color: pal.meta,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.92,
                        children: [
                          for (var i = 0; i < kSouvenirs.length; i++)
                            i < r.souvenirsDebloques
                                ? _SouvenirTile(souvenir: kSouvenirs[i])
                                : const _LockedTile(),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'FONDS D’ÉCRAN',
                        style: TextStyle(
                          color: pal.meta,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _WallpaperTile(
                            label: 'Origine',
                            asset: null,
                            unlocked: true,
                            selected: r.wallpaper == null,
                          ),
                          for (var i = 0; i < kWallpapers.length; i++) ...[
                            const SizedBox(width: 10),
                            _WallpaperTile(
                              label: r.wallpaperDebloque(i)
                                  ? kWallpapers[i].titre
                                  : '${(i + 1) * 3} grilles',
                              asset: kWallpapers[i].asset,
                              unlocked: r.wallpaperDebloque(i),
                              selected: r.wallpaper == kWallpapers[i].asset,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SouvenirTile extends StatelessWidget {
  const _SouvenirTile({required this.souvenir});

  final Souvenir souvenir;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return GestureDetector(
      onTap: () => _openViewer(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox.expand(
                child: Image.asset(souvenir.asset, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            souvenir.titre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: pal.preview, fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  void _openViewer(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (pageContext, _, __) => GestureDetector(
          onTap: () => Navigator.of(pageContext).pop(),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: InteractiveViewer(
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(souvenir.asset,
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Text(
                      '« ${souvenir.titre} »',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LockedTile extends StatelessWidget {
  const _LockedTile();

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: pal.inBubble.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.lock_outline, color: pal.meta, size: 26),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Termine une grille de sudoku',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: pal.meta, fontSize: 11.5),
        ),
      ],
    );
  }
}

class _WallpaperTile extends StatelessWidget {
  const _WallpaperTile({
    required this.label,
    required this.asset,
    required this.unlocked,
    required this.selected,
  });

  final String label;
  final String? asset;
  final bool unlocked;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: unlocked ? () => Rewards.instance.setWallpaper(asset) : null,
        child: Column(
          children: [
            Container(
              height: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: selected
                    ? Border.all(color: pal.brand, width: 2.4)
                    : Border.all(color: pal.rowBorder, width: 0.5),
                image: asset != null && unlocked
                    ? DecorationImage(
                        image: AssetImage(asset!), fit: BoxFit.cover)
                    : null,
                gradient: asset == null
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF141A33), Color(0xFF3B2B52)],
                      )
                    : null,
                color: !unlocked ? pal.inBubble.withValues(alpha: 0.5) : null,
              ),
              alignment: Alignment.center,
              child: !unlocked
                  ? Icon(Icons.lock_outline, color: pal.meta, size: 20)
                  : (selected
                      ? const Icon(Icons.check_circle,
                          color: Colors.white, size: 22)
                      : null),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: pal.preview, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
