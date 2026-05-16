/// Données Spotify de Shen — playlists, morceaux récents, suivis,
/// écoute en cours. Donne une couche musicale au téléphone (Vivaldi
/// pour Maman, Erik Satie pour les nuits, Annie Ernaux ne se lit pas
/// mais Camille a fait une playlist « Pour lire Ernaux »).

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

/// Playlists canoniques.
const kPlaylists = <Playlist>[
  // ── Maman (Hélène) — Vivaldi & Duras ────────────────────────
  Playlist(
    id: 'pl_maman_vivaldi',
    title: 'Le concerto que ton père aimait',
    author: 'Hélène Marchand',
    description: 'Vivaldi. Bach. Rachmaninov. Quand la nuit est trop longue.',
    colorHex: 0xFFFCE6D8,
    emoji: '🎻',
    minDay: 1,
    noteFiligrane: 'Partagée par Maman le J2. Tu ne l\'as jamais ouverte.',
    tracks: [
      Track(
          title: 'Les Quatre Saisons — L\'Hiver',
          artist: 'Antonio Vivaldi',
          album: 'Les Quatre Saisons',
          durationS: 580,
          note: 'Le concerto en sol mineur. Celui de Papa.'),
      Track(
          title: 'Concerto pour piano n°2 — Adagio sostenuto',
          artist: 'Rachmaninov',
          album: 'Concertos pour piano',
          durationS: 690),
      Track(
          title: 'Suite n°3 — Air',
          artist: 'J.S. Bach',
          album: 'Suites pour orchestre',
          durationS: 320),
      Track(
          title: 'Gymnopédie n°1',
          artist: 'Erik Satie',
          album: 'Gymnopédies',
          durationS: 200),
      Track(
          title: 'Stabat Mater — Cujus animam',
          artist: 'Pergolesi',
          album: 'Stabat Mater',
          durationS: 240),
    ],
  ),

  // ── Camille « Pour lire Ernaux » ────────────────────────────
  Playlist(
    id: 'pl_camille_ernaux',
    title: 'Pour lire Ernaux',
    author: 'camille_rx',
    description: 'À fond pour le code civil, doux pour Annie Ernaux.',
    colorHex: 0xFFFCE6D8,
    emoji: '📚',
    minDay: 1,
    noteFiligrane: 'Camille la met chaque mardi soir au Telescope.',
    tracks: [
      Track(
          title: 'Holocene',
          artist: 'Bon Iver',
          album: 'Bon Iver, Bon Iver',
          durationS: 339),
      Track(
          title: 'Asleep',
          artist: 'The Smiths',
          album: 'The World Won\'t Listen',
          durationS: 251),
      Track(
          title: 'Re: Stacks',
          artist: 'Bon Iver',
          album: 'For Emma, Forever Ago',
          durationS: 397),
      Track(
          title: 'Saint-Cloud',
          artist: 'Mac DeMarco',
          album: 'Another One',
          durationS: 230),
      Track(
          title: 'Slow Show',
          artist: 'The National',
          album: 'Boxer',
          durationS: 244),
      Track(
          title: 'Norman Fucking Rockwell',
          artist: 'Lana Del Rey',
          album: 'NFR',
          durationS: 240),
      Track(
          title: 'Cherry-coloured Funk',
          artist: 'Cocteau Twins',
          album: 'Heaven or Las Vegas',
          durationS: 195),
    ],
  ),

  // ── Shen « Pluie 2 % » ──────────────────────────────────────
  Playlist(
    id: 'pl_shen_pluie',
    title: 'Pluie 2 %',
    author: 'shen_marchand',
    description: 'Belleville, 7h, vélo, déprime fonctionnelle.',
    colorHex: 0xFFA8C5E0,
    emoji: '🌧️',
    minDay: 1,
    noteFiligrane: 'Créée par toi le matin de la collision.',
    tracks: [
      Track(
          title: 'Idioteque',
          artist: 'Radiohead',
          album: 'Kid A',
          durationS: 309),
      Track(
          title: 'Teardrop',
          artist: 'Massive Attack',
          album: 'Mezzanine',
          durationS: 329),
      Track(
          title: 'Wires',
          artist: 'Athlete',
          album: 'Tourist',
          durationS: 257),
      Track(
          title: 'Heartbeats',
          artist: 'José González',
          album: 'Veneer',
          durationS: 158),
      Track(
          title: 'Solitude',
          artist: 'M83',
          album: 'Junk',
          durationS: 290),
      Track(
          title: 'À nos souvenirs',
          artist: 'Trois Cafés Gourmands',
          album: 'Un air de rien',
          durationS: 218,
          note: 'Honte. Mais c\'est là.'),
      Track(
          title: 'How to Disappear Completely',
          artist: 'Radiohead',
          album: 'Kid A',
          durationS: 356),
    ],
  ),

  // ── Tristan « Pour le 47e » ─────────────────────────────────
  Playlist(
    id: 'pl_tristan_47e',
    title: 'Pour le 47e',
    author: 't_heng',
    description: 'Six heures de réunion, trois heures de silence.',
    colorHex: 0xFF1F2937,
    emoji: '🥃',
    minDay: 7,
    noteFiligrane: 'Tristan te l\'a partagée sans un mot le J10.',
    tracks: [
      Track(
          title: 'Nuvole bianche',
          artist: 'Ludovico Einaudi',
          album: 'Une Mattina',
          durationS: 357),
      Track(
          title: 'Comptine d\'un autre été',
          artist: 'Yann Tiersen',
          album: 'Amélie',
          durationS: 142),
      Track(
          title: 'Spiegel im Spiegel',
          artist: 'Arvo Pärt',
          album: 'Alina',
          durationS: 520),
      Track(
          title: 'On the Nature of Daylight',
          artist: 'Max Richter',
          album: 'The Blue Notebooks',
          durationS: 374),
      Track(
          title: 'Mercy',
          artist: 'Max Richter',
          album: 'The Blue Notebooks',
          durationS: 308),
      Track(
          title: 'River Flows in You',
          artist: 'Yiruma',
          album: 'First Love',
          durationS: 191),
    ],
  ),

  // ── Tante Mei « 福建的早晨 » ────────────────────────────────
  Playlist(
    id: 'pl_mei_fujian',
    title: '福建的早晨 · Matins à Fujian',
    author: 'auntmei_fj',
    description: 'Guzheng. Pipa. Le silence des rizières.',
    colorHex: 0xFF8AA070,
    emoji: '🍃',
    minDay: 1,
    noteFiligrane: 'Tante Mei la met quand elle pèle les pivoines.',
    tracks: [
      Track(
          title: '高山流水 (Eaux et Montagnes)',
          artist: 'Wu Wenguang',
          album: 'Guqin Classic',
          durationS: 480),
      Track(
          title: '月光 (Clair de lune)',
          artist: 'Liu Xing',
          album: 'Pipa Solo',
          durationS: 330),
      Track(
          title: '渔舟唱晚 (Pêcheur au crépuscule)',
          artist: 'Sun Wenyan',
          album: 'Guzheng',
          durationS: 410),
      Track(
          title: 'Spring',
          artist: 'Sakamoto Ryuichi',
          album: 'Three',
          durationS: 240),
    ],
  ),

  // ── « Pour ne pas pleurer » (privée, créée après J45) ───────
  Playlist(
    id: 'pl_shen_pas_pleurer',
    title: 'Pour ne pas pleurer',
    author: 'shen_marchand',
    description: 'Privée. Ne partage pas.',
    colorHex: 0xFFE89B7F,
    emoji: '🌿',
    minDay: 45,
    noteFiligrane: 'Créée le J45 entre 10h et 11h.',
    tracks: [
      Track(
          title: 'Vita Nostra',
          artist: 'Akira Kosemura',
          album: 'In the Dark Woods',
          durationS: 260),
      Track(
          title: 'Time',
          artist: 'Hans Zimmer',
          album: 'Inception OST',
          durationS: 271),
      Track(
          title: 'Una Mattina',
          artist: 'Ludovico Einaudi',
          album: 'Une Mattina',
          durationS: 232),
      Track(
          title: 'I Giorni',
          artist: 'Ludovico Einaudi',
          album: 'I Giorni',
          durationS: 410),
    ],
  ),

  // ── Vincent « Closing playlist » ────────────────────────────
  Playlist(
    id: 'pl_vincent_closing',
    title: 'Closing playlist',
    author: 'vincent_h',
    description: 'High energy. Pour signer ou pour danser au Bristol.',
    colorHex: 0xFFE89B7F,
    emoji: '🥃',
    minDay: 10,
    noteFiligrane: 'Vincent l\'a likée publiquement. 4 200 followers.',
    tracks: [
      Track(
          title: 'Closer',
          artist: 'The Chainsmokers',
          album: 'Collage',
          durationS: 245),
      Track(
          title: 'Don\'t Stop Me Now',
          artist: 'Queen',
          album: 'Jazz',
          durationS: 209),
      Track(
          title: 'September',
          artist: 'Earth, Wind & Fire',
          album: 'The Best of',
          durationS: 215),
      Track(
          title: 'In the Air Tonight',
          artist: 'Phil Collins',
          album: 'Face Value',
          durationS: 333),
      Track(
          title: 'Une heure de plus',
          artist: 'Stupeflip',
          album: 'The Hypnoflip Invasion',
          durationS: 240),
    ],
  ),

  // ── Mathieu B. Tokyo ────────────────────────────────────────
  Playlist(
    id: 'pl_mathieu_tokyo',
    title: 'Shinjuku, 23h',
    author: 'mathieu_b',
    description: 'City pop, ambient. Ce qu\'on écoute en marchant.',
    colorHex: 0xFFC4A0A8,
    emoji: '🌃',
    minDay: 6,
    noteFiligrane: 'Mathieu te l\'a partagée à son retour de Tokyo.',
    tracks: [
      Track(
          title: 'Plastic Love',
          artist: 'Mariya Takeuchi',
          album: 'Variety',
          durationS: 470),
      Track(
          title: 'Stay With Me',
          artist: 'Miki Matsubara',
          album: 'Pocket Park',
          durationS: 285),
      Track(
          title: 'Lavender',
          artist: 'Marvin Gaye',
          album: 'Sexual Healing',
          durationS: 234),
      Track(
          title: 'Merry Christmas Mr. Lawrence',
          artist: 'Sakamoto Ryuichi',
          album: 'Merry Christmas Mr. Lawrence OST',
          durationS: 252),
    ],
  ),
];

/// Artistes / comptes que Shen suit.
class FollowedArtist {
  final String name;
  final String emoji;
  final int monthlyListeners;
  const FollowedArtist({
    required this.name,
    required this.emoji,
    required this.monthlyListeners,
  });
}

const kFollowedArtists = <FollowedArtist>[
  FollowedArtist(name: 'Vivaldi', emoji: '🎻', monthlyListeners: 4280000),
  FollowedArtist(name: 'Erik Satie', emoji: '🕯️', monthlyListeners: 1840000),
  FollowedArtist(name: 'Bon Iver', emoji: '🌲', monthlyListeners: 8200000),
  FollowedArtist(name: 'Ludovico Einaudi', emoji: '🎹', monthlyListeners: 12400000),
  FollowedArtist(name: 'Max Richter', emoji: '📚', monthlyListeners: 5600000),
  FollowedArtist(name: 'Lana Del Rey', emoji: '🌹', monthlyListeners: 28000000),
  FollowedArtist(name: 'Mariya Takeuchi', emoji: '🌸', monthlyListeners: 2100000),
  FollowedArtist(name: 'Yann Tiersen', emoji: '🎬', monthlyListeners: 980000),
];
