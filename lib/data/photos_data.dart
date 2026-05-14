/// Photos de la galerie Shen — placeholders colorés avec titre.
///
/// Chaque photo a un jour de prise, un mois pour le groupement, un
/// titre court, et 2 couleurs de gradient pour le rendu (puisqu'on n'a
/// pas de vrais bitmaps après le reset).

class PhotoItem {
  final int day;
  final String monthLabel; // "Juin"
  final String title;
  final String subtitle; // emoji ou détail
  final List<int> gradient; // [topHex, bottomHex]
  final bool isScreenshot;

  const PhotoItem({
    required this.day,
    required this.monthLabel,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.isScreenshot = false,
  });
}

const kPhotos = <PhotoItem>[
  // J1 — Vendredi 3 juin
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Carnet matinal',
    subtitle: '✍️ 07h42',
    gradient: [0xFFFAE0CC, 0xFFFBF7EF],
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Vélo cassé',
    subtitle: '🚲 08h17 · Avenue Montaigne',
    gradient: [0xFF3A4555, 0xFF6B7385],
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Açaí violet',
    subtitle: '🍇 08h18',
    gradient: [0xFF5E2E66, 0xFF8B4A8A],
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Carte recollée',
    subtitle: '📇 23h42',
    gradient: [0xFFE8E0D0, 0xFFF5EFE2],
    isScreenshot: true,
  ),
  // J2
  PhotoItem(
    day: 2,
    monthLabel: 'Juin',
    title: 'Couloir Tenon',
    subtitle: '🏥 06h48',
    gradient: [0xFFA8B5C2, 0xFFD5DCE3],
  ),
  // J3
  PhotoItem(
    day: 3,
    monthLabel: 'Juin',
    title: 'Trois colonnes',
    subtitle: '🧮 15h48',
    gradient: [0xFFFAEAD0, 0xFFFCEED4],
    isScreenshot: true,
  ),
  PhotoItem(
    day: 3,
    monthLabel: 'Juin',
    title: 'Refus banque',
    subtitle: '📲 14h23',
    gradient: [0xFFE9E9EB, 0xFFFFFFFF],
    isScreenshot: true,
  ),
];
