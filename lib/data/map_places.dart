/// Catalogue de ~70 lieux Paris pour l'app Plans. Coordonnées
/// approximatives projetées sur un canvas stylisé. Couvre :
///  - 10 lieux canoniques (Tour Heng, Berri, Belleville, Tenon, etc.)
///  - 30 restaurants UberEats
///  - 30 clients UberEats
///  - quelques lieux narratifs (collision Avenue Montaigne, BNP)
library;

import '../models/map_place.dart';

const kMapPlaces = <MapPlace>[
  // ── Lieux canoniques de Shen (révélés dès J1) ──────────────────
  MapPlace(
    id: 'p_belleville_home',
    name: 'Appartement Belleville',
    address: '24 rue Piat, 20e',
    lat: 48.872, lng: 2.385,
    category: PlaceCategory.maman,
    emoji: '🏠',
    detail: 'L\'appartement de Maman. Et de Shen avant le J9.',
    revealedAtStart: true,
  ),
  MapPlace(
    id: 'p_tenon',
    name: 'Hôpital Tenon',
    address: '4 rue de la Chine, 20e',
    lat: 48.872, lng: 2.396,
    category: PlaceCategory.medical,
    emoji: '🩺',
    detail: 'Service oncologie. Couloir K niveau 2. Dr Aubin.',
    revealedAtStart: true,
  ),
  MapPlace(
    id: 'p_marche_belleville',
    name: 'Marché de Belleville',
    address: 'Bd de Belleville, 20e',
    lat: 48.871, lng: 2.378,
    category: PlaceCategory.maman,
    emoji: '🥬',
    detail: 'Légumes asiatiques. Mardi & vendredi 7h-14h.',
    revealedAtStart: true,
  ),
  MapPlace(
    id: 'p_berri_home',
    name: 'Rue de Berri',
    address: '12 rue de Berri, 8e',
    lat: 48.873, lng: 2.302,
    category: PlaceCategory.perso,
    emoji: '🪞',
    detail: 'Hôtel particulier des Heng. Penderie partagée.',
    requiresDay: 9,
  ),
  MapPlace(
    id: 'p_tour_heng',
    name: 'Tour Heng International',
    address: '47e étage, 8e',
    lat: 48.873, lng: 2.301,
    category: PlaceCategory.heng,
    emoji: '🏢',
    detail: 'Bureau Tristan Heng. RDV J7 11h.',
    requiresDay: 7,
  ),
  MapPlace(
    id: 'p_avenue_montaigne',
    name: 'Avenue Montaigne — collision',
    address: 'Avenue Montaigne, 8e',
    lat: 48.866, lng: 2.305,
    category: PlaceCategory.collision,
    emoji: '🥣',
    detail: 'J1 08:17. La voiture noire. Le bowl en l\'air. La carte.',
    revealedAtStart: true,
  ),
  MapPlace(
    id: 'p_etude_vidal',
    name: 'Étude notariale Vidal',
    address: '12 rue de Sèze, 9e',
    lat: 48.872, lng: 2.330,
    category: PlaceCategory.heng,
    emoji: '📜',
    detail: 'Maître Vidal. Signature J8 11h30. 14 pages.',
    requiresDay: 8,
  ),
  MapPlace(
    id: 'p_bnp_champs',
    name: 'BNP Paribas — Champs-Élysées',
    address: '93 av. des Champs-Élysées, 8e',
    lat: 48.872, lng: 2.299,
    category: PlaceCategory.banque,
    emoji: '🏦',
    detail: 'J3 14:23. Crédit refusé. Motif : pas de garant éligible.',
    revealedAtStart: true,
  ),
  MapPlace(
    id: 'p_appart_camille',
    name: 'Camille Roux',
    address: '38 bd Voltaire, 11e',
    lat: 48.864, lng: 2.378,
    category: PlaceCategory.camille,
    emoji: '🥐',
    detail: 'Appartement de Camille. Croissants samedi matin.',
    revealedAtStart: true,
  ),
  MapPlace(
    id: 'p_dinner_heng',
    name: 'Dîner Madame Heng',
    address: '12 rue de Berri, 8e (salon)',
    lat: 48.873, lng: 2.302,
    category: PlaceCategory.heng,
    emoji: '🍵',
    detail: 'J14 20h30. Long Jing deuxième récolte. Six couverts.',
    requiresDay: 14,
  ),

  // ── Restaurants UberEats ───────────────────────────────────────
  MapPlace(
    id: 'p_r_pcc',
    name: 'Le Petit Cambodge',
    address: '20 rue Alibert, 10e',
    lat: 48.872, lng: 2.366,
    category: PlaceCategory.restaurant,
    emoji: '🍜',
    detail: 'Bo bun emblématique. Souvenir 2015.',
  ),
  MapPlace(
    id: 'p_r_hanami',
    name: 'Café Hanami',
    address: '8 rue Bichat, 10e',
    lat: 48.871, lng: 2.366,
    category: PlaceCategory.restaurant,
    emoji: '🌸',
    detail: 'Sakura latte, mochi maison.',
  ),
  MapPlace(
    id: 'p_r_pho14',
    name: 'Pho 14',
    address: '129 av de Choisy, 13e',
    lat: 48.823, lng: 2.360,
    category: PlaceCategory.restaurant,
    emoji: '🥟',
    detail: 'Queue dehors midi/soir.',
  ),
  MapPlace(
    id: 'p_r_sushib',
    name: 'Sushi B',
    address: '5 rue Saint-Sabin, 11e',
    lat: 48.857, lng: 2.371,
    category: PlaceCategory.restaurant,
    emoji: '🍣',
    detail: 'Omakase 38 €. Chef tatoué.',
  ),
  MapPlace(
    id: 'p_r_neogyoza',
    name: 'Neo Gyoza',
    address: '83 bd de Belleville, 20e',
    lat: 48.871, lng: 2.380,
    category: PlaceCategory.restaurant,
    emoji: '🥟',
    detail: 'Gyozas faux-chinois mais bons.',
  ),
  MapPlace(
    id: 'p_r_wild_moon',
    name: 'Wild & The Moon',
    address: '55 rue Charlot, 3e',
    lat: 48.862, lng: 2.362,
    category: PlaceCategory.restaurant,
    emoji: '🥑',
    detail: 'Smoothie kale-spiruline-charbon. 14 €.',
  ),
  MapPlace(
    id: 'p_r_chloe_bowls',
    name: 'Chloé Bowls',
    address: '12 rue Mabillon, 6e',
    lat: 48.853, lng: 2.336,
    category: PlaceCategory.restaurant,
    emoji: '🥗',
    detail: 'Bowl protéiné 18 €. Clientèle pilates.',
  ),
  MapPlace(
    id: 'p_r_acai_co',
    name: 'Açaí Bowl Co.',
    address: '18 rue de Marignan, 8e',
    lat: 48.870, lng: 2.305,
    category: PlaceCategory.restaurant,
    emoji: '🍓',
    detail: 'Le bowl de la collision J1.',
  ),
  MapPlace(
    id: 'p_r_dupain_idees',
    name: 'Du Pain et des Idées',
    address: '34 rue Yves Toudic, 10e',
    lat: 48.870, lng: 2.362,
    category: PlaceCategory.restaurant,
    emoji: '🥐',
    detail: 'Escargot pistache. File matinale.',
  ),
  MapPlace(
    id: 'p_r_telescope',
    name: 'Telescope',
    address: '5 rue Villedo, 1er',
    lat: 48.866, lng: 2.339,
    category: PlaceCategory.restaurant,
    emoji: '☕',
    detail: 'Cortado parfait. Pas d\'écran admis.',
  ),
  MapPlace(
    id: 'p_r_blackbird',
    name: 'Blackbird Café',
    address: '94 rue Saint-Maur, 11e',
    lat: 48.863, lng: 2.378,
    category: PlaceCategory.restaurant,
    emoji: '☕',
    detail: 'Mug XL. Vinyle qui tourne.',
  ),
  MapPlace(
    id: 'p_r_boris_bouto',
    name: 'Boulangerie Boris',
    address: 'rue Soufflot, 5e',
    lat: 48.846, lng: 2.342,
    category: PlaceCategory.restaurant,
    emoji: '🥖',
    detail: 'Boulangerie d\'Or 2024.',
  ),
  MapPlace(
    id: 'p_r_pny',
    name: 'PNY Marais',
    address: '50 rue de Bretagne, 3e',
    lat: 48.864, lng: 2.362,
    category: PlaceCategory.restaurant,
    emoji: '🍔',
    detail: 'Charlotte Burger. Frites cuites 2 fois.',
  ),
  MapPlace(
    id: 'p_r_dumbo',
    name: 'Dumbo Burger',
    address: '24 rue de la Roquette, 11e',
    lat: 48.857, lng: 2.376,
    category: PlaceCategory.restaurant,
    emoji: '🍔',
    detail: 'Smash burger double.',
  ),
  MapPlace(
    id: 'p_r_pizzou',
    name: 'Pizzou',
    address: '12 rue de la Présentation, 11e',
    lat: 48.868, lng: 2.379,
    category: PlaceCategory.restaurant,
    emoji: '🍕',
    detail: 'Pizza napolitaine. Cuisson 90 s.',
  ),
  MapPlace(
    id: 'p_r_pizzeria_pop',
    name: 'Pizzeria Pop',
    address: '8 rue Lucien Sampaix, 10e',
    lat: 48.871, lng: 2.360,
    category: PlaceCategory.restaurant,
    emoji: '🍕',
    detail: 'Pizza blanche burrata.',
  ),
  MapPlace(
    id: 'p_r_servan',
    name: 'Le Servan',
    address: '32 rue Saint-Maur, 11e',
    lat: 48.866, lng: 2.380,
    category: PlaceCategory.restaurant,
    emoji: '🥩',
    detail: 'Cuisine d\'auteur. Tabata sisters.',
  ),
  MapPlace(
    id: 'p_r_bouillon_pigalle',
    name: 'Bouillon Pigalle',
    address: '22 bd de Clichy, 18e',
    lat: 48.882, lng: 2.336,
    category: PlaceCategory.restaurant,
    emoji: '🍷',
    detail: 'Œuf mayo 1.90 €.',
  ),
  MapPlace(
    id: 'p_r_marche_aligre',
    name: 'Marché d\'Aligre',
    address: 'place d\'Aligre, 12e',
    lat: 48.847, lng: 2.378,
    category: PlaceCategory.restaurant,
    emoji: '🥬',
    detail: 'Produits frais. Le mec du fromage gronde.',
  ),
  MapPlace(
    id: 'p_r_chez_alain',
    name: 'Chez Alain Miam-Miam',
    address: '26 rue Charlot, 3e',
    lat: 48.861, lng: 2.362,
    category: PlaceCategory.restaurant,
    emoji: '🥪',
    detail: 'Sandwich légendaire.',
  ),
  MapPlace(
    id: 'p_r_distrito',
    name: 'Distrito Francés',
    address: '12 rue de Marseille, 10e',
    lat: 48.872, lng: 2.366,
    category: PlaceCategory.restaurant,
    emoji: '🌮',
    detail: 'Tacos al pastor.',
  ),
  MapPlace(
    id: 'p_r_chez_marianne',
    name: 'Chez Marianne',
    address: '2 rue des Hospitalières-Saint-Gervais, 4e',
    lat: 48.857, lng: 2.359,
    category: PlaceCategory.restaurant,
    emoji: '🥙',
    detail: 'Falafel mythique.',
  ),
  MapPlace(
    id: 'p_r_thai_phetburi',
    name: 'Phetburi',
    address: '13 rue de Belleville, 14e',
    lat: 48.835, lng: 2.323,
    category: PlaceCategory.restaurant,
    emoji: '🌶️',
    detail: 'Pad thaï 12 €.',
  ),
  MapPlace(
    id: 'p_r_punjab_grill',
    name: 'Punjab Grill',
    address: '69 rue de la Goutte d\'Or, 18e',
    lat: 48.886, lng: 2.355,
    category: PlaceCategory.restaurant,
    emoji: '🍛',
    detail: 'Butter chicken qui réveille à 2h.',
  ),
  MapPlace(
    id: 'p_r_big_mamma',
    name: 'East Mamma',
    address: '133 av Ledru-Rollin, 11e',
    lat: 48.853, lng: 2.378,
    category: PlaceCategory.restaurant,
    emoji: '🍝',
    detail: 'Truffe. Cocktails roses. File 1h.',
  ),
  MapPlace(
    id: 'p_r_eggs_co',
    name: 'Eggs & Co',
    address: '11 rue Bernard Palissy, 6e',
    lat: 48.853, lng: 2.331,
    category: PlaceCategory.restaurant,
    emoji: '🍳',
    detail: 'Brunch. Œufs Bénédicte.',
  ),
  MapPlace(
    id: 'p_r_dar_djerba',
    name: 'Dar Djerba',
    address: '34 rue Jean-Robert, 18e',
    lat: 48.890, lng: 2.354,
    category: PlaceCategory.restaurant,
    emoji: '🥘',
    detail: 'Couscous. Brik à l\'œuf.',
  ),
  MapPlace(
    id: 'p_r_b_wong',
    name: 'Boulangerie Wong',
    address: '15 rue Belleville, 19e',
    lat: 48.876, lng: 2.385,
    category: PlaceCategory.restaurant,
    emoji: '🥮',
    detail: 'Pâtisseries chinoises. Pinyin sur les vitres.',
  ),
  MapPlace(
    id: 'p_r_kodama',
    name: 'Kodama',
    address: '12 rue d\'Anjou, 8e',
    lat: 48.871, lng: 2.323,
    category: PlaceCategory.restaurant,
    emoji: '🍱',
    detail: 'Bento omakase 35 €.',
  ),
  MapPlace(
    id: 'p_r_pasta_bento',
    name: 'Pasta Bento',
    address: 'Tour Pacific, La Défense',
    lat: 48.890, lng: 2.235,
    category: PlaceCategory.restaurant,
    emoji: '🍝',
    detail: 'Bureau-pasta. Manager pressé permanent.',
  ),

  // ── Clients UberEats (pin un par adresse unique) ────────────────
  MapPlace(
    id: 'p_cl_bonnard',
    name: 'Mme Bonnard',
    address: '24 av. Montaigne, 8e',
    lat: 48.866, lng: 2.304,
    category: PlaceCategory.customer,
    emoji: '👔',
    detail: 'Avocate associée. Bowl açaí avant 9h.',
  ),
  MapPlace(
    id: 'p_cl_morel',
    name: 'M. Morel',
    address: '5 rue Marbeuf, 8e',
    lat: 48.870, lng: 2.302,
    category: PlaceCategory.customer,
    emoji: '💼',
    detail: 'Trader SocGen. Kodama tous les midis.',
  ),
  MapPlace(
    id: 'p_cl_clara_v',
    name: 'Clara V.',
    address: 'Tour Pacific, La Défense',
    lat: 48.892, lng: 2.236,
    category: PlaceCategory.customer,
    emoji: '🚀',
    detail: 'Marketing Lydia. Stress permanent.',
  ),
  MapPlace(
    id: 'p_cl_max_e',
    name: 'Maxime E.',
    address: '12 rue des Écoles, 5e',
    lat: 48.849, lng: 2.346,
    category: PlaceCategory.customer,
    emoji: '🎓',
    detail: 'Étudiant prépa. Pizza tous les jeudis.',
  ),
  MapPlace(
    id: 'p_cl_lea_d',
    name: 'Léa D.',
    address: '8 rue des Pyrénées, 20e',
    lat: 48.868, lng: 2.402,
    category: PlaceCategory.customer,
    emoji: '📚',
    detail: 'Master journalisme.',
  ),
  MapPlace(
    id: 'p_cl_lemaitre',
    name: 'Mme Lemaître',
    address: '4 rue Mirabeau, Vincennes',
    lat: 48.847, lng: 2.435,
    category: PlaceCategory.customer,
    emoji: '🏠',
    detail: 'Mère solo. Pizza dimanche soir religieuse.',
  ),
  MapPlace(
    id: 'p_cl_durand_famille',
    name: 'Famille Durand',
    address: '22 av. Parmentier, 11e',
    lat: 48.866, lng: 2.376,
    category: PlaceCategory.customer,
    emoji: '👨‍👩‍👧',
    detail: 'Bobo bohème. Healthy le soir.',
  ),
  MapPlace(
    id: 'p_cl_mr_chevalier',
    name: 'M. Chevalier',
    address: '15 rue du Bac, 7e',
    lat: 48.858, lng: 2.327,
    category: PlaceCategory.customer,
    emoji: '🎩',
    detail: '78 ans. Veuf. Bouillon Pigalle tous les jeudis.',
  ),
  MapPlace(
    id: 'p_cl_mme_dupont',
    name: 'Mme Dupont',
    address: '8 rue de Tournon, 6e',
    lat: 48.851, lng: 2.337,
    category: PlaceCategory.customer,
    emoji: '🌹',
    detail: '74 ans. Souvent fatiguée.',
  ),
  MapPlace(
    id: 'p_cl_mr_lebrun',
    name: 'M. Lebrun',
    address: '32 rue de Lancry, 10e',
    lat: 48.871, lng: 2.361,
    category: PlaceCategory.customer,
    emoji: '☕',
    detail: '82 ans. Habite seul depuis 7 ans.',
  ),
  MapPlace(
    id: 'p_cl_artiste_l',
    name: 'Léopold A.',
    address: '12 rue Charlot, 3e',
    lat: 48.861, lng: 2.362,
    category: PlaceCategory.customer,
    emoji: '🎨',
    detail: 'Artiste plasticien.',
  ),
  MapPlace(
    id: 'p_cl_writer_n',
    name: 'Nathalie B.',
    address: '18 rue Sedaine, 11e',
    lat: 48.856, lng: 2.376,
    category: PlaceCategory.customer,
    emoji: '✒️',
    detail: 'Écrivaine. Café froid + bowls.',
  ),
  MapPlace(
    id: 'p_cl_bar_after',
    name: 'Soirée Bar Charlie',
    address: '8 rue Saint-Maur, 11e',
    lat: 48.866, lng: 2.382,
    category: PlaceCategory.customer,
    emoji: '🍻',
    detail: 'Pizza à 3h du matin. Ivres.',
  ),
  MapPlace(
    id: 'p_cl_post_party',
    name: 'Pierre & co',
    address: '14 rue Keller, 11e',
    lat: 48.855, lng: 2.376,
    category: PlaceCategory.customer,
    emoji: '🌃',
    detail: '4h du matin. Burger.',
  ),
  MapPlace(
    id: 'p_cl_emma_fit',
    name: 'Emma S.',
    address: '5 rue Mabillon, 6e',
    lat: 48.853, lng: 2.335,
    category: PlaceCategory.customer,
    emoji: '💪',
    detail: 'Coach pilates. Bowl post-séance.',
  ),
  MapPlace(
    id: 'p_cl_aurelie_run',
    name: 'Aurélie F.',
    address: '22 av. Marceau, 8e',
    lat: 48.870, lng: 2.299,
    category: PlaceCategory.customer,
    emoji: '🏃‍♀️',
    detail: 'Triathlète.',
  ),
  MapPlace(
    id: 'p_cl_thomas_g',
    name: 'Thomas G.',
    address: '7 rue de Berri, 8e',
    lat: 48.872, lng: 2.290,
    category: PlaceCategory.customer,
    emoji: '💎',
    detail: 'Héritier. Tip 20 € systématique.',
  ),
  MapPlace(
    id: 'p_cl_helene_r',
    name: 'Hélène R.',
    address: '12 rue de Berri, 8e',
    lat: 48.873, lng: 2.302,
    category: PlaceCategory.customer,
    emoji: '💐',
    detail: 'Veuve aisée. Tip 15 € pour soutenir les jeunes.',
  ),
  MapPlace(
    id: 'p_cl_picky_b',
    name: 'Bertrand A.',
    address: '4 rue Vieille du Temple, 4e',
    lat: 48.855, lng: 2.358,
    category: PlaceCategory.customer,
    emoji: '🙄',
    detail: 'Avocat fiscaliste. Se plaint.',
  ),
  MapPlace(
    id: 'p_cl_picky_s',
    name: 'Sophie K.',
    address: '20 rue de Berri, 8e',
    lat: 48.871, lng: 2.282,
    category: PlaceCategory.customer,
    emoji: '😤',
    detail: 'Coach yoga divorcée. Note dur.',
  ),
  MapPlace(
    id: 'p_cl_zero_a',
    name: 'M. Renaud',
    address: 'Tour CB21, La Défense',
    lat: 48.892, lng: 2.240,
    category: PlaceCategory.customer,
    emoji: '🤷‍♂️',
    detail: 'Jamais de tip. Toujours poli.',
  ),
  MapPlace(
    id: 'p_cl_flirteur_a',
    name: 'Alexandre B.',
    address: '8 rue Saint-Antoine, 4e',
    lat: 48.854, lng: 2.362,
    category: PlaceCategory.customer,
    emoji: '😏',
    detail: 'Drague systématique.',
  ),
  MapPlace(
    id: 'p_cl_petit_g',
    name: 'Grégoire P.',
    address: '10 rue Saint-Sulpice, 6e',
    lat: 48.851, lng: 2.335,
    category: PlaceCategory.customer,
    emoji: '🙂',
    detail: 'Architecte. Courtois mais bref.',
  ),
  MapPlace(
    id: 'p_cl_enfant_t',
    name: 'Compte Théo (parents)',
    address: '15 rue Albert Thomas, 10e',
    lat: 48.870, lng: 2.366,
    category: PlaceCategory.customer,
    emoji: '🧒',
    detail: 'Enfant 9 ans passe la commande seul.',
  ),
  MapPlace(
    id: 'p_cl_bureau_anonyme_a',
    name: 'Bureau 12 · Total',
    address: 'Tour Total, La Défense',
    lat: 48.892, lng: 2.237,
    category: PlaceCategory.customer,
    emoji: '🏢',
    detail: 'Commande pour une équipe.',
  ),
  MapPlace(
    id: 'p_cl_tante_ly',
    name: 'Mme Lihua',
    address: '8 rue de Berri, 8e',
    lat: 48.872, lng: 2.289,
    category: PlaceCategory.customer,
    emoji: '🍵',
    detail: '81 ans. Tante de Tristan Heng.',
  ),
  MapPlace(
    id: 'p_cl_concierge_berri',
    name: 'Concierge Berri 12',
    address: '12 rue de Berri, 8e',
    lat: 48.873, lng: 2.302,
    category: PlaceCategory.customer,
    emoji: '🔑',
    detail: 'Concierge pour les Heng. Reçoit tout.',
  ),
  MapPlace(
    id: 'p_cl_hopital_tenon',
    name: 'Garde Tenon',
    address: 'Hôpital Tenon, 20e',
    lat: 48.872, lng: 2.396,
    category: PlaceCategory.customer,
    emoji: '🩺',
    detail: 'Infirmière de garde. Commande pour pause.',
  ),
  MapPlace(
    id: 'p_cl_residence_aubert',
    name: 'Résidence Aubert',
    address: '4 rue Aubert, Pantin',
    lat: 48.896, lng: 2.401,
    category: PlaceCategory.customer,
    emoji: '🌷',
    detail: 'Maison de retraite. Mme Boucher.',
  ),
  MapPlace(
    id: 'p_cl_juliette_m',
    name: 'Juliette M.',
    address: '32 rue Vieille du Temple, 3e',
    lat: 48.860, lng: 2.359,
    category: PlaceCategory.customer,
    emoji: '🪷',
    detail: 'Étudiante danse. Healthy bowls.',
  ),
];

/// Helper.
MapPlace mapPlaceById(String id) =>
    kMapPlaces.firstWhere((p) => p.id == id);

/// Helper : couleur du pin selon catégorie.
int colorForCategory(PlaceCategory cat) {
  switch (cat) {
    case PlaceCategory.heng:
      return 0xFF8B0000;
    case PlaceCategory.maman:
      return 0xFFD97757;
    case PlaceCategory.camille:
      return 0xFFFFB347;
    case PlaceCategory.restaurant:
      return 0xFF06C167;
    case PlaceCategory.customer:
      return 0xFF4FC3F7;
    case PlaceCategory.collision:
      return 0xFFFD297B;
    case PlaceCategory.rendezVous:
      return 0xFFB85A7C;
    case PlaceCategory.banque:
      return 0xFF1F4F8B;
    case PlaceCategory.medical:
      return 0xFF7A9A8C;
    case PlaceCategory.amitie:
      return 0xFFC4A07C;
    case PlaceCategory.travail:
      return 0xFF6B7280;
    case PlaceCategory.perso:
      return 0xFF1A1A1A;
  }
}

/// Label court catégorie.
String labelForCategory(PlaceCategory cat) {
  switch (cat) {
    case PlaceCategory.heng:
      return 'Heng';
    case PlaceCategory.maman:
      return 'Maman';
    case PlaceCategory.camille:
      return 'Camille';
    case PlaceCategory.restaurant:
      return 'Resto';
    case PlaceCategory.customer:
      return 'Client';
    case PlaceCategory.collision:
      return 'Mémoire';
    case PlaceCategory.rendezVous:
      return 'RDV';
    case PlaceCategory.banque:
      return 'Banque';
    case PlaceCategory.medical:
      return 'Médical';
    case PlaceCategory.amitie:
      return 'Ami';
    case PlaceCategory.travail:
      return 'Travail';
    case PlaceCategory.perso:
      return 'Perso';
  }
}
