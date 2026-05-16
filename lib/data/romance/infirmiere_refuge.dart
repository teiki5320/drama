import '../../models/romance.dart';

/// INFIRMIÈRE / SOIGNANTE REFUGE
/// Femme 26-32 ans, hôpital ou aide-soignante. Comprend immédiatement
/// la situation de Maman quand Shen confie. Devient un support indirect
/// précieux. Arc 12 jours.

const infirmiereProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'olivia_m',
    name: 'Olivia',
    age: 27,
    profession: 'Infirmière Tenon',
    quartier: '20e',
    detail: 'service oncologie',
    bio: 'Infirmière. Onco-hémato. Je sais ce que c\'est, "le compte à rebours".',
    gradient: [0xFF7A9A8C, 0xFF3A4A45],
    emoji: '🩺',
    photoEmojis: ['🩺', '🌿', '☕', '🚲'],
  ),
  RomanceProfile(
    id: 'farah_z',
    name: 'Farah',
    age: 30,
    profession: 'Sage-femme',
    quartier: '19e',
    detail: 'maternité Robert-Debré',
    bio: 'Sage-femme. Je vois beaucoup de débuts. Et quelques fins.',
    gradient: [0xFF8C6A8C, 0xFF40304A],
    emoji: '🤱',
    photoEmojis: ['🤱', '🌷', '☕', '🌳'],
  ),
  RomanceProfile(
    id: 'sandra_c',
    name: 'Sandra',
    age: 32,
    profession: 'Aide-soignante EHPAD',
    quartier: 'Pantin',
    detail: 'horaires décalés',
    bio: 'AS depuis 12 ans. Je vis avec les âges. Pas peur.',
    gradient: [0xFF6E7A8C, 0xFF34384A],
    emoji: '🕊️',
    photoEmojis: ['🕊️', '🪻', '☕', '🌳'],
  ),
];

const infirmiereBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Je viens de finir un service de 12h. Ton sourire m\'a réveillée.',
      'Salut. Tu as un visage doux. Ça me change.',
      'Hello. T\'es archi, j\'aime ça. Les gens qui construisent des trucs.',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Bonsoir. Tu fais quoi comme service ?',
        setBranch: 'shen_curieuse_i',
      ),
      RomanceChoice(
        label: 'Soft',
        reply: 'Bonsoir. Repose-toi.',
        moodDelta: 1,
        setBranch: 'shen_soft_i',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_i',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 22,
    type: RomanceBeatType.text,
    textVariants: [
      'Bien dormi. Pas longtemps. Café fait. Et toi ?',
      'Service de jour aujourd\'hui. 12h. Tu vas bien ?',
      'Tu as quoi ta journée ?',
    ],
  ),
  // ── J+2 — Conversation honnête, elle ne pose pas mais écoute
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 4,
    type: RomanceBeatType.text,
    textVariants: [
      'Question discrète : t\'as quelqu\'un à toi en ce moment ? '
          '(je veux pas savoir qui, juste savoir si t\'es seule)',
      'Tu as quoi qui te tient ?',
      'On voit des yeux comme les tiens à l\'hôpital. Pas souvent à Tinder.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Confier',
        reply: 'Ma mère est malade. Je gère seule. C\'est ça qui se voit ?',
        moodDelta: 2,
        setBranch: 'shen_confie_i',
      ),
      RomanceChoice(
        label: 'Évasive',
        reply: 'Famille. C\'est tout.',
        setBranch: 'shen_evasive_i',
      ),
      RomanceChoice(
        label: 'Question',
        reply: 'Tu poses des questions comme une soignante. Tu travailles encore ?',
        moodDelta: 1,
        setBranch: 'shen_question_i',
      ),
    ],
  ),
  // ── J+3 — Si confie, elle propose vraiment de l'aide
  RomanceBeat(
    dayOffset: 3,
    atHour: 8,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confie_i',
    textVariants: [
      'Je travaille en onco. Si tu as besoin d\'un avis sur un traitement ou '
          'un médecin, dis-moi. Sans engagement.',
      'Je peux pas régler ton problème. Mais je connais bien ces semaines-là. '
          'Tu peux m\'écrire si tu craques.',
      'Si tu veux qu\'on parle pratique : protocoles, soins palliatifs, aides, '
          'je peux. Si tu veux qu\'on parle pas, je suis là quand même.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 8,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_confie_i',
    choices: [
      RomanceChoice(
        label: 'Accepter aide',
        reply: 'Oui je veux bien. Merci.',
        moodDelta: 2,
        setBranch: 'shen_accepte_aide_i',
      ),
      RomanceChoice(
        label: 'Refuser doux',
        reply: 'Merci. Je vais essayer seule encore un peu.',
        moodDelta: 1,
        setBranch: 'shen_refuse_aide_i',
      ),
    ],
  ),
  // ── J+5 — RDV léger, partage info pratique
  RomanceBeat(
    dayOffset: 5,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_accepte_aide_i',
    textVariants: [
      'Café samedi 11h, près de Tenon ? Je peux t\'amener un truc administratif '
          'pour faciliter ses RDV.',
      'On se voit dimanche balade Buttes-Chaumont ? Sans pression.',
      'Je suis en garde demain mais lundi je suis dispo. Café Belleville ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 11,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'shen_accepte_aide_i',
    photoLabels: [
      'Café Méricourt · 22 rue de la Folie-Méricourt · 11h00',
      'Le Pavillon des Canaux · quai de la Loire · 10h30',
      'Buttes-Chaumont · kiosque · 11h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 14,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_accepte_aide_i',
    textVariants: [
      'Merci pour ce matin. La fiche est dans ton sac.',
      'J\'ai pas eu envie de te draguer. J\'ai eu envie de t\'écouter.',
      'Si t\'as besoin de parler à 3h du matin, t\'envoie un message. '
          'Si je suis en garde, je vois plus tard. Mais je lis toujours.',
    ],
  ),
  RomanceBeat(
    dayOffset: 12,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_accepte_aide_i',
    textVariants: [
      'Tu vas comment ? Sa séance d\'hier ?',
      'Toujours là. Pas de pression romance.',
    ],
    endsArc: 'i_refuge_pratique',
  ),
  RomanceBeat(
    dayOffset: 8,
    atHour: 21,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_refuse_aide_i',
    textVariants: [
      'OK. Bon courage.',
      'Je reste là. Pas pesante.',
    ],
    endsArc: 'i_attend_doucement',
  ),
];

const infirmiereTemplate = RomanceTemplate(
  id: 'infirmiere_refuge',
  archetypeLabel: 'Infirmière refuge',
  tone: RomanceTone.refuge,
  profilePool: infirmiereProfiles,
  beats: infirmiereBeats,
  minStartDay: 2,
  spawnWeight: 0.7,
  cooldownDays: 35,
  description: 'Femme soignante 26-32 ans. Comprend Maman immédiatement. '
      'Support pratique et indirect.',
);
