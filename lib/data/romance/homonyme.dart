import '../../models/romance.dart';

/// HOMONYME DANGEREUX
/// Un seul profil dont le prénom percute un proche de Shen (Tristan,
/// Camille). Pas voulu — coïncidence pure mais qui glace 8 secondes
/// avant qu'on lise l'âge / la photo. Arc court 3 jours.

const homonymeProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'tristan_v',
    name: 'Tristan',
    age: 32,
    profession: 'Designer industriel',
    quartier: '15e',
    detail: 'pas LE Tristan',
    bio: 'Tristan. 32. Designer. Pas marié à un contrat.',
    gradient: [0xFF505860, 0xFF22282E],
    emoji: '🔷',
    photoEmojis: ['🔷', '📐', '☕', '🌳'],
  ),
  RomanceProfile(
    id: 'camille_p',
    name: 'Camille',
    age: 31,
    profession: 'Avocat fiscaliste',
    quartier: '7e',
    detail: 'pas LE Camille',
    bio: 'Camille — masc. Pas Camille Roux. Pas non plus aussi drôle. Tant pis.',
    gradient: [0xFF606470, 0xFF2C2E36],
    emoji: '⚖️',
    photoEmojis: ['⚖️', '📰', '☕', '🥃'],
  ),
];

const homonymeBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Tu as eu un quart de seconde de panique en lisant mon prénom ?',
      'Salut. Je sais. Le prénom. Je l\'entends souvent.',
      'Bonjour. Si tu connais quelqu\'un avec le même prénom et que ça t\'a fait '
          'sursauter : pas moi.',
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
        label: 'Confier',
        reply: 'Effectivement. Tu m\'as fait peur 4 secondes.',
        moodDelta: 1,
        setBranch: 'shen_confie_ho',
      ),
      RomanceChoice(
        label: 'Nier',
        reply: 'Non, pas du tout.',
        moodDelta: -1,
        setBranch: 'shen_nie_ho',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: -1,
        endsArc: 'shen_block_ho',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 24,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confie_ho',
    textVariants: [
      'Bienvenue dans le club. J\'ai eu une copine qui a mis 3 mois à appeler son ex Antoine quand on couchait.',
      'Pas grave. Tu peux m\'appeler par mon nom de famille si tu préfères.',
      'Au moins on commence par une vérité.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 18,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confie_ho',
    textVariants: [
      'Tu fais quoi demain soir ? On peut se voir, je te promets que je ressemble '
          'pas à ton ex si c\'est ça.',
      'Tu veux qu\'on s\'écrive d\'abord beaucoup pour que mon prénom finisse '
          'par te dire moi et pas lui ?',
      'Verre demain 19h Le Pavillon des Canaux ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 18,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_confie_ho',
    choices: [
      RomanceChoice(
        label: 'Tenter',
        reply: 'OK. Pavillon des Canaux 19h.',
        moodDelta: 1,
        setBranch: 'rdv_ho',
      ),
      RomanceChoice(
        label: 'Trop chargé',
        reply: 'Je peux pas. Trop chargé.',
        endsArc: 'shen_decline_ho',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 0,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_ho',
    photoLabels: [
      'Pavillon des Canaux · 39 quai de la Loire · 19h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_ho',
    textVariants: [
      'C\'était bien. Et mon prénom a fait son boulot — tu n\'as pas sursauté une fois.',
      'Tu m\'as regardée comme si j\'étais moi. Merci.',
    ],
    endsArc: 'ho_normal',
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 23,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_nie_ho',
    textVariants: [
      'OK. Bonne soirée alors.',
    ],
    endsArc: 'ho_il_sent_le_truc',
  ),
];

const homonymeTemplate = RomanceTemplate(
  id: 'homonyme',
  archetypeLabel: 'Homonyme dangereux',
  tone: RomanceTone.intense,
  profilePool: homonymeProfiles,
  beats: homonymeBeats,
  minStartDay: 7,
  spawnWeight: 0.4,
  cooldownDays: 60,
  description: 'Profil dont le prénom percute un proche de Shen. '
      'Panique 8 s puis arc normal court.',
);
