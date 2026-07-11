import '../models/relationship.dart';

/// Choix de réponse SMS pour un beat narratif donné. Quand un contact
/// envoie un message qui débloque un choix, Shen voit 3 options en
/// bas de la conversation. Chaque choix :
/// - répond avec un texte (qui s'ajoute aux messages)
/// - applique des deltas sur la relation avec le contact
/// - peut déclencher d'autres événements (à venir en PR 8)

class SmsChoice {
  /// Identifiant du beat (correspond à un point du scénario).
  final String beatId;

  /// Contact concerné (vers qui Shen répond).
  final String contactId;

  /// Les 3 options visibles.
  final List<SmsChoiceOption> options;

  const SmsChoice({
    required this.beatId,
    required this.contactId,
    required this.options,
  });
}

class SmsChoiceOption {
  /// Texte qui sera ajouté comme message de Shen si l'option est choisie.
  final String reply;

  /// Court label affiché sur le bouton de choix (sinon = reply).
  final String? label;

  /// Effets sur la relation avec le contact.
  final RelationshipDelta delta;

  const SmsChoiceOption({
    required this.reply,
    this.label,
    this.delta = const RelationshipDelta(),
  });
}

/// Réponses « pivots » : celles qui décident de l'épilogue (voir
/// `resolveEpilogue` dans epilogues.dart). Déclarées en const pour que
/// le résolveur compare des chaînes canoniques, pas des copies.
const String kReplyJ52LeaveToCamille =
    'Je pars ce soir. Camille m\'ouvre son canapé. Merci d\'avoir tenu parole.';
const String kReplyJ95HongKong =
    'Non. Mais toi, viens. Retrouve-moi à Hong Kong le mois prochain. '
    'Terrain neutre, baie de Repulse.';
const String kReplyJ112Fujian =
    'Je reste. Le temps qu\'il faut, pas plus. Maman regarde le parc tous '
    'les soirs et je commence à voir ce qu\'elle voit.';
const String kReplyJ112Paris =
    'L\'avion de 17h. Ma vie est à Paris. Garde-moi un croissant, '
    'j\'atterris affamée.';
const String kReplyJ112HongKong =
    'Ni bus ni Paris. Hong Kong. J\'ai promis à quelqu\'un un terrain '
    'neutre, baie de Repulse.';

/// Catalogue de choix indexés par `beatId`. Plus de choix s'ajouteront
/// quand on étendra le scénario.
const Map<String, SmsChoice> kSmsChoices = {
  // J1 — Maman "Tu as mangé ?" — Shen ment ou pas ?
  'maman_petit_dej_j1': SmsChoice(
    beatId: 'maman_petit_dej_j1',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Vérité',
        reply: 'Pain au chocolat de la veille trempé dans du thé. Ça m\'a tenu.',
        delta: RelationshipDelta(trust: 4, suspicion: -2, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Mensonge tendre',
        reply: 'Un truc équilibré, t\'inquiète.',
        delta: RelationshipDelta(trust: -3, suspicion: 5),
      ),
      SmsChoiceOption(
        label: 'Esquive',
        reply: 'Maman, je suis sur le vélo, on parle ce soir.',
        delta: RelationshipDelta(dependency: -3, suspicion: 3),
      ),
    ],
  ),

  // J1 — Maman "Couvre-toi, il pleut" — registre tendresse
  'maman_couvre_toi_j1': SmsChoice(
    beatId: 'maman_couvre_toi_j1',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Réciproque',
        reply: 'Toi couvre-toi surtout.',
        delta: RelationshipDelta(attraction: 3, loyalty: 2, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Court',
        reply: 'Oui Maman.',
        delta: RelationshipDelta(attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Inquiète',
        reply: 'Tu as bien mangé quelque chose de chaud hier soir ?',
        delta: RelationshipDelta(dependency: 4, suspicion: 2, trust: 1),
      ),
    ],
  ),

  // J6 — Camille apporte le tailleur, prêche la posture
  'camille_tailleur_j6': SmsChoice(
    beatId: 'camille_tailleur_j6',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Acceptation',
        reply: 'Merci. J\'arrive avec le dossier sur dix ans, taux légal.',
        delta: RelationshipDelta(trust: 5, loyalty: 3),
      ),
      SmsChoiceOption(
        label: 'Doute',
        reply: 'Et si je n\'y allais pas ?',
        delta: RelationshipDelta(trust: -3, dependency: 4, suspicion: 2),
      ),
      SmsChoiceOption(
        label: 'Vanne',
        reply: '38, sérieux ? Je l\'épouse pas, je négocie un prêt.',
        delta: RelationshipDelta(attraction: 3, loyalty: 2),
      ),
    ],
  ),

  // J6 — Tristan : confirmation rdv Tour Heng
  'tristan_rdv_j6': SmsChoice(
    beatId: 'tristan_rdv_j6',
    contactId: 'tristan',
    options: [
      SmsChoiceOption(
        label: 'Confirmé',
        reply: 'Confirmé. À jeudi 11h.',
        delta: RelationshipDelta(trust: 3, attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Reprends le pouvoir',
        reply: 'Jeudi 11h, oui. Et merci de ne pas confondre rendez-vous et faveur.',
        delta: RelationshipDelta(attraction: 4, suspicion: 2, trust: -1),
      ),
      SmsChoiceOption(
        label: 'Annule',
        reply: 'Je passe mon tour.',
        delta: RelationshipDelta(trust: -8, attraction: -5, loyalty: -3),
      ),
    ],
  ),

  // J11 — Maman, premier mensonge sur le stage
  'maman_stage_j11': SmsChoice(
    beatId: 'maman_stage_j11',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Mensonge construit',
        reply: 'La courge du potager a doublé en deux jours. Lao Chen dit que c\'est l\'humidité.',
        delta: RelationshipDelta(trust: -4, suspicion: 8, attraction: -1),
      ),
      SmsChoiceOption(
        label: 'Demi-vérité',
        reply: 'Compliqué à raconter en SMS. Je passe dimanche.',
        delta: RelationshipDelta(trust: 2, suspicion: 4, dependency: 3),
      ),
      SmsChoiceOption(
        label: 'Reverse',
        reply: 'Et toi, comment tu te sens vraiment ?',
        delta: RelationshipDelta(trust: 5, attraction: 4, suspicion: -2),
      ),
    ],
  ),

  // J13 — Camille « QUEL THÉ »
  'camille_quel_the_j13': SmsChoice(
    beatId: 'camille_quel_the_j13',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Long Jing',
        reply: 'Long Jing première récolte. Si elle me sert autre chose, je le verrai.',
        delta: RelationshipDelta(trust: 4, attraction: 3, loyalty: 2),
      ),
      SmsChoiceOption(
        label: 'Pu\'er',
        reply: 'Pu\'er sans doute. Vieux, fermenté, intimidant. Comme elle.',
        delta: RelationshipDelta(attraction: 2, loyalty: 1),
      ),
      SmsChoiceOption(
        label: 'Je sais pas',
        reply: 'Je sais pas. J\'improviserai.',
        delta: RelationshipDelta(trust: -2, dependency: 2, suspicion: 1),
      ),
    ],
  ),

  // J4 — Camille "Tu as gardé sa carte, hein."
  'camille_carte_j4': SmsChoice(
    beatId: 'camille_carte_j4',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Avouer',
        reply: 'Oui. Je l\'ai recollée hier soir.',
        delta: RelationshipDelta(trust: 6, dependency: 4),
      ),
      SmsChoiceOption(
        label: 'Nier',
        reply: 'Non, je l\'ai déchirée pour de bon.',
        delta: RelationshipDelta(trust: -8, suspicion: 6, loyalty: -2),
      ),
      SmsChoiceOption(
        label: 'Détourner',
        reply: 'Camille. La vraie question c\'est : 18 000 euros.',
        delta: RelationshipDelta(trust: 1, dependency: -1),
      ),
    ],
  ),

  // J23 — Maman a trouvé la boîte de Long Jing dans le sac de Shen
  'maman_long_jing_j23': SmsChoice(
    beatId: 'maman_long_jing_j23',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Demi-vérité',
        reply:
            'Une cliente. Je fais des livraisons spéciales pour une '
            'grande maison. Elle offre du thé, pas des explications.',
        delta: RelationshipDelta(trust: -2, suspicion: 6),
      ),
      SmsChoiceOption(
        label: 'Dimanche',
        reply:
            'Dimanche. Je viens avec la boîte, on la goûte ensemble et '
            'je te raconte ce que je peux.',
        delta: RelationshipDelta(trust: 4, dependency: 3, suspicion: 2),
      ),
      SmsChoiceOption(
        label: 'Mensonge sec',
        reply: 'C\'est Camille. Un cadeau d\'un stage traiteur.',
        delta: RelationshipDelta(trust: -5, suspicion: 9, loyalty: -1),
      ),
    ],
  ),

  // J26 — Camille : huit jours sans nouvelles
  'camille_distance_j26': SmsChoice(
    beatId: 'camille_distance_j26',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Excuse vraie',
        reply:
            'T\'as raison. Je me noie un peu là-haut. Demain 19h, '
            'croissants sur moi ?',
        delta: RelationshipDelta(trust: 5, loyalty: 3),
      ),
      SmsChoiceOption(
        label: 'Vanne défensive',
        reply:
            'J\'étais occupée à devenir une femme du monde. Ça prend du '
            'temps, tu peux pas savoir.',
        delta: RelationshipDelta(attraction: 2, trust: -2, suspicion: 2),
      ),
      SmsChoiceOption(
        label: 'Minimiser',
        reply: 'Huit jours c\'est rien. Tu exagères toujours.',
        delta: RelationshipDelta(trust: -6, loyalty: -3, suspicion: 3),
      ),
    ],
  ),

  // J35 — Tante Mei : « es-tu sa fille ? »
  'mei_decouvre_j35': SmsChoice(
    beatId: 'mei_decouvre_j35',
    contactId: 'tante_mei',
    options: [
      SmsChoiceOption(
        label: 'C\'est moi',
        reply:
            'Je m\'appelle Shen. Mon père s\'appelait Shen Wenbo. Je ne '
            'l\'ai jamais connu. Vous ne vous trompez pas.',
        delta: RelationshipDelta(trust: 6, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Prudence',
        reply:
            'Qui vous a donné ce numéro ? Je ne réponds pas aux '
            'inconnus qui parlent de mon père.',
        delta: RelationshipDelta(suspicion: 5, trust: 1),
      ),
      SmsChoiceOption(
        label: 'Refus poli',
        reply: 'Vous faites erreur. Bonne journée.',
        delta: RelationshipDelta(trust: -6, loyalty: -2),
      ),
    ],
  ),

  // J39 — Maman sait pour Hong Kong (« tu m'avais dit Lyon »)
  'maman_decouvre_j39': SmsChoice(
    beatId: 'maman_decouvre_j39',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Tout avouer',
        reply:
            'Je suis à Hong Kong. Je rentre vendredi et je te raconte '
            'tout : le contrat, l\'argent, le traitement. Tout.',
        delta: RelationshipDelta(trust: 8, suspicion: -5, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Rassurer sans dire',
        reply:
            'Je suis à Hong Kong pour le travail. Je vais bien. Je '
            't\'expliquerai, mais pas par SMS.',
        delta: RelationshipDelta(trust: -2, suspicion: 6),
      ),
      SmsChoiceOption(
        label: 'Éluder',
        reply:
            'Maman, il est 4h chez toi. Prends tes gélules, dors. On '
            's\'appelle à mon retour.',
        delta: RelationshipDelta(trust: -6, suspicion: 8, attraction: -2),
      ),
    ],
  ),

  // J42 — la question posée dans le silence de la cuisine
  'maman_confrontation_j42': SmsChoice(
    beatId: 'maman_confrontation_j42',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Oui. Son argent.',
        reply:
            'Oui. C\'est son argent. C\'était le seul moyen d\'arriver à '
            'J45 devant le Dr Aubin avec le compte plein. Je le referais.',
        delta: RelationshipDelta(trust: 7, suspicion: -8, dependency: 1),
      ),
      SmsChoiceOption(
        label: 'Mon argent.',
        reply:
            'C\'est mon argent. Je l\'ai gagné. Un contrat, un travail, '
            'des règles. Personne ne m\'a rien donné.',
        delta: RelationshipDelta(trust: -3, suspicion: 4, attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Pardon',
        reply:
            'Pardon. Pas pour l\'avoir fait. Pour t\'avoir laissée '
            'l\'apprendre par quelqu\'un d\'autre.',
        delta: RelationshipDelta(trust: 5, suspicion: -3, loyalty: 2),
      ),
    ],
  ),

  // J52 — Tristan annonce la fin du contrat (pivot d'épilogue)
  'tristan_fin_contrat_j52': SmsChoice(
    beatId: 'tristan_fin_contrat_j52',
    contactId: 'tristan',
    options: [
      SmsChoiceOption(
        label: 'Rester, sans contrat',
        reply:
            'Déchirez la clause 21. Je reste. Pas pour un contrat, '
            'cette fois.',
        delta: RelationshipDelta(attraction: 8, trust: 5, suspicion: -5),
      ),
      SmsChoiceOption(
        label: 'Partir chez Camille',
        reply: kReplyJ52LeaveToCamille,
        delta: RelationshipDelta(trust: 2, attraction: -6, dependency: -5),
      ),
      SmsChoiceOption(
        label: 'Du temps',
        reply:
            'Je ne sais pas encore. Laissez-moi quelques semaines. '
            'Je vous écrirai.',
        delta: RelationshipDelta(trust: 1, attraction: 1),
      ),
    ],
  ),

  // J78 — Tante Mei : « venez avant l'hiver »
  'mei_invitation_j78': SmsChoice(
    beatId: 'mei_invitation_j78',
    contactId: 'tante_mei',
    options: [
      SmsChoiceOption(
        label: 'On vient',
        reply:
            'On vient. Je m\'occupe des billets cette semaine. Maman '
            'remontera dans un avion pour vous.',
        delta: RelationshipDelta(trust: 7, dependency: 3),
      ),
      SmsChoiceOption(
        label: 'Moi d\'abord',
        reply:
            'Je viens d\'abord seule. Si c\'est ce que je crois, je veux '
            'le lire avant elle.',
        delta: RelationshipDelta(trust: 3, suspicion: 2, loyalty: 1),
      ),
      SmsChoiceOption(
        label: 'Pas encore',
        reply:
            'Pas encore. Maman sort à peine du traitement. Donnez-nous '
            'du temps.',
        delta: RelationshipDelta(trust: -2, dependency: -2),
      ),
    ],
  ),

  // J95 — Tristan : « Tu reviens ? » (pivot d'épilogue)
  'tristan_revient_j95': SmsChoice(
    beatId: 'tristan_revient_j95',
    contactId: 'tristan',
    options: [
      SmsChoiceOption(
        label: 'Je rentre',
        reply: 'Je rentre. Pas pour la clause 21. Pour toi. Le 17, vol de 17h.',
        delta: RelationshipDelta(attraction: 8, trust: 4),
      ),
      SmsChoiceOption(
        label: 'Rejoins-moi',
        reply: kReplyJ95HongKong,
        delta: RelationshipDelta(attraction: 5, suspicion: -2),
      ),
      SmsChoiceOption(
        label: 'Je ne sais pas',
        reply:
            'Je ne sais pas encore. Ici j\'apprends des choses sur mon '
            'père que tu n\'imagines pas. Laisse-moi finir.',
        delta: RelationshipDelta(trust: 2, dependency: -2),
      ),
    ],
  ),

  // J112 — Camille : « Tu emportes quoi ? » (décide l'épilogue)
  'epilogue_j112': SmsChoice(
    beatId: 'epilogue_j112',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Je reste',
        reply: kReplyJ112Fujian,
        delta: RelationshipDelta(trust: 4, loyalty: 3),
      ),
      SmsChoiceOption(
        label: 'Paris',
        reply: kReplyJ112Paris,
        delta: RelationshipDelta(trust: 3, attraction: 2),
      ),
      SmsChoiceOption(
        label: 'Hong Kong',
        reply: kReplyJ112HongKong,
        delta: RelationshipDelta(attraction: 2, suspicion: 2),
      ),
    ],
  ),

  // J19 — Madame Heng : « L'Amant, ou Hiroshima ? »
  'heng_duras_j19': SmsChoice(
    beatId: 'heng_duras_j19',
    contactId: 'madame_heng',
    options: [
      SmsChoiceOption(
        label: 'L\'Amant',
        reply: 'L\'Amant. Quatre relectures cette année.',
        delta: RelationshipDelta(trust: 6, attraction: 2, suspicion: -3),
      ),
      SmsChoiceOption(
        label: 'Hiroshima',
        reply:
            'Hiroshima. La mémoire m\'intéresse plus que la passion, '
            'Madame.',
        delta: RelationshipDelta(trust: 4, attraction: 3),
      ),
      SmsChoiceOption(
        label: 'Esquiver',
        reply: 'Je lis peu, Madame. Le vélo prend les soirées.',
        delta: RelationshipDelta(trust: -4, suspicion: 5),
      ),
    ],
  ),

  // J24 — Maman devine (« dis-moi si je me trompe »)
  'maman_devine_j24': SmsChoice(
    beatId: 'maman_devine_j24',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Nier',
        reply: 'Tu te fais des films. C\'est la fatigue du stage.',
        delta: RelationshipDelta(trust: -4, suspicion: 6),
      ),
      SmsChoiceOption(
        label: 'Demi-aveu',
        reply:
            'Tu ne te trompes jamais. C\'est bien ça le problème. '
            'Laisse-moi le temps de comprendre.',
        delta: RelationshipDelta(trust: 6, dependency: 3, suspicion: -2),
      ),
      SmsChoiceOption(
        label: 'Retourner',
        reply: 'Et toi, tu avais quel visage à mon âge ?',
        delta: RelationshipDelta(trust: 3, attraction: 3),
      ),
    ],
  ),

  // J29 — Camille : le passeport
  'camille_passeport_j29': SmsChoice(
    beatId: 'camille_passeport_j29',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'La boîte',
        reply:
            'Trouvé. Boîte à chaussures, sous le lit, avec les photos '
            'de la fac. Périmé dans deux ans, ça va.',
        delta: RelationshipDelta(trust: 3, loyalty: 2),
      ),
      SmsChoiceOption(
        label: 'Panique',
        reply: 'JE SAIS PAS OÙ IL EST. Camille. JEUDI.',
        delta: RelationshipDelta(dependency: 5, trust: 2),
      ),
      SmsChoiceOption(
        label: 'Vexée',
        reply: 'J\'ai 24 ans, je sais où est mon passeport.',
        delta: RelationshipDelta(trust: -2, suspicion: 2),
      ),
    ],
  ),

  // J38 — Camille : la photo de la robe
  'camille_robe_j38': SmsChoice(
    beatId: 'camille_robe_j38',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'La photo',
        reply:
            'Tiens. Bleu nuit, dos nu. Tristan est entré, il a rien dit '
            'pendant trois secondes. Trois LONGUES secondes.',
        delta: RelationshipDelta(trust: 6, attraction: 2, loyalty: 2),
      ),
      SmsChoiceOption(
        label: 'Décrire',
        reply:
            'Pas de photo, le wifi de l\'hôtel me connaît. Bleu nuit, '
            'dos nu, et je me trouve belle. Voilà.',
        delta: RelationshipDelta(trust: 4, attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Refuser',
        reply: 'Non. Tu la verras au retour. Le suspense te va bien.',
        delta: RelationshipDelta(attraction: 2, suspicion: 2, trust: -1),
      ),
    ],
  ),

  // J39 — Vincent : « tu es la quatrième »
  'vincent_quatrieme_j39': SmsChoice(
    beatId: 'vincent_quatrieme_j39',
    contactId: 'vincent_heng',
    options: [
      SmsChoiceOption(
        label: 'Tu mens',
        reply:
            'Tu mens, Vincent. Pas complètement, c\'est ta technique. '
            'Combien, vraiment ?',
        delta: RelationshipDelta(trust: 2, suspicion: 4, attraction: -2),
      ),
      SmsChoiceOption(
        label: 'Encaisser',
        reply: 'Merci pour l\'information. Bonne nuit.',
        delta: RelationshipDelta(suspicion: 6, dependency: -2),
      ),
      SmsChoiceOption(
        label: 'Demander à Tristan',
        reply:
            'Je vais lui poser la question. Devant toi si tu veux. '
            'Tu confirmeras ?',
        delta: RelationshipDelta(trust: -3, suspicion: 3, loyalty: -2),
      ),
    ],
  ),

  // J46 — Madame Heng : une question. Une seule.
  'heng_phrase_j46': SmsChoice(
    beatId: 'heng_phrase_j46',
    contactId: 'madame_heng',
    options: [
      SmsChoiceOption(
        label: 'Qui ?',
        reply: 'De qui je tiens cette bouche, Madame ?',
        delta: RelationshipDelta(trust: 4, suspicion: -2, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Mon père',
        reply:
            'Vous connaissiez mon père. Dites-le. Shen Wenbo. '
            'Notaire instructeur : Heng Lihua.',
        delta: RelationshipDelta(trust: 2, attraction: 3, suspicion: 3),
      ),
      SmsChoiceOption(
        label: 'Pas prête',
        reply:
            'Je garde ma question, Madame. Je ne suis pas prête '
            'pour la réponse.',
        delta: RelationshipDelta(trust: 3, dependency: -2),
      ),
    ],
  ),

  // J53 — Camille : le dossier de Shanghai (« tu fais quoi ? »)
  'camille_dossier_j53': SmsChoice(
    beatId: 'camille_dossier_j53',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Je l\'ouvre',
        reply:
            'Je monte. Je l\'ouvre. C\'est le nom de ma mère, c\'est '
            'mon histoire aussi.',
        delta: RelationshipDelta(trust: 4, suspicion: 3, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Je l\'emporte',
        reply:
            'Je le prends sans l\'ouvrir. Je veux le lire chez moi, '
            'pas dans son bureau.',
        delta: RelationshipDelta(trust: 2, suspicion: 4),
      ),
      SmsChoiceOption(
        label: 'J\'attends',
        reply:
            'Je redescends. S\'il me cache ce dossier, je veux voir '
            'combien de temps il ose.',
        delta: RelationshipDelta(trust: -2, suspicion: 6, attraction: -1),
      ),
    ],
  ),

  // J69 — Maman : « on la lira ensemble ? »
  'maman_lettre_j69': SmsChoice(
    beatId: 'maman_lettre_j69',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Oui, dimanche',
        reply: 'Oui. Dimanche. Je fais le thé, tu lis.',
        delta: RelationshipDelta(trust: 7, dependency: 3, suspicion: -4),
      ),
      SmsChoiceOption(
        label: 'Pas encore',
        reply:
            'Pas encore. Je n\'arrive pas encore à l\'entendre à voix '
            'haute. Bientôt. Promis.',
        delta: RelationshipDelta(trust: 2, dependency: -2),
      ),
      SmsChoiceOption(
        label: 'En silence',
        reply:
            'On la lira chacune en silence, côte à côte. Les voix '
            'hautes, c\'est pour lui au parc.',
        delta: RelationshipDelta(trust: 5, attraction: 2),
      ),
    ],
  ),

  // J91 — Tante Mei : lire la lettre seule ou avec Maman
  'mei_lettre_j91': SmsChoice(
    beatId: 'mei_lettre_j91',
    contactId: 'tante_mei',
    options: [
      SmsChoiceOption(
        label: 'Seule',
        reply:
            'Seule, d\'abord. C\'est à moi qu\'elle est adressée. '
            'Ensuite je la donnerai à Maman.',
        delta: RelationshipDelta(trust: 4, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Avec Maman',
        reply:
            'Avec elle. Il lui a écrit 311 lettres avant celle-là. '
            'Cette dernière est aussi la sienne.',
        delta: RelationshipDelta(trust: 6, loyalty: 3),
      ),
      SmsChoiceOption(
        label: 'Pas ce soir',
        reply:
            'Pas ce soir. Neuf ans qu\'elle attend, elle peut attendre '
            'que je dorme une nuit entière.',
        delta: RelationshipDelta(trust: 1, suspicion: 2),
      ),
    ],
  ),

  // J102 — Maman : « tu lui as dit quoi ? »
  'maman_312e_j102': SmsChoice(
    beatId: 'maman_312e_j102',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'La phrase',
        reply:
            'Que je n\'ai plus besoin de lui écrire pour lui parler. '
            'C\'est tout. C\'était assez.',
        delta: RelationshipDelta(trust: 7, attraction: 3, suspicion: -3),
      ),
      SmsChoiceOption(
        label: 'Entre lui et moi',
        reply:
            'C\'est entre lui et moi, Maman. Tu as eu tes 311 lettres. '
            'Celle-là était la mienne.',
        delta: RelationshipDelta(trust: 2, dependency: -3, attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Au parc',
        reply: 'Je te le dirai au parc. À voix haute. Devant lui.',
        delta: RelationshipDelta(trust: 5, dependency: 2, loyalty: 2),
      ),
    ],
  ),
};

/// Renvoie le choix associé à un beat, ou null si pas de choix défini.
SmsChoice? choiceForBeat(String beatId) => kSmsChoices[beatId];
