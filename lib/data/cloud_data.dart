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
    subtitle: 'Janvier 2018 · 14 ans',
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
        'Papa, Maman a toussé encore cette nuit. Je crois que c\'est plus '
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
        '18 000 € sur six mois.\nProtocole expérimental.\n'
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
        'Suite à l\'étude de votre demande de crédit personnel n°7842, '
        'celle-ci est REFUSÉE.\n\n'
        'Motifs : revenus insuffisants, absence de garant éligible.\n\n'
        'Cordialement, BNP Paribas Belleville.',
  ),
  CloudItem(
    id: 'fiche_paye_avril',
    kind: CloudKind.document,
    title: 'Fiche de paie — Plateforme livraisons',
    subtitle: 'Avril 2026',
    folder: 'Banque',
    day: 1,
    body:
        '127 courses effectuées.\nBrut : 1 058 €.\n'
        'Pénalités : 412 €.\nNet : 646 €.',
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
];
