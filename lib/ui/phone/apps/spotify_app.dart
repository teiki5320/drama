import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/spotify_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Spotify — version minimale. Une seule playlist (« Pluie 2 % »),
/// vide pour l'instant. Tap → bottom sheet avec un état vide
/// "Aucun titre pour l'instant" (les sons seront ajoutés plus tard).
class SpotifyApp extends ConsumerWidget {
  const SpotifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final hour = ref.watch(phoneStateProvider.select((s) => s.hour));
    final visible = kPlaylists.where((p) => p.minDay <= day).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
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
                Text(
                  _greeting(hour),
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                _SectionTitle('Tes playlists'),
                const SizedBox(height: 10),
                ...visible.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PlaylistRow(playlist: p),
                    )),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Heure DIÉGÉTIQUE (celle du gameworld), pas celle de l'appareil.
  String _greeting(int h) {
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

class _PlaylistRow extends StatelessWidget {
  const _PlaylistRow({required this.playlist});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPlaylistSheet(context, playlist),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(playlist.colorHex),
                    Color(playlist.colorHex).withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child:
                  Text(playlist.emoji, style: const TextStyle(fontSize: 30)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'par ${playlist.author} · ${playlist.tracks.length} titres',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.chevron_right,
                  color: Colors.white54, size: 22),
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
            const SizedBox(height: 22),
            if (p.tracks.isEmpty)
              _EmptyTracksState()
            else
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

class _EmptyTracksState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.library_music_outlined,
              color: Colors.white.withValues(alpha: 0.3), size: 48),
          const SizedBox(height: 14),
          Text(
            'Aucun titre pour l\'instant',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Les morceaux seront ajoutés plus tard.',
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
