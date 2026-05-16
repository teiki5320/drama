/// Données Spotify de Shen — version minimale. Une seule playlist
/// (« Pluie 2 % »), vide pour l'instant : les morceaux seront ajoutés
/// par l'utilisateur plus tard.

class Track {
  final String title;
  final String artist;
  final String album;
  /// Durée en secondes.
  final int durationS;
  final String? note;

  const Track({
    required this.title,
    required this.artist,
    required this.album,
    required this.durationS,
    this.note,
  });

  String get duration {
    final m = durationS ~/ 60;
    final s = (durationS % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class Playlist {
  final String id;
  final String title;
  final String author;
  /// Description courte.
  final String description;
  /// Couleur dominante (hex).
  final int colorHex;
  final String emoji;
  final List<Track> tracks;
  /// Jour minimum à partir duquel la playlist apparaît.
  final int minDay;
  /// Note narrative (filigrane).
  final String? noteFiligrane;

  const Playlist({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.colorHex,
    required this.emoji,
    required this.tracks,
    this.minDay = 1,
    this.noteFiligrane,
  });
}

/// Une seule playlist canonique pour l'instant — Shen, « Pluie 2 % ».
/// Liste de morceaux vide : à remplir plus tard.
const kPlaylists = <Playlist>[
  Playlist(
    id: 'pl_shen_pluie',
    title: 'Pluie 2 %',
    author: 'shen_marchand',
    description: 'Belleville, 7h, vélo, déprime fonctionnelle.',
    colorHex: 0xFFA8C5E0,
    emoji: '🌧️',
    minDay: 1,
    noteFiligrane: 'Créée par toi le matin de la collision.',
    tracks: [],
  ),
];
