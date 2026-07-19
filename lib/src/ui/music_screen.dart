import 'package:flutter/material.dart';

import '../music.dart';
import '../palette.dart';
import '../sfx.dart';

/// L'app Musique — la playlist de Shen, et le réglage des sons.
class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Container(
      color: pal.threadBg,
      child: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: Music.instance,
          builder: (context, _) {
            final current = Music.instance.current;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: pal.chev, size: 22),
                      tooltip: 'Accueil',
                    ),
                    Text(
                      'Musique',
                      style: TextStyle(
                        color: pal.headText,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
                  child: Text(
                    'LA PLAYLIST DE SHEN',
                    style: TextStyle(
                      color: pal.meta,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final t in kTracks)
                        _TrackRow(
                          track: t,
                          playing: current == t.file,
                          onTap: !t.dispo
                              ? null
                              : () => current == t.file
                                  ? Music.instance.stop()
                                  : Music.instance.play(t.file),
                        ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        value: Sfx.enabled,
                        onChanged: (v) async {
                          await Sfx.setEnabled(v);
                          if (mounted) setState(() {});
                        },
                        activeTrackColor: pal.brand,
                        title: Text(
                          'Sons de messagerie',
                          style:
                              TextStyle(color: pal.headText, fontSize: 15),
                        ),
                        subtitle: Text(
                          'Reçu, envoyé, notification',
                          style:
                              TextStyle(color: pal.preview, fontSize: 12.5),
                        ),
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

class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.track,
    required this.playing,
    required this.onTap,
  });

  final Track track;
  final bool playing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final dispo = track.dispo;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: pal.rowBorder, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dispo
                      ? const [Color(0xFFD4573B), Color(0xFF8E2F1C)]
                      : [pal.inBubble, pal.inBubble],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                playing
                    ? Icons.graphic_eq
                    : (dispo ? Icons.music_note : Icons.hourglass_empty),
                color: dispo ? Colors.white : pal.meta,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.titre,
                    style: TextStyle(
                      color: dispo ? pal.headText : pal.meta,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dispo ? track.sousTitre : '${track.sousTitre} · à venir',
                    style: TextStyle(color: pal.preview, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            if (playing)
              Icon(Icons.pause_circle_filled, color: pal.brand, size: 26)
            else if (dispo)
              Icon(Icons.play_circle_outline, color: pal.chev, size: 26),
          ],
        ),
      ),
    );
  }
}
