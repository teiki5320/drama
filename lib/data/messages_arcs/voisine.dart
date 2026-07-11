import '../../models/messages_arc.dart';

/// VOISINE DU 3e — Mme Dubreuil
/// Veuve, 71 ans, étage en dessous de Shen à Belleville. Arc qui démarre
/// par un colis perdu, glisse vers une plomberie cassée, et finit
/// (selon les choix) en demande de portage de courses ou silence gêné.
/// Arc 6-8 jours. Voix : polie, formelle, légèrement vieille école.

const voisineContact = MessagesArcContact(
  id: 'arc_voisine_dubreuil',
  displayName: 'Madame Dubreuil (3e)',
  emoji: '👵🏼',
  avatarTint: '#E0D9C5',
  subtitle: 'Voisine',
  gradient: [0xFFB8A88E, 0xFF6E5F4A],
);

const voisineBeats = <MessagesArcBeat>[
  // J+0 — Premier SMS : colis livré au mauvais étage
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Bonsoir Madame Marchand, c\'est Madame Dubreuil du 3e. '
          'Le livreur a déposé chez moi un colis à votre nom. '
          'Je le garde au chaud. Bonne soirée.',
      'Bonjour, c\'est votre voisine du dessous. La gardienne m\'a dit '
          'que vous aviez emménagé. J\'ai un colis pour vous arrivé hier.',
      'Bonsoir, c\'est Madame Dubreuil. Le facteur m\'a remis un courrier '
          'recommandé à votre nom par erreur. Quand pourrez-vous passer ?',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Polie',
        reply: 'Bonsoir Madame Dubreuil. Merci beaucoup. Je passe demain '
            'matin si ça vous va.',
        moodDelta: 1,
        setBranch: 'shen_polie_v',
      ),
      MessagesArcChoice(
        label: 'Pressée',
        reply: 'Bonjour. Je passe ce soir, c\'est possible ?',
        setBranch: 'shen_pressee_v',
      ),
      MessagesArcChoice(
        label: 'Sèche',
        reply: 'Bonsoir. Je viens demain. Merci.',
        moodDelta: -1,
        setBranch: 'shen_seche_v',
      ),
    ],
  ),
  // ── J+1 : passage colis + petit échange
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    textVariants: [
      'J\'ai sonné à votre porte tout à l\'heure mais vous étiez sortie. '
          'Je laisse le colis devant si ça vous arrange.',
      'Vous avez deux paquets en fait. L\'un est lourd. Je le porte à votre '
          'porte ?',
      'Mon fils passe vers 18h, il peut monter le colis chez vous. Dites-moi.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 36,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Merci doux',
        reply: 'C\'est gentil. Je viens dans 1h. Ne vous embêtez pas.',
        moodDelta: 1,
        setBranch: 'shen_doux_v',
      ),
      MessagesArcChoice(
        label: 'Accept fils',
        reply: 'Si votre fils peut le monter, ça m\'aiderait. Merci beaucoup.',
        moodDelta: 1,
        setBranch: 'shen_fils_v',
      ),
      MessagesArcChoice(
        label: 'Évasive',
        reply: 'Je passerai. Merci.',
        setBranch: 'shen_evasive_v',
      ),
    ],
  ),
  // ── J+2 : voisine raconte un truc sur Belleville
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 18,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    forbidBranch: 'shen_seche_v',
    textVariants: [
      'Petit mot pour vous remercier de votre gentillesse. C\'est rare. '
          'Vous me rappelez ma fille qui vit à Lyon.',
      'J\'ai vu votre maman dans l\'entrée hier matin. Elle m\'a souri. '
          'C\'est une belle femme.',
      'Le pâtissier du coin a refait son éclair café. Si vous passez '
          'demain matin, faites-vous le plaisir.',
    ],
  ),
  // ── J+3 — Le vrai sujet apparaît : plomberie
  // Le joueur qui a été « Sèche » (shen_seche_v) reste sur l'affaire du colis
  // et n'entre pas dans l'intrigue plomberie/fuite.
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 7,
    atMinute: 48,
    type: MessagesArcBeatType.text,
    forbidBranch: 'shen_seche_v',
    textVariants: [
      'Bonjour Madame Marchand. Je vous dérange pour une chose embêtante : '
          'il y a une fuite chez vous qui inonde mon plafond. '
          'J\'ai vu apparaître une tache cette nuit.',
      'Madame Marchand, désolée. Je crois qu\'il y a une fuite au-dessus '
          'de chez moi. Pouvez-vous regarder votre salle de bain ?',
      'Pardon de vous embêter au réveil. Je crois que ça coule chez vous '
          'et ça arrive chez moi.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 7,
    atMinute: 52,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_seche_v',
    choices: [
      MessagesArcChoice(
        label: 'Vérifier',
        reply: 'Je regarde tout de suite. Pardon. Je vous rappelle.',
        moodDelta: 1,
        setBranch: 'shen_verifie_v',
      ),
      MessagesArcChoice(
        label: 'Plus chez Belleville',
        reply: 'Madame Dubreuil, je ne vis plus chez Belleville depuis '
            '15 jours. Ma mère y est. Elle ne se rend pas compte sûrement.',
        moodDelta: 1,
        setBranch: 'shen_revele_v',
      ),
      MessagesArcChoice(
        label: 'Esquiver',
        reply: 'Je vais voir ça. Merci.',
        moodDelta: -1,
        setBranch: 'shen_esquive_plombe',
      ),
    ],
  ),
  // ── J+3 : Si revele
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 11,
    atMinute: 4,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_revele_v',
    textVariants: [
      'Ah. Je comprends mieux. Je ne savais pas que vous étiez partie.\n'
          'Votre maman est seule chez elle ? Je peux monter voir.',
      'Oh. Je vois. Excusez ma confusion. Voulez-vous que j\'aide votre '
          'maman à appeler un plombier ?',
      'Je suis désolée. Si elle a besoin de quelqu\'un de proche, je suis là.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 11,
    atMinute: 8,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_revele_v',
    choices: [
      MessagesArcChoice(
        label: 'Demander',
        reply: 'Si vous pouviez monter voir, ça me rassure. Merci.',
        moodDelta: 2,
        setBranch: 'shen_demande_v',
      ),
      MessagesArcChoice(
        label: 'Refuser doux',
        reply: 'C\'est gentil. Je passe ce soir, je gère.',
        moodDelta: 0,
        setBranch: 'shen_refuse_aide_v',
      ),
    ],
  ),
  // ── J+3 photo : Madame Dubreuil envoie photo du plafond taché
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 14,
    atMinute: 32,
    type: MessagesArcBeatType.photoShared,
    requireBranch: 'shen_verifie_v',
    photoLabels: [
      'plafond du salon avec une grosse tache marron qui descend en goutte',
      'le coin de sa salle à manger, peinture qui cloque sur 20 cm',
      'sa chambre, mur entre 2 cadres anciens, auréole jaune fonce',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 14,
    atMinute: 34,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_verifie_v',
    textVariants: [
      'Voilà ce que ça donne chez moi. Pas grave si vous trouvez la source. '
          'Je suis assurée.',
      'Ce n\'est pas une accusation, hein. Je voulais juste vous alerter.',
      'Pas d\'urgence, mais si vous pouviez prévenir un plombier, ce serait '
          'gentil.',
    ],
  ),
  // ── J+4 : Suite après vérification ou demande
  MessagesArcBeat(
    dayOffset: 4,
    atHour: 19,
    atMinute: 4,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_demande_v',
    textVariants: [
      'Bon. Je suis montée chez votre maman. Elle est charmante. La fuite '
          'vient de la salle de bain. Elle a appelé son plombier habituel, '
          'il vient demain.\nElle a accepté que je reste boire un thé.',
      'Votre maman m\'a fait du thé Long Jing. Elle m\'a dit que vous '
          'travaillez beaucoup. Je n\'ai rien dit de la fuite, on s\'en est '
          'occupé entre nous.',
      'Tout est sous contrôle. Votre maman est une femme bien. '
          'Elle s\'inquiète, mais ne dit rien.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 4,
    atHour: 21,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_verifie_v',
    textVariants: [
      'Vous avez trouvé ? Je n\'ai pas de nouvelles depuis ce matin.',
      'Tout va bien chez vous ?',
      'Ma fuite continue. Si vous pouviez juste me dire ce que vous avez vu.',
    ],
  ),
  // ── J+5-6 : Conclusion selon branche
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 11,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_demande_v',
    textVariants: [
      'Plombier passé. C\'est réglé. Votre maman m\'a redonné un sachet de '
          'thé pour vous. Passez quand vous pouvez.',
      'Tout est réparé. J\'ai laissé un mot à votre maman avec mon numéro. '
          'Au cas où.',
      'Tout va bien. J\'ai une question : pourquoi votre maman ne sait pas '
          'que vous avez déménagé ?',
    ],
    endsArc: 'voisine_alliée',
  ),
  MessagesArcBeat(
    dayOffset: 6,
    atHour: 22,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_esquive_plombe',
    textVariants: [
      'La fuite s\'est arrêtée. Tant mieux. Je ne vous embête plus.',
      'J\'ai appelé moi-même un plombier qui est passé chez vous. '
          'Votre maman a payé. Vous me remercierez à l\'occasion.',
      'Bon. Je comprends que vous ne pouviez pas. Je n\'ai rien dit à '
          'votre maman.',
    ],
    endsArc: 'voisine_dignite_blessee',
  ),
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 9,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_seche_v',
    textVariants: [
      'Je vous ai laissé le colis devant votre porte hier. Bonne réception.',
    ],
    endsArc: 'voisine_distance',
  ),
];

const voisineTemplate = MessagesArcTemplate(
  id: 'voisine_dubreuil',
  label: 'Voisine Dubreuil',
  category: MessagesArcCategory.voisinage,
  contact: voisineContact,
  beats: voisineBeats,
  minStartDay: 9,  // après emménagement rue de Berri
  spawnWeight: 1.0,
  cooldownDays: 90,
  description: 'Voisine 71 ans à Belleville. Colis perdu puis fuite '
      'plomberie chez Maman. 3 fins.',
);
