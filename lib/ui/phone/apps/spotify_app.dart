import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/spotify_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Spotify — accueil dark Spotify-style avec :
/// - Now Playing card en haut (mock)
/// - Recently played (4 dernières playlists)
/// - Made for you (playlists)
/// - Suivis (artistes)
/// Tap playlist → bottom sheet avec liste de morceaux.
class SpotifyApp extends ConsumerWidget {
  const SpotifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final visible = kPlaylists.where((p) => p.minDay <= day).toList();
    // "Recently played" : 4 dernières débloquées
    final recent = visible.reversed.take(4).toList();
    // Now playing : "Pluie 2 %" si dispo, sinon Vivaldi
    final nowPlaying = visible.firstWhere(
      (p) => p.id == 'pl_shen_pluie',
      orElse: () => visible.first,
    );
    final nowTrack = nowPlaying.tracks.isNotEmpty
        ? nowPlaying.tracks.first
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF1DB954), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                const Icon(Icons.album, color: Color(0xFF1DB954), size: 26),
                const SizedBox(width: 8),
                Text(
                  'Spotify',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF1DB954),
                  child: Text(
                    'S',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // ── Greeting selon heure
                Text(
                  _greeting(),
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                // ── Now playing (mini-player)
                if (nowTrack != null)
                  _NowPlayingCard(playlist: nowPlaying, track: nowTrack),
                const SizedBox(height: 22),
                // ── Section : Récemment écouté (grille 2 col)
                _SectionTitle('Récemment écouté'),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.2,
                  children: recent
                      .map((p) => _RecentTile(playlist: p))
                      .toList(),
                ),
                const SizedBox(height: 22),
                // ── Made for you : playlists carrées scroll horizontal
                _SectionTitle('Pour toi'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: visible
                        .map((p) => _PlaylistBigTile(playlist: p))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 22),
                // ── Suivis (artistes)
                _SectionTitle('Artistes suivis'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: kFollowedArtists
                        .map((a) => _ArtistTile(artist: a))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 6) return 'Encore debout ?';
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }
}

class _NowPlayingCard extends StatelessWidget {
  const _NowPlayingCard({required this.playlist, required this.track});
  final Playlist playlist;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(playlist.colorHex).withValues(alpha: 0.55),
            Color(playlist.colorHex).withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(playlist.colorHex),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(playlist.emoji,
                style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${track.artist} · ${playlist.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.devices, color: Colors.white70, size: 18),
          const SizedBox(width: 12),
          const Icon(Icons.play_arrow, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.playlist});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPlaylistSheet(context, playlist),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(playlist.colorHex).withValues(alpha: 0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              alignment: Alignment.center,
              child:
                  Text(playlist.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                playlist.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistBigTile extends StatelessWidget {
  const _PlaylistBigTile({required this.playlist});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPlaylistSheet(context, playlist),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(playlist.colorHex),
                      Color(playlist.colorHex).withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(playlist.emoji,
                    style: const TextStyle(fontSize: 60)),
              ),
              const SizedBox(height: 6),
              Text(
                playlist.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'par ${playlist.author}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  const _ArtistTile({required this.artist});
  final FollowedArtist artist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(artist.emoji,
                  style: const TextStyle(fontSize: 36)),
            ),
            const SizedBox(height: 6),
            Text(
              artist.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              '${(artist.monthlyListeners / 1000000).toStringAsFixed(1)}M auditeurs',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showPlaylistSheet(BuildContext context, Playlist p) {
  HapticFeedback.selectionClick();
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(p.colorHex).withValues(alpha: 0.4),
              const Color(0xFF121212),
            ],
          ),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(p.colorHex),
                      Color(p.colorHex).withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(p.emoji, style: const TextStyle(fontSize: 86)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              p.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'par ${p.author} · ${p.tracks.length} titres',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              p.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            if (p.noteFiligrane != null) ...[
              const SizedBox(height: 6),
              Text(
                p.noteFiligrane!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
            const SizedBox(height: 18),
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow,
                    color: Colors.black, size: 32),
              ),
            ),
            const SizedBox(height: 22),
            // Tracks
            ...p.tracks.asMap().entries.map((e) {
              final i = e.key;
              final t = e.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${i + 1}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            t.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          if (t.note != null)
                            Text(
                              t.note!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      t.duration,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
