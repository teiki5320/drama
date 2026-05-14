/// Entrées du journal intime de Shen — l'app Notes remplace le carnet.
/// Voix : 1re personne, ironie sèche, bic vert.

class NoteEntry {
  final int day;
  final String time;
  final String title;
  final String body;
  final bool starred;

  const NoteEntry({
    required this.day,
    required this.time,
    required this.title,
    required this.body,
    this.starred = false,
  });
}

const kNotes = <NoteEntry>[
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
];
