/// Entrées du journal intime de Shen — l'app Notes remplace le carnet.
/// Voix : 1re personne, ironie sèche, bic vert.

class NoteEntry {
  final int day;
  final String time;
  final String title;
  final String body;
  final bool starred;
  /// True quand Shen a commencé la note puis l'a abandonnée — affichée
  /// barrée + tag « brouillon » + 3 points hésitants en fin de body.
  final bool draft;

  const NoteEntry({
    required this.day,
    required this.time,
    required this.title,
    required this.body,
    this.starred = false,
    this.draft = false,
  });
}

const kNotes = <NoteEntry>[
  // ── Note préliminaire J0 (la veille du 3 juin) ────────────────
  NoteEntry(
    day: 1,
    time: '23:14',
    title: 'La veille',
    body:
        'Maman a toussé cette nuit.\n'
        'Ce n\'est rien. C\'est juste la fatigue. Ce n\'est rien.\n\n'
        'Je l\'écris pour ne plus y penser. Ça marche jamais.',
  ),
  // ── Brouillons abandonnés (notes ratées) ───────────────────────
  NoteEntry(
    day: 1,
    time: '12:18',
    title: 'Pour le médecin',
    body: 'Lui demander si Maman peut\n'
        'prendre le métro encore\n'
        'ou si elle doit',
    draft: true,
  ),
  NoteEntry(
    day: 3,
    time: '08:04',
    title: 'Lettre à Papa',
    body: 'Tu ne lis pas ces lettres.\n'
        'Tu n\'as jamais lu une seule\n'
        'des cent trente que j\'ai',
    draft: true,
  ),
  NoteEntry(
    day: 1,
    time: '07:42',
    title: 'Premier carnet',
    body:
        'Maman a toussé à quatre heures du matin.\n'
        'J\'ai fait semblant de dormir. Si elle sait que je l\'ai entendue, elle s\'excusera.\n'
        'Maman s\'excuse de tomber malade. Je ne supporte pas.\n\n'
        'Camille m\'a dit que si je n\'écris pas, je vais oublier de vivre. Je n\'écris pas pour me souvenir. J\'écris pour ne pas pleurer.',
    starred: true,
  ),
  NoteEntry(
    day: 1,
    time: '23:42',
    title: 'Première erreur',
    body:
        'La carte est recollée sur l\'étagère. Quatre morceaux, ruban adhésif transparent.\n\n'
        'Personne — pas même moi — ne saurait dire à quel moment je l\'ai ramassée dans la flaque.\n\n'
        'Le bruit du scotch qui se déchire. Quatre fois. Le « T » de Tristan refuse de '
        'se réaligner ; je recommence deux fois. Le chien du voisin a hurlé pendant '
        'quatre minutes pile à minuit.\n\n'
        'Première erreur.',
    starred: true,
  ),
  NoteEntry(
    day: 2,
    time: '07:24',
    title: 'Compteur J42',
    body:
        'Dix-huit mille euros.\n'
        'Six semaines.\n'
        'Quarante-deux jours.\n'
        'Le compteur démarre maintenant.\n\n'
        'Sur mon compte courant : 2 384 €. C\'est déjà un miracle de fin de mois.\n\n'
        'L\'infirmière a dit : « Faites attention à ce qu\'elle vous dit. »\n'
        'Maman ne dit pas tout. Maman ne dit pas tout.',
    starred: true,
  ),
  // ── Note J2 charnelle : odeurs du métro, lumière Tenon ─────────
  NoteEntry(
    day: 2,
    time: '06:42',
    title: 'Couronnes',
    body:
        'Métro Couronnes à 6h25. L\'odeur du dépôt de bus mêlée au '
        'café froid des poubelles. Trois personnes qui font semblant '
        'de dormir debout.\n\n'
        'Couloir K, niveau 2, Tenon. Néons qui clignotent sur la deuxième '
        'rangée. La carrelage sent le savon noir. La femme du ménage a '
        'détourné les yeux quand je suis passée.\n\n'
        'Ce sont les détails qui restent. Pas les mots du médecin.',
  ),
  NoteEntry(
    day: 3,
    time: '15:48',
    title: 'Trois colonnes',
    body:
        'Calculs. Calculs. Calculs.\n\n'
        'Doubler les livraisons : +400 €/mois.\n'
        'Service de nuit : +600 €. Je ne dormirais plus.\n'
        'Vendre le piano de Maman : hors de question.\n\n'
        'Total potentiel sur six mois : 6 000 €.\n'
        'Manque : 12 000 €.\n'
        'Marge d\'erreur : zéro.',
  ),
  NoteEntry(
    day: 3,
    time: '20:31',
    title: 'Deux portes fermées',
    body:
        'Banque : pas de garant éligible. Refus.\n'
        'Aide sociale : six mois minimum d\'instruction. Vivaldi en sourdine.\n\n'
        'Six mois.\n'
        'Maman a six semaines.\n\n'
        'Deux portes. Fermées.',
  ),
  NoteEntry(
    day: 3,
    time: '23:58',
    title: 'Le scotch attend',
    body:
        'Le scotch est sur la table.\n'
        'Les quatre morceaux sont alignés depuis avant-hier.\n\n'
        'Plus tard, je ne saurai pas dire à quel moment j\'ai décidé.\n'
        'Le « T » de Tristan refuse de se réaligner. Je recommence deux fois.\n\n'
        'Le numéro est lisible.\n'
        'C\'est ridicule.\n'
        'Le numéro est lisible.',
    starred: true,
  ),
  // J6 — la veille du rendez-vous Tour Heng
  NoteEntry(
    day: 6,
    time: '22:31',
    title: 'Le tailleur',
    body:
        'Camille a apporté un tailleur. Noir. 38.\n'
        '« Tu vas plaider ta propre affaire. »\n\n'
        'Le miroir me dit quelqu\'un d\'autre. Pas plus belle, pas moins. '
        'Juste plus coupée. Plus tranchante.\n\n'
        'Demain 11h. Tour Heng. 47ᵉ étage.',
    starred: true,
  ),
  // J7 — après la Tour Heng
  NoteEntry(
    day: 7,
    time: '12:48',
    title: 'Ce que j\'avais pas prévu',
    body:
        'Il avait préparé un dossier AVANT que j\'arrive.\n'
        'Donc il savait que je viendrais.\n\n'
        '— J\'ai mieux qu\'un prêt. Une proposition. Trois mois.\n\n'
        'Trente mille euros.\n'
        'Fausse fiancée.\n'
        'J\'ai dit oui.\n\n'
        'J\'ai dit oui avec des clauses au stylo dans la marge.',
    starred: true,
  ),
  // J11 — premier mensonge à Maman
  NoteEntry(
    day: 11,
    time: '21:14',
    title: 'Lao Chen',
    body:
        'J\'ai inventé un patron qui s\'appelle Lao Chen. Sino-français, '
        '60 ans, potagers pédagogiques.\n\n'
        'Maman me croit. C\'est ça le pire.\n'
        'Ou alors elle ne me croit pas et elle joue le jeu pour me protéger.\n\n'
        'Je ne sais plus laquelle des deux je préfère.',
  ),
  // J14 — après le premier dîner Madame Heng
  NoteEntry(
    day: 14,
    time: '23:42',
    title: 'Long Jing, deuxième récolte',
    body:
        'Six personnes autour de la table.\n'
        'Madame Heng m\'a regardé porter la tasse à mes lèvres.\n\n'
        '— Je crois que c\'est de la deuxième.\n\n'
        'Silence. Elle repose sa tasse.\n'
        '— Tu as raison, ma fille.\n\n'
        'Elle a dit *ma fille*. En français. Ce n\'est pas anodin.',
    starred: true,
  ),
];
