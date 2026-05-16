import '../../models/romance.dart';

/// CLASS DIVIDE
/// Métier manuel/ouvrier, 30-38 ans. Honnête, direct, généreux.
/// Shen sent une gêne malgré elle (Avenue Foch, contrat Heng). Le malaise
/// vient des deux côtés. Arc 6 jours, drame social en sourdine.

const classDivideProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'yoann_f',
    name: 'Yoann',
    age: 33,
    profession: 'Plombier-chauffagiste',
    quartier: 'Aubervilliers',
    detail: 'patron de sa boîte',
    bio: 'Plombier 13 ans. Mon père aussi. Je gagne plus que mon avocat.',
    gradient: [0xFF6E5F4A, 0xFF332B22],
    emoji: '🔧',
    photoEmojis: ['🔧', '🚐', '🍻', '🌳'],
  ),
  RomanceProfile(
    id: 'mehdi_b',
    name: 'Mehdi',
    age: 31,
    profession: 'Chauffeur VTC',
    quartier: 'Saint-Denis',
    detail: 'sortie de prépa à 22',
    bio: 'Chauffeur. Pas de honte. J\'aime mon volant.',
    gradient: [0xFF555A60, 0xFF22262A],
    emoji: '🚗',
    photoEmojis: ['🚗', '☕', '🌃', '📖'],
  ),
  RomanceProfile(
    id: 'patrick_g',
    name: 'Patrick',
    age: 38,
    profession: 'Maçon en bâtiment',
    quartier: 'Pantin',
    detail: 'monte des maisons',
    bio: 'Maçon. Père et fils. Mes mains font des trucs solides.',
    gradient: [0xFF7B5D45, 0xFF3A2A1E],
    emoji: '🏗️',
    photoEmojis: ['🏗️', '🧱', '☕', '🌳'],
  ),
];

const classDivideBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. T\'es archi ? Cool. Je bosse avec des archis. Souvent ils me prennent de haut.',
      'Bonsoir. Joli sourire. Tu fais quoi dans la vie ?',
      'Hello. Belle photo. Tu vis où ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 16,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Salut. Et toi tu fais quoi ?',
        setBranch: 'shen_curieuse_c',
      ),
      RomanceChoice(
        label: 'Tendre',
        reply: 'Les archis sont parfois des cons. Je confirme.',
        moodDelta: 1,
        setBranch: 'shen_tendre_c',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_c',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 24,
    type: RomanceBeatType.text,
    textVariants: [
      'Plombier-chauffagiste. Patron de ma boîte. Pas de complexe.',
      'Chauffeur VTC. La nuit surtout. Je lis aux feux rouges.',
      'Maçon. Comme mon père. Je sais plus rien faire d\'autre.',
    ],
  ),
  // ── J+1 — Conversation directe
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Je te propose un verre Café des Anges, Bastille, jeudi 19h. Pas chichi.',
      'On boit un coup ce week-end ? Pas dans le 8e par contre.',
      'Tu veux qu\'on déjeune mercredi ? Mais je m\'habille pas.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 12,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Oui',
        reply: 'OK. Jeudi 19h.',
        moodDelta: 1,
        setBranch: 'rdv_c',
      ),
      RomanceChoice(
        label: 'Hésitante',
        reply: 'OK mais tu me poses pas trop de questions sur où je vis.',
        setBranch: 'shen_hesite_c',
      ),
      RomanceChoice(
        label: 'Décliner',
        reply: 'Je peux pas en ce moment. Bonne suite.',
        endsArc: 'shen_decline_c',
      ),
    ],
  ),
  // ── J+3 — Le RDV
  RomanceBeat(
    dayOffset: 3,
    atHour: 13,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    forbidBranch: 'shen_decline_c',
    photoLabels: [
      'Café des Anges · 66 rue de la Roquette · 19h00',
      'Le Bouquinerie · rue Vieille du Temple · 19h30',
      'L\'Imprévu · rue Quincampoix · 20h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_decline_c',
    textVariants: [
      'Merci. C\'était court mais j\'ai aimé t\'entendre rire.',
      'J\'ai senti que t\'étais à moitié. C\'est rien. Mais c\'est noté.',
      'Tu m\'as posé que des questions sur moi. Tu m\'as dit zéro sur toi.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_decline_c',
    choices: [
      RomanceChoice(
        label: 'Honnête',
        reply: 'Tu as raison. J\'ai pas voulu te dire où je vis.',
        moodDelta: 1,
        setBranch: 'shen_honnete_c',
      ),
      RomanceChoice(
        label: 'Esquiver',
        reply: 'J\'avais une longue journée pardon.',
        setBranch: 'shen_esquive_c',
      ),
      RomanceChoice(
        label: 'Confier',
        reply: 'Je vis avenue Foch. Je sais comment ça sonne. C\'est compliqué.',
        moodDelta: 2,
        setBranch: 'shen_confesse_c',
      ),
    ],
  ),
  // ── J+5 — Réaction selon confession
  RomanceBeat(
    dayOffset: 5,
    atHour: 11,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse_c',
    textVariants: [
      'Avenue Foch. OK. Tu choisis tes embrouilles.\nMerci d\'avoir dit. Bonne suite.',
      'OK. C\'est honnête de me le dire. Mais on n\'a pas la même vie.\nPrends soin de toi.',
      'Avenue Foch. Tu sais quoi : tu m\'as appris un truc. Sur moi. Pas sur toi.\nBye.',
    ],
    endsArc: 'lui_part_class',
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_esquive_c',
    textVariants: [
      'Pas grave. Bon week-end.',
      'OK. À une prochaine peut-être.',
    ],
  ),
  RomanceBeat(
    dayOffset: 8,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_esquive_c',
    textVariants: [
      'Je crois qu\'on n\'a pas le même monde. Pas grave. Bonne suite.',
    ],
    endsArc: 'lui_part_doux_class',
  ),
];

const classDivideTemplate = RomanceTemplate(
  id: 'class_divide',
  archetypeLabel: 'Class divide',
  tone: RomanceTone.classDivide,
  profilePool: classDivideProfiles,
  beats: classDivideBeats,
  minStartDay: 1,
  spawnWeight: 0.7,
  cooldownDays: 25,
  description: 'Métier manuel 30-38 ans. Honnête, direct. Malaise mutuel '
      'face au contrat Heng. Drame social en sourdine.',
);
