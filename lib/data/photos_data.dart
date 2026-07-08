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
  /// Tags pour grouper en albums dynamiques :
  /// 'maman', 'papa', 'camille', 'berri', 'belleville', 'heng', 'hk',
  /// 'fujian', 'memories' (il y a 1 an).
  final List<String> tags;
  /// Si true, la photo n'apparaît que dans l'album caché (FaceID 1402).
  final bool hidden;

  const PhotoItem({
    required this.day,
    required this.monthLabel,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.isScreenshot = false,
    this.imagePath,
    this.hotspots = const [],
    this.tags = const [],
    this.hidden = false,
  });
}

/// Album dynamique calculé depuis les tags des PhotoItem.
class PhotoAlbum {
  final String id;
  final String title;
  final String emoji;
  final String tagFilter;
  final List<int> gradient;
  final bool requiresCode;
  final String? note;

  const PhotoAlbum({
    required this.id,
    required this.title,
    required this.emoji,
    required this.tagFilter,
    required this.gradient,
    this.requiresCode = false,
    this.note,
  });
}

const kAlbums = <PhotoAlbum>[
  PhotoAlbum(
    id: 'al_maman',
    title: 'Maman',
    emoji: '👩',
    tagFilter: 'maman',
    gradient: [0xFFFCE6D8, 0xFFE7B5C8],
    note: 'Toutes les photos de toi avec elle.',
  ),
  PhotoAlbum(
    id: 'al_papa_cache',
    title: 'Papa',
    emoji: '🔒',
    tagFilter: 'papa',
    gradient: [0xFF1A1A1A, 0xFF3D2A1E],
    requiresCode: true,
    note: 'Album verrouillé. Code 1402.',
  ),
  PhotoAlbum(
    id: 'al_camille',
    title: 'Camille',
    emoji: '🥐',
    tagFilter: 'camille',
    gradient: [0xFFFCE6D8, 0xFFFAE0CC],
    note: 'Croissants, fous rires, codes civils.',
  ),
  PhotoAlbum(
    id: 'al_berri',
    title: 'rue de Berri',
    emoji: '🪞',
    tagFilter: 'berri',
    gradient: [0xFF1F2937, 0xFF3D4858],
    note: 'L\'appartement. Les couloirs. Les fenêtres qui regardent vers Belleville.',
  ),
  PhotoAlbum(
    id: 'al_belleville',
    title: 'Belleville',
    emoji: '🏠',
    tagFilter: 'belleville',
    gradient: [0xFFD7A879, 0xFF8C6F47],
    note: 'Le studio. La fenêtre. La cuisine de Maman.',
  ),
  PhotoAlbum(
    id: 'al_heng',
    title: 'Heng',
    emoji: '🍵',
    tagFilter: 'heng',
    gradient: [0xFFCFC8B5, 0xFFE7D9C2],
    note: 'Tour, dîners, gala. Le costume noir.',
  ),
  PhotoAlbum(
    id: 'al_memories',
    title: 'Il y a 1 an',
    emoji: '🌸',
    tagFilter: 'memories',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    note: 'Souvenirs auto-générés. Tu n\'avais pas demandé.',
  ),
];

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
        detail: '47ᵉ étage. Jeudi 11:00. Il avait préparé un dossier.',
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
    subtitle: '🔒 10h33',
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
        detail: '10:33. Trois minutes après l\'heure du rendez-vous.',
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
    title: 'rue de Berri · cuisine',
    subtitle: '🍓 17h45',
    gradient: [0xFFFAFAFA, 0xFFE7E1D2],
    imagePath: 'assets/photos/ep1/j09_17h22_avenue_berri_cuisine.webp',
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
    title: 'rue de Berri · chambre',
    subtitle: '🛏️ 18h02',
    gradient: [0xFFE7E1D2, 0xFFCFC8B5],
    imagePath: 'assets/photos/ep1/j09_avenue_berri_chambre.webp',
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
  // ─── Album Papa (caché — code 1402) ───────────────────────────
  PhotoItem(
    day: 1,
    monthLabel: 'Archives',
    title: 'Papa, 5 ans, Fujian',
    subtitle: '📷 1991. Papa avec Shen sur ses épaules.',
    gradient: [0xFF8C6F47, 0xFF3D2A1E],
    imagePath: 'assets/photos/ep1/pj_papa_shen_5ans.webp',
    tags: ['papa'],
    hidden: true,
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Archives',
    title: 'Papa à Paris',
    subtitle: '📷 1995. Devant la Tour Eiffel. Sans Maman.',
    gradient: [0xFF8C6F47, 0xFF553C2A],
    tags: ['papa'],
    hidden: true,
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Archives',
    title: 'Lettre',
    subtitle: '📷 Une lettre de Papa, écriture chinoise.',
    gradient: [0xFFFCE6D8, 0xFFE7B5C8],
    tags: ['papa'],
    hidden: true,
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Archives',
    title: 'Mariage Papa-Maman',
    subtitle: '📷 1996. Robe rouge brodée. Maman souriait encore.',
    gradient: [0xFFB85A7C, 0xFF5C2A40],
    tags: ['papa'],
    hidden: true,
  ),
  PhotoItem(
    day: 1,
    monthLabel: 'Archives',
    title: 'Enterrement',
    subtitle: '📷 Février 2009. Maman au Père-Lachaise.',
    gradient: [0xFF1F2937, 0xFF3D4858],
    tags: ['papa'],
    hidden: true,
  ),
  // ─── Memories — J-365 (« Il y a 1 an aujourd'hui ») ─────────
  PhotoItem(
    day: 1,
    monthLabel: 'Souvenirs',
    title: 'Il y a 1 an aujourd\'hui',
    subtitle: '📷 Mai 2025. Premier jour de Shen seule à Belleville.',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    tags: ['memories'],
  ),
  PhotoItem(
    day: 30,
    monthLabel: 'Souvenirs',
    title: 'Il y a 1 an · juin',
    subtitle: '📷 Soutenance de master. Camille à l\'arrière.',
    gradient: [0xFFFCE6D8, 0xFFE7C5A8],
    tags: ['memories'],
  ),
  // ─── Album Maman (photos avec / de Maman) ────────────────────
  PhotoItem(
    day: 5,
    monthLabel: 'Juin',
    title: 'Maman pelant un gingembre',
    subtitle: '📷 Belleville, dimanche, 11h30.',
    gradient: [0xFFFCE6D8, 0xFFE7B5C8],
    imagePath: 'assets/photos/ep1/post_maman_plat.webp',
    tags: ['maman', 'belleville'],
  ),
  PhotoItem(
    day: 11,
    monthLabel: 'Juin',
    title: 'Maman à la fenêtre',
    subtitle: '📷 19:42. Elle regardait dehors. Je n\'ai pas pu lui parler.',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    imagePath: 'assets/photos/ep1/j11_maman_fenetre_paris.webp',
    tags: ['maman', 'belleville'],
  ),
  // ─── Album Berri ─────────────────────────────────────────────
  PhotoItem(
    day: 9,
    monthLabel: 'Juin',
    title: 'Cuisine — 17:22',
    subtitle: '📷 Premier soir à Berri. Plan de travail vide.',
    gradient: [0xFF1F2937, 0xFF3D4858],
    imagePath: 'assets/photos/ep1/j09_17h22_avenue_berri_cuisine.webp',
    tags: ['berri', 'heng'],
  ),
  PhotoItem(
    day: 9,
    monthLabel: 'Juin',
    title: 'Chambre Berri',
    subtitle: '📷 Penderie partagée. Oreiller de droite, sent le neuf.',
    gradient: [0xFF1F2937, 0xFF553C2A],
    imagePath: 'assets/photos/ep1/j09_avenue_berri_chambre.webp',
    tags: ['berri'],
  ),
  // ─── Album Heng ─────────────────────────────────────────────
  PhotoItem(
    day: 7,
    monthLabel: 'Juin',
    title: 'Tour Heng extérieur',
    subtitle: '📷 11h00. L\'ascenseur monte au 47ᵉ.',
    gradient: [0xFF1F2937, 0xFF111827],
    imagePath: 'assets/photos/ep1/j07_11h00_tour_heng_exterieur.webp',
    tags: ['heng'],
  ),
  PhotoItem(
    day: 14,
    monthLabel: 'Juin',
    title: 'Long Jing gaiwan',
    subtitle: '📷 20h30. Première infusion. Mes mains tremblent un peu.',
    gradient: [0xFFCFC8B5, 0xFFE7D9C2],
    imagePath: 'assets/photos/ep1/j14_long_jing_gaiwan.webp',
    tags: ['heng'],
  ),
  // ─── Album Camille ──────────────────────────────────────────
  PhotoItem(
    day: 5,
    monthLabel: 'Juin',
    title: 'Croissants samedi matin',
    subtitle: '📷 Le boulanger nous reconnaît. C\'est notre rituel.',
    gradient: [0xFFFCE6D8, 0xFFFAE0CC],
    imagePath: 'assets/photos/ep1/post_shen_camille_croissants.webp',
    tags: ['camille'],
  ),
  PhotoItem(
    day: 11,
    monthLabel: 'Juin',
    title: 'Camille sur Montmartre',
    subtitle: '📷 Coucher de soleil. Le Code civil pouvait attendre.',
    gradient: [0xFFE89B7F, 0xFFFCC9A1],
    imagePath: 'assets/photos/ep1/post_camille_montmartre.webp',
    tags: ['camille'],
  ),

  // ─── Ep 3 — Hong Kong (juillet) ────────────────────────────────
  PhotoItem(
    day: 33,
    monthLabel: 'Juillet',
    title: 'Victoria Harbour, 20e étage',
    subtitle: '📷 Trop de lumière pour une seule ville.',
    gradient: [0xFF1F2A44, 0xFF4A6FA5],
    tags: ['hk', 'heng'],
  ),
  PhotoItem(
    day: 37,
    monthLabel: 'Juillet',
    title: 'Repulse Bay, pieds nus',
    subtitle: '📷 « Mon père aussi est de Fujian. » Première fois que je le dis.',
    gradient: [0xFF7FA8C9, 0xFFEFD9B4],
    tags: ['hk', 'papa'],
  ),
  PhotoItem(
    day: 40,
    monthLabel: 'Juillet',
    title: 'Hublot, mer de Chine',
    subtitle: '📷 Il dort. Pas moi. Treize heures pour réfléchir.',
    gradient: [0xFF2A3550, 0xFF8FA3C8],
    tags: ['hk'],
  ),

  // ─── Ep 4 — Retour (juillet-août) ─────────────────────────────
  PhotoItem(
    day: 44,
    monthLabel: 'Juillet',
    title: 'Café de Camille, sans jugement',
    subtitle: '📷 Elle a apporté les tasses. Elle n\'a rien demandé.',
    gradient: [0xFFFCE6D8, 0xFFE8C9A8],
    tags: ['camille', 'belleville'],
  ),
  PhotoItem(
    day: 45,
    monthLabel: 'Juillet',
    title: 'Tenon, salle 12',
    subtitle: '📷 Le traitement commence. Photo prise pour m\'en souvenir en mieux.',
    gradient: [0xFFE7E1D2, 0xFFB8C5B0],
    tags: ['maman'],
  ),

  // ─── Ep 5 — Fujian (septembre) ────────────────────────────────
  PhotoItem(
    day: 80,
    monthLabel: 'Septembre',
    title: 'Maman, hublot, 1998-2026',
    subtitle: '📷 Elle me tient la main au décollage. Première fois depuis le lycée.',
    gradient: [0xFF9FB8D8, 0xFFEFE3C8],
    tags: ['maman', 'fujian'],
  ),
  PhotoItem(
    day: 82,
    monthLabel: 'Septembre',
    title: 'La cour, le kaki',
    subtitle: '📷 Tante Mei dit qu\'il donne trop cette année. Il rattrape.',
    gradient: [0xFFF2E3C8, 0xFFC8A96B],
    tags: ['fujian'],
  ),
  PhotoItem(
    day: 88,
    monthLabel: 'Septembre',
    title: 'Le banc du parc',
    subtitle: '📷 C\'est ici qu\'il lui a dit qu\'il partait. Il pensait revenir.',
    gradient: [0xFF8AA070, 0xFFD8E3C0],
    tags: ['fujian', 'papa', 'maman'],
  ),
  PhotoItem(
    day: 112,
    monthLabel: 'Octobre',
    title: 'Ce que j\'emporte',
    subtitle: '📷 Le pinceau, le carnet, la 312e lettre. Le reste se décide à 11h.',
    gradient: [0xFFFBF7EF, 0xFF8AA070],
    tags: ['fujian', 'papa'],
  ),
];
