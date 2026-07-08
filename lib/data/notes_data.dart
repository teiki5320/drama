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
  /// Si non-null, la note n'apparaît que si la suspicion Maman est
  /// >= ce seuil. Sert aux notes « la mère a cherché » qui ne sont
  /// déclenchées que si Shen a menti.
  final int? requiresSuspicionMaman;

  const NoteEntry({
    required this.day,
    required this.time,
    required this.title,
    required this.body,
    this.starred = false,
    this.draft = false,
    this.requiresSuspicionMaman,
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
  // Brouillon Tinder — après 10 swipes (déclenché par l'app Tinder)
  NoteEntry(
    day: 3,
    time: '23:40',
    title: 'Dix swipes',
    body:
        'Quentin, Antoine, Léo, Maxime, Hugo, Damien.\n'
        'Sébastien qui médite, Karim qui photographie.\n\n'
        'J\'ai swipé non parce que je suis encore vivante.\n'
        'J\'ai swipé non parce que',
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
        'Sur mon compte courant : 2 384 €. C\'est déjà un miracle de fin de mois.\n\n'
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
        'rangée. Le carrelage sent le savon noir. La femme du ménage a '
        'détourné les yeux quand je suis passée.\n\n'
        'Ce sont les détails qui restent. Pas les mots du médecin.',
  ),
  NoteEntry(
    day: 3,
    time: '15:48',
    title: 'Trois colonnes',
    body:
        'Calculs. Calculs. Calculs.\n\n'
        'Doubler les livraisons : +400 €/mois.\n'
        'Service de nuit : +600 €. Je ne dormirais plus.\n'
        'Vendre le piano de Maman : hors de question.\n\n'
        'Total potentiel sur six mois : 6 000 €.\n'
        'Manque : 12 000 €.\n'
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
  // J5 — Combler la journée vide (samedi 7 juin)
  NoteEntry(
    day: 5,
    time: '11:24',
    title: 'Vingt-quatre heures',
    body:
        'J\'ai passé hier à dire à Camille que je ne rappellerai pas.\n'
        'J\'ai passé ce matin à composer le numéro trois fois sans appuyer.\n\n'
        'Le scotch sur la carte tient encore. Le « T » de Tristan, lui, '
        'n\'a jamais voulu se réaligner.',
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
        'Demain 11h. Tour Heng. 47e étage.',
    starred: true,
  ),
  // J7 — Brouillon abandonné le soir, après la Tour Heng
  NoteEntry(
    day: 7,
    time: '21:00',
    title: 'Trois mois',
    body:
        'Trois mois.\n'
        'Comme un stage.\n'
        'Sans la prime. Sans rien.\n'
        'Si je signe, je',
    draft: true,
  ),
  // J7 — après la Tour Heng
  NoteEntry(
    day: 7,
    time: '12:48',
    title: 'Ce que je n\'avais pas prévu',
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
  // J8 — Signature notariale, voix sèche
  NoteEntry(
    day: 8,
    time: '12:48',
    title: 'Quatorze pages',
    body:
        'Article 7. Clause de discrétion absolue. Dix ans après la fin.\n'
        'Article 11. Aucune contestation publique, civile, professionnelle.\n'
        'Article 14. En cas de rupture unilatérale, indemnité de 30 000 €.\n\n'
        'J\'ai signé. Mon stylo a tremblé sur le « M » de Marchand.\n'
        'Personne n\'a vu.',
    starred: true,
  ),

  // J9 — Soir d'emménagement rue de Berri
  NoteEntry(
    day: 9,
    time: '23:18',
    title: 'Penderie',
    body:
        'Trois affaires posées dans une penderie qui en accueillait '
        'cinquante. Le silence, ici, n\'est pas le même qu\'à Belleville. '
        'Il a été acheté.\n\n'
        'Maman ne saura pas avant J11. Je dors sur l\'oreiller de droite, '
        'celui qui sent le neuf.',
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
  // J12 — Note conditionnelle si suspicion Maman ≥ 30 (Idée 14)
  NoteEntry(
    day: 12,
    time: '22:08',
    title: 'Pages jaunes',
    body:
        'Elle a cherché Lao Chen dans l\'annuaire.\n'
        'Elle a cherché.\n\n'
        'Je n\'ai pas réfléchi quand j\'ai inventé un nom. '
        'Elle, oui.',
    requiresSuspicionMaman: 30,
  ),

  // J14 — après le premier dîner Madame Heng
  NoteEntry(
    day: 14,
    time: '23:42',
    title: 'Long Jing, deuxième récolte',
    body:
        'Six personnes autour de la table.\n'
        'Madame Heng m\'a regardée porter la tasse à mes lèvres.\n\n'
        '— Je crois que c\'est de la deuxième.\n\n'
        'Silence. Elle repose sa tasse.\n'
        '— Tu as raison, ma fille.\n\n'
        'Elle a dit *ma fille*. En français. Ce n\'est pas anodin.',
    starred: true,
  ),
  // J14 — Brouillon final du cliffhanger Ep 1
  NoteEntry(
    day: 14,
    time: '23:58',
    title: 'Pour Maman',
    body:
        'Maman.\n'
        'Je ne sais plus comment te dire que',
    draft: true,
  ),

  // ── Ep 2 — La routine du mensonge ──
  NoteEntry(
    day: 15,
    time: '08:31',
    title: 'Deuxième récolte',
    body:
        '« Vous avez identifié la deuxième récolte. »\n\n'
        'Huit mots à 8h12. Pas de bonjour. Pas de signature.\n'
        'Chez les Heng, c\'est une médaille.\n\n'
        'Je l\'ai relue quatre fois. Je déteste que ça me fasse ça.',
  ),
  NoteEntry(
    day: 23,
    time: '22:10',
    title: 'La boîte',
    body:
        'Maman a trouvé le Long Jing dans mon sac.\n'
        'Elle s\'est excusée de l\'avoir trouvé. Elle. À moi.\n\n'
        'C\'est exactement dans cet ordre que le mensonge abîme : '
        'd\'abord les autres demandent pardon à ta place.',
    starred: true,
  ),
  NoteEntry(
    day: 30,
    time: '23:44',
    title: 'Jeudi',
    body:
        'Il a dit « Tu pars avec moi à Hong Kong jeudi » comme on dit '
        'passe-moi le sel.\n\n'
        'J\'ai dit oui comme on repose le sel.\n\n'
        'Note pour plus tard : retrouver où est mon passeport.',
  ),

  // ── Ep 3 — Hong Kong ──
  NoteEntry(
    day: 33,
    time: '23:20',
    title: 'Table de douze',
    body:
        'L\'oncle m\'a demandé si je parlais mandarin.\n'
        'J\'ai répondu en mandarin. Douze personnes ont arrêté de mâcher.\n\n'
        'Grand-mère, si tu as vu ça de là où tu es : c\'était pour toi.',
    starred: true,
  ),
  NoteEntry(
    day: 38,
    time: '01:12',
    title: 'Lan Kwai Fong',
    body:
        'Il était ivre. Il a dit mon prénom. Le vrai.\n'
        'Pas « Mlle Marchand ». Pas « vous ».\n\n'
        'Shen.\n\n'
        'Une syllabe. J\'ai mis deux heures à m\'endormir.',
  ),
  NoteEntry(
    day: 39,
    time: '08:02',
    title: 'Quatre heures du matin',
    body:
        'Maman sait. Tante Mei a parlé.\n'
        'Trois appels manqués pendant que je dormais dans des draps '
        'à 800 fils.\n\n'
        'Le luxe, c\'est dormir pendant que ta mère ne dort pas.',
    starred: true,
  ),

  // ── Ep 4 — Retour ──
  NoteEntry(
    day: 42,
    time: '23:55',
    title: 'La cuisine',
    body:
        'Quatre heures de silence dans 14 m².\n'
        'Puis elle m\'a écrit. De la table à l\'évier.\n\n'
        'On s\'est tout dit sans faire de bruit. C\'est peut-être ça, '
        'être mère et fille : la portée est plus grande que la voix.',
  ),
  NoteEntry(
    day: 45,
    time: '10:40',
    title: 'J45',
    body:
        'Le traitement commence. Le compte est passé de plein à juste.\n\n'
        'Le Dr Aubin a dit « grâce à ce que vous faites ».\n'
        'Si seulement il savait la ponctuation exacte de cette phrase.',
    starred: true,
  ),
  NoteEntry(
    day: 52,
    time: '21:08',
    title: 'Clause 21',
    body:
        '« Vous êtes libre. »\n\n'
        'J\'ai lu ça debout dans la cuisine de la rue de Berri, '
        'au milieu de cartons que je n\'avais pas encore faits.\n\n'
        'Libre. Le mot le plus lourd du contrat.',
  ),

  // ── Ep 5 — Fujian ──
  NoteEntry(
    day: 88,
    time: '21:30',
    title: 'Le parc',
    body:
        'Maman m\'a montré le banc. « C\'est ici qu\'il m\'a dit '
        'qu\'il partait. Il pensait revenir. »\n\n'
        'Vingt-sept ans qu\'elle porte cette phrase seule.\n'
        'Maintenant on la porte à deux. Elle pèse moitié moins et '
        'deux fois plus.',
    starred: true,
  ),
  NoteEntry(
    day: 105,
    time: '22:14',
    title: 'La question de Camille',
    body:
        '« Ta place est où ? »\n\n'
        'J\'ai regardé la cour, le kaki, Maman qui dort mieux ici '
        'qu\'à Belleville.\n\n'
        'Je n\'ai pas répondu. Sept jours pour trouver la réponse.',
    draft: true,
  ),
];
