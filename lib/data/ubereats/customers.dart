/// Catalogue de 30 clients UberEats pour Shen — du cadre pressé du 8e
/// au vieux isolé du Marais qui veut parler 10 minutes.
library;

import '../../models/ubereats.dart';

const kCustomers = <UberCustomer>[
  // ── Cadres pressés ────────────────────────────────────────────
  UberCustomer(
    id: 'cl_bonnard',
    displayName: 'Madame Bonnard',
    kind: CustomerKind.cadrePresse,
    zone: UberZone.champsLuxe,
    address: '24 av. Montaigne, 8e',
    building: '4e étage gauche · interphone 12B · code 4297',
    emoji: '👔',
    bio: 'Avocate associée. Commande chaque matin un bowl açaí avant 9h.',
    avgTip: 0.5,
    notesPool: [
      'Merci. Sans contact.',
      'Laissez devant la porte.',
      'Vous êtes en retard. -1 ⭐.',
    ],
    isRecurring: true,
  ),
  UberCustomer(
    id: 'cl_morel',
    displayName: 'M. Morel',
    kind: CustomerKind.cadrePresse,
    zone: UberZone.champsLuxe,
    address: '5 rue Marbeuf, 8e',
    building: '7e étage · code 8521',
    emoji: '💼',
    bio: 'Trader Société Générale. Commande Kodama tous les midis.',
    avgTip: 1.0,
    notesPool: ['Rapide svp.', 'Sans contact.'],
    isRecurring: true,
  ),
  UberCustomer(
    id: 'cl_clara_v',
    displayName: 'Clara V.',
    kind: CustomerKind.startupper,
    zone: UberZone.defense,
    address: 'Tour Pacific, La Défense',
    building: 'Accueil 23e étage · badge livreur',
    emoji: '🚀',
    bio: 'Marketing manager Lydia. Stress permanent.',
    avgTip: 2.0,
    notesPool: ['Asap please.', 'Drop & go.'],
  ),

  // ── Étudiants ─────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_max_e',
    displayName: 'Maxime E.',
    kind: CustomerKind.etudiant,
    zone: UberZone.saintGermain,
    address: '12 rue des Écoles, 5e',
    building: '6e étage sans ascenseur',
    emoji: '🎓',
    bio: 'Étudiant prépa. Pizza tous les jeudis.',
    avgTip: 0.5,
    notesPool: [
      'Désolé pas de tip ce mois. Stages bénévoles 🙃',
      'Merci !',
    ],
  ),
  UberCustomer(
    id: 'cl_lea_d',
    displayName: 'Léa D.',
    kind: CustomerKind.etudiant,
    zone: UberZone.belleville,
    address: '8 rue des Pyrénées, 20e',
    building: '3e étage · accès jardin',
    emoji: '📚',
    bio: 'Master journalisme. Café & burger.',
    avgTip: 1.0,
    notesPool: ['Merci !! ❤', 'Bon courage avec la pluie.'],
  ),

  // ── Familles ──────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_lemaitre',
    displayName: 'Mme Lemaître',
    kind: CustomerKind.meresoloEnfant,
    zone: UberZone.vincennes,
    address: '4 rue Mirabeau, Vincennes',
    building: 'Maison · sonnez 2 fois',
    emoji: '🏠',
    bio: 'Mère solo. 3 enfants. Pizza dimanche soir religieuse.',
    avgTip: 3.0,
    notesPool: [
      'Merci la livreuse. Vous êtes adorable.',
      'Garde la monnaie. Bonne soirée.',
    ],
    isRecurring: true,
  ),
  UberCustomer(
    id: 'cl_durand_famille',
    displayName: 'Famille Durand',
    kind: CustomerKind.meresoloEnfant,
    zone: UberZone.republique,
    address: '22 av. Parmentier, 11e',
    building: '2e étage · porte verte',
    emoji: '👨‍👩‍👧',
    bio: 'Famille bobo bohème. Commande sain le soir.',
    avgTip: 2.0,
    notesPool: ['Sans glace svp.', 'Merci !'],
  ),

  // ── Vieux classiques ──────────────────────────────────────────
  UberCustomer(
    id: 'cl_mr_chevalier',
    displayName: 'M. Chevalier',
    kind: CustomerKind.vieuxClassique,
    zone: UberZone.saintGermain,
    address: '15 rue du Bac, 7e',
    building: '5e étage · sonnez fort',
    emoji: '🎩',
    bio: '78 ans. Veuf. Commande Bouillon Pigalle tous les jeudis.',
    avgTip: 5.0,
    notesPool: [
      'Merci mademoiselle.',
      'Vous me sauvez. À jeudi prochain.',
      'Voici un petit billet. Vous êtes courageuse.',
    ],
    isRecurring: true,
  ),
  UberCustomer(
    id: 'cl_mme_dupont',
    displayName: 'Mme Dupont',
    kind: CustomerKind.vieuxClassique,
    zone: UberZone.saintGermain,
    address: '8 rue de Tournon, 6e',
    building: 'Rez-de-chaussée · jardin',
    emoji: '🌹',
    bio: '74 ans. Souvent fatiguée. Repas chinois classique.',
    avgTip: 4.0,
    notesPool: [
      'Merci. Tenez bon.',
      'Mes amitiés.',
    ],
  ),

  // ── Vieux isolés (demande à parler) ───────────────────────────
  UberCustomer(
    id: 'cl_mr_lebrun',
    displayName: 'M. Lebrun',
    kind: CustomerKind.vieuxIsole,
    zone: UberZone.republique,
    address: '32 rue de Lancry, 10e',
    building: '4e étage · digicode 1208',
    emoji: '☕',
    bio: '82 ans. Habite seul depuis 7 ans. Commande pour avoir un visage.',
    avgTip: 10.0,
    notesPool: [
      'Vous avez 2 minutes ? Je vous offre un café.',
      'Merci. Vous me rappelez quelqu\'un.',
      'Tenez. C\'est pas grand-chose mais.',
    ],
    isRecurring: true,
  ),

  // ── Bobos / artistes ──────────────────────────────────────────
  UberCustomer(
    id: 'cl_artiste_l',
    displayName: 'Léopold A.',
    kind: CustomerKind.bobo,
    zone: UberZone.marais,
    address: '12 rue Charlot, 3e',
    building: '3e étage · porte rouge',
    emoji: '🎨',
    bio: 'Artiste plasticien. Réussit le slow living.',
    avgTip: 2.5,
    notesPool: [
      'Merci. Bonne énergie ce matin.',
      'Vous êtes l\'âme du quartier.',
    ],
  ),
  UberCustomer(
    id: 'cl_writer_n',
    displayName: 'Nathalie B.',
    kind: CustomerKind.bobo,
    zone: UberZone.bastille,
    address: '18 rue Sedaine, 11e',
    building: '5e étage · sonnez prénom',
    emoji: '✒️',
    bio: 'Écrivaine. Boit du café froid en commandant des bowls.',
    avgTip: 3.0,
    notesPool: ['Merci. Tenez chaud.', 'Bonne plume.'],
  ),

  // ── Noctambules ───────────────────────────────────────────────
  UberCustomer(
    id: 'cl_bar_after',
    displayName: 'Soiree Bar Charlie',
    kind: CustomerKind.noctambule,
    zone: UberZone.republique,
    address: '8 rue Saint-Maur, 11e',
    building: 'Sonnez interphone 3B',
    emoji: '🍻',
    bio: 'Bande de 4. Pizza à 3h du matin. Ivres.',
    avgTip: 1.0,
    notesPool: [
      'MERCIIIIIII',
      'Tu veux une bière ?',
      'Désolé j\'ai dormi 5 min.',
    ],
  ),
  UberCustomer(
    id: 'cl_post_party',
    displayName: 'Pierre & co',
    kind: CustomerKind.noctambule,
    zone: UberZone.bastille,
    address: '14 rue Keller, 11e',
    building: 'Sonnez fort',
    emoji: '🌃',
    bio: '4h du matin. Burger absolument nécessaire.',
    avgTip: 0.5,
    notesPool: ['Cool merci.', 'Désolé.'],
  ),

  // ── Gym girls ─────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_emma_fit',
    displayName: 'Emma S.',
    kind: CustomerKind.gymGirl,
    zone: UberZone.saintGermain,
    address: '5 rue Mabillon, 6e',
    building: '4e étage · sans glace',
    emoji: '💪',
    bio: 'Coach pilates. Bowl post-séance.',
    avgTip: 0.0,
    notesPool: [
      'No tip mais 5 ⭐.',
      'Pas de glace svp.',
    ],
  ),
  UberCustomer(
    id: 'cl_aurelie_run',
    displayName: 'Aurélie F.',
    kind: CustomerKind.gymGirl,
    zone: UberZone.champsLuxe,
    address: '22 av. Marceau, 8e',
    building: '6e étage · digicode 1234',
    emoji: '🏃‍♀️',
    bio: 'Triathlète. Healthy bowl avant courrses.',
    avgTip: 0.0,
    notesPool: ['Merci.', 'Tenez bon.'],
  ),

  // ── Generosity max ────────────────────────────────────────────
  UberCustomer(
    id: 'cl_thomas_g',
    displayName: 'Thomas G.',
    kind: CustomerKind.generosityMax,
    zone: UberZone.fochAvenue,
    address: '7 av. Foch, 16e',
    building: 'Hôtel particulier · gardien',
    emoji: '💎',
    bio: 'Hériter. Commande beaucoup. Tip 20 € systématique.',
    avgTip: 20.0,
    notesPool: [
      'Merci. Bonne journée.',
      'Pour vous. Sincèrement.',
    ],
  ),
  UberCustomer(
    id: 'cl_helene_r',
    displayName: 'Hélène R.',
    kind: CustomerKind.generosityMax,
    zone: UberZone.fochAvenue,
    address: '12 av. Foch, 16e',
    building: 'Concierge · 2e étage',
    emoji: '💐',
    bio: 'Veuve aisée. Tip pour soutenir les jeunes.',
    avgTip: 15.0,
    notesPool: ['Merci ma fille.', 'Mes pensées.'],
  ),

  // ── Picky ─────────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_picky_b',
    displayName: 'Bertrand A.',
    kind: CustomerKind.picky,
    zone: UberZone.marais,
    address: '4 rue Vieille du Temple, 4e',
    building: '3e étage',
    emoji: '🙄',
    bio: 'Avocat fiscaliste. Se plaint systématiquement.',
    avgTip: 0.0,
    notesPool: [
      'Sushis tièdes. -2 ⭐.',
      'Trop long. Pas content.',
    ],
  ),
  UberCustomer(
    id: 'cl_picky_s',
    displayName: 'Sophie K.',
    kind: CustomerKind.picky,
    zone: UberZone.fochAvenue,
    address: '20 av. Foch, 16e',
    building: '1er étage',
    emoji: '😤',
    bio: 'Coach yoga divorcée. Note dur.',
    avgTip: 0.0,
    notesPool: ['Sauce manquante. -1.', 'Pas content.'],
  ),

  // ── Zero tip ──────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_zero_a',
    displayName: 'M. Renaud',
    kind: CustomerKind.pourboireZero,
    zone: UberZone.defense,
    address: 'Tour CB21, La Défense',
    building: 'Accueil',
    emoji: '🤷‍♂️',
    bio: 'Cadre supérieur. Jamais de tip. Toujours poli.',
    avgTip: 0.0,
    notesPool: ['Merci.'],
  ),

  // ── Flirteur ──────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_flirteur_a',
    displayName: 'Alexandre B.',
    kind: CustomerKind.flirteur,
    zone: UberZone.bastille,
    address: '8 rue Saint-Antoine, 4e',
    building: '5e étage',
    emoji: '😏',
    bio: '32 ans. Drague systématique au livreur.',
    avgTip: 2.0,
    notesPool: [
      'Vous êtes très belle. Si jamais.',
      'Mon numéro est sur la commande 😉',
    ],
  ),

  // ── Polis et secs ─────────────────────────────────────────────
  UberCustomer(
    id: 'cl_petit_g',
    displayName: 'Grégoire P.',
    kind: CustomerKind.pressePolite,
    zone: UberZone.saintGermain,
    address: '10 rue Saint-Sulpice, 6e',
    building: '3e étage gauche',
    emoji: '🙂',
    bio: 'Architecte. Courtois mais bref.',
    avgTip: 1.0,
    notesPool: ['Merci.', 'Très bien.'],
  ),

  // ── Enfants confus ────────────────────────────────────────────
  UberCustomer(
    id: 'cl_enfant_t',
    displayName: 'Compte Théo (parents)',
    kind: CustomerKind.enfantConfus,
    zone: UberZone.republique,
    address: '15 rue Albert Thomas, 10e',
    building: '2e étage · porte avec dessin',
    emoji: '🧒',
    bio: 'Compte parents. Enfant 9 ans a passé la commande seul.',
    avgTip: 0.5,
    notesPool: [
      'MERCI pour la pizza j\'avais faim',
      'TROP COOL',
    ],
  ),

  // ── Bureaux / défense ─────────────────────────────────────────
  UberCustomer(
    id: 'cl_bureau_anonyme_a',
    displayName: 'Bureau 12 · Total',
    kind: CustomerKind.cadrePresse,
    zone: UberZone.defense,
    address: 'Tour Total, La Défense',
    building: 'Accueil · badge requis',
    emoji: '🏢',
    bio: 'Commande pour une équipe. Reçu sur fiche.',
    avgTip: 0.0,
    notesPool: ['Bureau 12 svp.', 'Merci.'],
  ),

  // ── Vieille dame Tante ────────────────────────────────────────
  UberCustomer(
    id: 'cl_tante_ly',
    displayName: 'Mme Lihua',
    kind: CustomerKind.vieuxClassique,
    zone: UberZone.fochAvenue,
    address: '8 av. Foch, 16e',
    building: 'Concierge · 4e étage',
    emoji: '🍵',
    bio: '81 ans. Tante de Tristan Heng. Commande Long Jing chez Wong.',
    avgTip: 8.0,
    notesPool: [
      'Merci ma fille.',
      'Vous êtes très polie.',
    ],
    isRecurring: true,
  ),

  // ── Concierge Foch ────────────────────────────────────────────
  UberCustomer(
    id: 'cl_concierge_foch',
    displayName: 'Concierge Foch 12',
    kind: CustomerKind.cadrePresse,
    zone: UberZone.fochAvenue,
    address: '12 av. Foch, 16e',
    building: 'Loge entrée',
    emoji: '🔑',
    bio: 'Concierge pour les Heng. Reçoit toutes les commandes.',
    avgTip: 0.0,
    notesPool: ['Merci. Posez ici.'],
  ),

  // ── Hôpital ───────────────────────────────────────────────────
  UberCustomer(
    id: 'cl_hopital_tenon',
    displayName: 'Garde Tenon',
    kind: CustomerKind.cadrePresse,
    zone: UberZone.belleville,
    address: 'Hôpital Tenon, 20e',
    building: 'Accueil pavillon C',
    emoji: '🩺',
    bio: 'Infirmière de garde. Commande pour pause repas.',
    avgTip: 1.5,
    notesPool: [
      'Merci la collègue.',
      'Bon courage.',
    ],
  ),

  // ── Maison de retraite ────────────────────────────────────────
  UberCustomer(
    id: 'cl_residence_aubert',
    displayName: 'Résidence Aubert',
    kind: CustomerKind.vieuxIsole,
    zone: UberZone.pantin,
    address: '4 rue Aubert, Pantin',
    building: 'Accueil · scanner code',
    emoji: '🌷',
    bio: 'Maison de retraite. Madame Boucher commande pizza pour les pensionnaires jeudis.',
    avgTip: 5.0,
    notesPool: [
      'Merci. Les pensionnaires adorent.',
      'Vous nous sauvez le mercredi.',
    ],
    isRecurring: true,
  ),

  // ── Marais bohème jeune ───────────────────────────────────────
  UberCustomer(
    id: 'cl_juliette_m',
    displayName: 'Juliette M.',
    kind: CustomerKind.bobo,
    zone: UberZone.marais,
    address: '32 rue Vieille du Temple, 3e',
    building: '4e étage · sonnez 2x',
    emoji: '🪷',
    bio: 'Étudiante danse. Commande healthy bowls.',
    avgTip: 1.5,
    notesPool: ['Merci !', 'Mes pensées.'],
  ),

  // ── Camille (gag) ─────────────────────────────────────────────
  UberCustomer(
    id: 'cl_camille_gag',
    displayName: 'Camille Roux',
    kind: CustomerKind.generosityMax,
    zone: UberZone.bastille,
    address: 'TON appart imbécile',
    building: 'Tu sais où c\'est',
    emoji: '🥐',
    bio: 'Ta meilleure amie. Commande des croissants pour TE faire venir.',
    avgTip: 5.0,
    notesPool: [
      'Espèce de gourde. J\'ai commandé pour qu\'on bouffe ensemble.',
      'Allez viens, je paie.',
    ],
  ),
];

/// Helper.
UberCustomer customerById(String id) =>
    kCustomers.firstWhere((c) => c.id == id);
