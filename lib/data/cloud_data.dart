/// Documents et fichiers stockés dans l'app Cloud — contrats,
/// ordonnances médicales, factures, lettres anciennes, photos d'archive.
/// C'est l'endroit où dort le grand mystère narratif.

enum CloudKind { document, photo, audio, video }

class CloudItem {
  final String id;
  final CloudKind kind;
  final String title;
  final String? subtitle;
  final String? folder; // "Documents", "Famille", "Hopital"...
  final int day; // jour à partir duquel l'item est visible
  final bool isDeleted; // file marked deleted, only visible via "récupérer"
  final String? body; // contenu du document (texte)
  /// Chemin asset image si l'item est une photo.
  final String? imagePath;
  /// Si non-null, l'item n'est visible que si l'attirance Tristan
  /// dépasse ce seuil. Sert aux items « intimes » (photos volées,
  /// notes tendres) qui n'apparaissent que quand Shen est proche.
  final int? requiresAttractionTristan;

  const CloudItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.day,
    this.subtitle,
    this.folder,
    this.isDeleted = false,
    this.body,
    this.imagePath,
    this.requiresAttractionTristan,
  });
}

const kCloudItems = <CloudItem>[
  // ─── Famille (toujours là, depuis le début) ───────────────────
  CloudItem(
    id: 'photo_helene_2019',
    kind: CloudKind.photo,
    title: 'Maman et moi · 2019',
    subtitle: 'Belleville, balcon, été',
    folder: 'Famille',
    day: 1,
  ),
  CloudItem(
    id: 'photo_papa_5ans',
    kind: CloudKind.photo,
    title: 'Papa · J\'avais 5 ans',
    subtitle: 'Cour de Yongchun, été 2007',
    folder: 'Famille',
    day: 1,
    imagePath: 'assets/photos/ep1/pj_papa_shen_5ans.webp',
  ),
  CloudItem(
    id: 'photo_billets_mei',
    kind: CloudKind.photo,
    title: 'Enveloppe Tante Mei',
    subtitle: '« Pour ma fille » · novembre 2025',
    folder: 'Famille',
    day: 1,
    imagePath: 'assets/photos/ep1/pj_tante_mei_billets.webp',
  ),
  CloudItem(
    id: 'lettre_papa_1',
    kind: CloudKind.document,
    title: 'Lettre n°127',
    subtitle: 'Décembre 2015 · 14 ans',
    folder: 'Famille',
    day: 1,
    body:
        'Papa, j\'ai eu 14 ans en novembre. Maman a fait des dumplings. '
        'Camille est venue. Je ne sais pas où tu es. Je continue d\'écrire.',
  ),
  CloudItem(
    id: 'lettre_papa_2',
    kind: CloudKind.document,
    title: 'Lettre n°304',
    subtitle: 'Mai 2026 · veille du J1',
    folder: 'Famille',
    day: 1,
    body:
        'Papa, Maman a encore toussé cette nuit. Je crois que c\'est plus '
        'grave qu\'elle ne le dit. Je voudrais que tu sois là pour qu\'elle '
        'arrête de mentir.',
  ),

  // ─── Hôpital Tenon ────────────────────────────────────────────
  CloudItem(
    id: 'ordonnance_tenon_avril',
    kind: CloudKind.document,
    title: 'Ordonnance — Avril 2026',
    subtitle: 'Dr Aubin · Néphrologie',
    folder: 'Hôpital',
    day: 1,
    body:
        'Hélène Marchand, née 1976. Traitement entretien. Renouvelable. '
        'Prochaine consultation : juin 2026.',
  ),
  CloudItem(
    id: 'devis_tenon_J2',
    kind: CloudKind.document,
    title: 'Devis traitement seconde ligne',
    subtitle: 'Hors AMM — non remboursé',
    folder: 'Hôpital',
    day: 2,
    body:
        '18 000 € sur six mois.\nProtocole expérimental.\n'
        'À commencer sous six semaines.\nDr Aubin — Tenon Néphrologie.',
  ),

  // ─── Documents (contrats, banque) ─────────────────────────────
  CloudItem(
    id: 'refus_credit',
    kind: CloudKind.document,
    title: 'BNP — Refus de crédit n°7842',
    subtitle: 'Document officiel',
    folder: 'Banque',
    day: 3,
    body:
        'Mademoiselle Marchand,\n\n'
        'À la suite de l\'étude de votre demande de crédit personnel n°7842, '
        'celle-ci est REFUSÉE.\n\n'
        'Motifs : revenus insuffisants, absence de garant éligible.\n\n'
        'Cordialement, BNP Paribas Belleville.',
  ),
  // ── Idée 2 : Demande de crédit initiale (J-20) ────────────────
  CloudItem(
    id: 'demande_credit_initiale',
    kind: CloudKind.document,
    title: 'BNP — Demande de crédit n°7842',
    subtitle: 'Document scanné · 14 mai 2026',
    folder: 'Banque',
    day: 1,
    body:
        'Bénéficiaire : Marchand Shen, née le 12 novembre 2001.\n\n'
        'Montant demandé : 18 000 €.\n'
        'Durée : 36 mois.\n'
        'Garant : sans (case « ne pas inclure ma mère » cochée).\n\n'
        'Document envoyé en ligne le 14 mai. Sans en parler à personne.',
  ),
  // ── Idée 9 : Photo Maman J-30 bien portante ───────────────────
  CloudItem(
    id: 'photo_maman_avant',
    kind: CloudKind.photo,
    title: 'Maman · mai 2026',
    subtitle: 'Marché Belleville · 7 mai',
    folder: 'Famille',
    day: 1,
    imagePath: 'assets/photos/avatars/maman.webp',
    body: 'Avant que je sache.',
  ),
  // ── Idée 6 : Story Insta archivée par erreur ───────────────────
  CloudItem(
    id: 'story_carte_recollee',
    kind: CloudKind.photo,
    title: 'Story · 23h47',
    subtitle: 'Postée 30 min puis supprimée',
    folder: 'Documents',
    day: 2,
    isDeleted: true,
    imagePath: 'assets/photos/ep1/j01_23h42_carte_recollee.webp',
    body:
        'Je l\'ai postée par erreur. Camille a vu — elle n\'a rien dit. '
        'Je l\'ai supprimée comme on retire un pull à la va-vite.',
  ),
  CloudItem(
    id: 'fiche_paye_avril',
    kind: CloudKind.document,
    title: 'Fiche de paie — Plateforme livraisons',
    subtitle: 'Avril 2026',
    folder: 'Banque',
    day: 1,
    body:
        '127 courses effectuées.\nBrut : 1 058 €.\n'
        'Pénalités : 412 €.\nNet : 646 €.',
  ),

  // ─── Items supprimés (récupérables) ───────────────────────────
  CloudItem(
    id: 'sms_papa_supprime',
    kind: CloudKind.document,
    title: 'Brouillon SMS · jamais envoyé',
    subtitle: 'À ?? · 11 octobre 2025',
    folder: 'Documents',
    day: 1,
    isDeleted: true,
    body:
        'Si tu lis ça, c\'est que j\'ai trouvé ton numéro. Je m\'appelle '
        'Shen. Je suis ta fille. Maman dit que tu n\'as pas pu venir.',
  ),
  CloudItem(
    id: 'photo_vincent_supprime',
    kind: CloudKind.photo,
    title: 'Inconnu · 12 novembre 2025',
    subtitle: 'Selfie · Café Hanami',
    folder: 'Famille',
    day: 1,
    isDeleted: true,
  ),

  // ─── Items conditionnels (révélés selon jauges) ───────────────────
  CloudItem(
    id: 'note_tristan_tendre',
    kind: CloudKind.document,
    title: 'Note manuscrite — Tristan',
    subtitle: 'Glissée sous la porte · 09:42',
    folder: 'Documents',
    day: 11,
    requiresAttractionTristan: 30,
    body:
        'Mlle Marchand,\n\n'
        'Le café est sur la table. Pas de sucre.\n'
        'Vous ne dormez pas la nuit. Je l\'entends.\n\n'
        'T.',
  ),
  CloudItem(
    id: 'photo_tristan_dormant',
    kind: CloudKind.photo,
    title: 'Tristan · endormi',
    subtitle: '6h12 · canapé bureau',
    folder: 'Famille',
    day: 13,
    requiresAttractionTristan: 50,
    imagePath: 'assets/photos/avatars/tristan.webp',
  ),
];
