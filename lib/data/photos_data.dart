/// Photos de la galerie Shen — chaque entrée pointe vers une vraie
/// image WebP dans `assets/photos/ep1/` quand `imagePath` est non-null,
/// sinon retombe sur un gradient + emoji (screenshots et placeholders).

class PhotoItem {
  final int day;
  final String monthLabel; // "Juin"
  final String title;
  final String subtitle; // emoji ou détail
  final List<int> gradient; // [topHex, bottomHex] fallback
  final bool isScreenshot;
  /// Chemin asset de l'image réelle. Si null, on retombe sur le gradient.
  final String? imagePath;
  /// Indices cachés révélés au zoom — chaque hotspot a une position
  /// relative (0..1) sur la photo et un texte Shen-style.
  final List<PhotoHotspot> hotspots;

  const PhotoItem({
    required this.day,
    required this.monthLabel,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.isScreenshot = false,
    this.imagePath,
    this.hotspots = const [],
  });
}

/// Indice révélé quand on zoome sur la photo et qu'on tape un point
/// pulsant. Voix Shen — courte, sèche, parfois ironique.
class PhotoHotspot {
  final double x;
  final double y;
  final String detail;

  const PhotoHotspot({
    required this.x,
    required this.y,
    required this.detail,
  });
}

const kPhotos = <PhotoItem>[
  // ─── J1 — Vendredi 3 juin ───────────────────────────────────────
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Carnet matinal',
    subtitle: '✍️ 07h42',
    gradient: [0xFFFAE0CC, 0xFFFBF7EF],
    imagePath: 'assets/photos/ep1/j01_07h42_carnet_matinal.webp',
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Studio · matin',
    subtitle: '☀️ 07h30',
    gradient: [0xFFE7D9C2, 0xFFFAE0CC],
    imagePath: 'assets/photos/ep1/j01_studio_belleville_jour.webp',
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Vélo cassé',
    subtitle: '🚲 08h17 · Avenue Montaigne',
    gradient: [0xFF3A4555, 0xFF6B7385],
    imagePath: 'assets/photos/ep1/j01_08h17_velo_casse_montaigne.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.32,
        y: 0.45,
        detail: 'Le bowl açaï, écrasé. Violet sur le bitume gris.',
      ),
      PhotoHotspot(
        x: 0.68,
        y: 0.72,
        detail:
            'Une carte de visite. Quatre morceaux. Je n\'ai vu le nom qu\'en la ramassant.',
      ),
    ],
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Carte recollée',
    subtitle: '📇 23h42',
    gradient: [0xFFE8E0D0, 0xFFF5EFE2],
    imagePath: 'assets/photos/ep1/j01_23h42_carte_recollee.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.50,
        y: 0.45,
        detail: 'Tristan HENG. Heng International. 47ᵉ étage.',
      ),
      PhotoHotspot(
        x: 0.62,
        y: 0.78,
        detail:
            'Le « T » de Tristan refuse de se réaligner. J\'ai recommencé deux fois.',
      ),
    ],
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Juin',
    title: 'Studio · nuit',
    subtitle: '🌙 23h58',
    gradient: [0xFF1F2937, 0xFF374151],
    imagePath: 'assets/photos/ep1/j01_studio_belleville_nuit.webp',
  ),

  // ─── J2 — Samedi 4 juin ─────────────────────────────────────────
  PhotoItem(
    day: 2,
    monthLabel: 'Juin',
    title: 'Belleville · brouillard',
    subtitle: '🌫️ 06h00',
    gradient: [0xFFB8C2CC, 0xFFD5DCE3],
    imagePath: 'assets/photos/ep1/j02_belleville_matin_brouillard.webp',
  ),
  PhotoItem(
    day: 2,
    monthLabel: 'Juin',
    title: 'Métro Couronnes',
    subtitle: '🚇 06h25',
    gradient: [0xFF6B7385, 0xFF9CA3AF],
    imagePath: 'assets/photos/ep1/j02_metro_couronnes_pluie.webp',
  ),
  PhotoItem(
    day: 2,
    monthLabel: 'Juin',
    title: 'Cabinet Dr Aubin',
    subtitle: '🏥 06h48 · Tenon',
    gradient: [0xFFA8B5C2, 0xFFD5DCE3],
    imagePath: 'assets/photos/ep1/j02_06h30_cabinet_dr_aubin.webp',
  ),

  // ─── J3 — Dimanche 5 juin ───────────────────────────────────────
  PhotoItem(
    day: 3,
    monthLabel: 'Juin',
    title: 'Trois colonnes',
    subtitle: '🧮 15h48',
    gradient: [0xFFFAEAD0, 0xFFFCEED4],
    imagePath: 'assets/photos/ep1/j03_15h48_trois_colonnes.webp',
  ),
  PhotoItem(
    day: 3,
    monthLabel: 'Juin',
    title: 'Refus banque',
    subtitle: '📲 14h23',
    gradient: [0xFFE9E9EB, 0xFFFFFFFF],
    isScreenshot: true,
  ),

  // ─── J6 — Mercredi 8 juin ───────────────────────────────────────
  PhotoItem(
    day: 6,
    monthLabel: 'Juin',
    title: 'Le tailleur',
    subtitle: '👗 22h31',
    gradient: [0xFF1A1A1A, 0xFF3A3A3A],
    imagePath: 'assets/photos/ep1/j06_22h31_tailleur_miroir.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.50,
        y: 0.40,
        detail:
            'Quelqu\'un d\'autre dans le miroir. Pas plus belle. Plus tranchante.',
      ),
    ],
  ),

  // ─── J7 — Jeudi 9 juin (Tour Heng) ──────────────────────────────
  PhotoItem(
    day: 7,
    monthLabel: 'Juin',
    title: 'Tour Heng',
    subtitle: '🏢 10h45',
    gradient: [0xFF2A2A2A, 0xFFD4AF37],
    imagePath: 'assets/photos/ep1/j07_11h00_tour_heng_exterieur.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.50,
        y: 0.10,
        detail:
            'Le H doré au sommet. On le voit depuis le métro Couronnes par temps clair.',
      ),
    ],
  ),
  PhotoItem(
    day: 7,
    monthLabel: 'Juin',
    title: 'Ascenseur',
    subtitle: '⬆️ 10h57',
    gradient: [0xFF4A4A4A, 0xFF8A8A8A],
    imagePath: 'assets/photos/ep1/j07_ascenseur_shen_tristan.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.50,
        y: 0.20,
        detail: '47ᵉ étage. Lundi 17:47. Il avait préparé un dossier.',
      ),
    ],
  ),
  PhotoItem(
    day: 7,
    monthLabel: 'Juin',
    title: '47ᵉ étage',
    subtitle: '🪟 11h12',
    gradient: [0xFF1F2937, 0xFFE89B7F],
    imagePath: 'assets/photos/ep1/j07_47e_etage_bureau_tristan.webp',
  ),
  PhotoItem(
    day: 7,
    monthLabel: 'Juin',
    title: 'Badge refusé',
    subtitle: '🔒 09h08',
    gradient: [0xFFE53935, 0xFF1F2937],
    isScreenshot: true,
    imagePath: 'assets/photos/ep1/j07_badge_47e_refuse.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.50,
        y: 0.50,
        detail:
            'SHEN MIAO. 47ᵉ. Accès refusé. Comme s\'il avait oublié de me déclarer.',
      ),
      PhotoHotspot(
        x: 0.20,
        y: 0.20,
        detail: '09:08. Trois minutes après l\'heure du rendez-vous.',
      ),
    ],
  ),

  // ─── J8 — Vendredi 10 juin ──────────────────────────────────────
  PhotoItem(
    day: 8,
    monthLabel: 'Juin',
    title: 'Contrat 14 pages',
    subtitle: '📋 11h30',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    imagePath: 'assets/photos/ep1/j08_11h30_contrat_14_pages.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.40,
        y: 0.45,
        detail:
            'Article 7 — Clause de discrétion absolue. Dix ans après la fin.',
      ),
      PhotoHotspot(
        x: 0.65,
        y: 0.78,
        detail:
            'Mon stylo a tremblé sur le « M » de Marchand. Personne n\'a vu.',
      ),
    ],
  ),

  // ─── J9 — Samedi 11 juin (emménagement) ─────────────────────────
  PhotoItem(
    day: 9,
    monthLabel: 'Juin',
    title: 'Avenue Foch · cuisine',
    subtitle: '🍓 17h45',
    gradient: [0xFFFAFAFA, 0xFFE7E1D2],
    imagePath: 'assets/photos/ep1/j09_17h22_avenue_foch_cuisine.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.55,
        y: 0.55,
        detail:
            'Bol de fraises pour deux. Posé là, sans personne pour les manger.',
      ),
    ],
  ),
  PhotoItem(
    day: 9,
    monthLabel: 'Juin',
    title: 'Avenue Foch · chambre',
    subtitle: '🛏️ 18h02',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    imagePath: 'assets/photos/ep1/j09_avenue_foch_chambre.webp',
  ),

  // ─── J11 — Lundi 13 juin (Maman, mensonge) ──────────────────────
  PhotoItem(
    day: 11,
    monthLabel: 'Juin',
    title: 'Maman · cuisine',
    subtitle: '🍲 19h12',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    imagePath: 'assets/photos/ep1/j11_maman_cuisine_soir.webp',
  ),
  PhotoItem(
    day: 11,
    monthLabel: 'Juin',
    title: 'Maman · fenêtre',
    subtitle: '🌹 22h08',
    gradient: [0xFFE7D9C2, 0xFFFAE0CC],
    imagePath: 'assets/photos/ep1/j11_maman_fenetre_paris.webp',
  ),

  // ─── J14 — Jeudi 16 juin (dîner Madame Heng) ────────────────────
  PhotoItem(
    day: 14,
    monthLabel: 'Juin',
    title: 'Boîte Long Jing',
    subtitle: '🍵 20h18',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    imagePath: 'assets/photos/ep1/j14_boite_long_jing.webp',
  ),
  PhotoItem(
    day: 14,
    monthLabel: 'Juin',
    title: 'Gaiwan',
    subtitle: '🍵 20h35',
    gradient: [0xFFD4AF37, 0xFFE7E1D2],
    imagePath: 'assets/photos/ep1/j14_long_jing_gaiwan.webp',
  ),
  PhotoItem(
    day: 14,
    monthLabel: 'Juin',
    title: 'Long Jing · mains',
    subtitle: '🍵 21h08',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    imagePath: 'assets/photos/ep1/j14_20h30_long_jing_mains.webp',
    hotspots: [
      PhotoHotspot(
        x: 0.50,
        y: 0.50,
        detail:
            'Bracelet de jade. Elle l\'a touché trois fois pendant le repas.',
      ),
    ],
  ),
];
