import '../../models/romance.dart';

/// POLY NON-DIT AMBIGU
/// 24-30 ans, charmant, drôle. Cache pendant 3-4 jours qu'il est en
/// couple ouverte. Reveal J+5 → Shen bloque ou pas. Arc 5-8 jours.

const polyProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'hugo_r',
    name: 'Hugo',
    age: 24,
    profession: 'Prof remplaçant lettres',
    quartier: '20e',
    detail: 'lecteur d\'Ernaux',
    bio: 'Lecteur. Drôle. Pose des questions.',
    gradient: [0xFF7A4A5C, 0xFF381F2A],
    emoji: '📖',
    photoEmojis: ['📖', '☕', '🚲', '🌳'],
  ),
  RomanceProfile(
    id: 'tanguy_v',
    name: 'Tanguy',
    age: 28,
    profession: 'Designer graphique',
    quartier: '11e',
    detail: 'tatoué sobre',
    bio: 'Designer. Vélo. Cuisine vegan.',
    gradient: [0xFF584F60, 0xFF26212E],
    emoji: '🎨',
    photoEmojis: ['🎨', '🌱', '🚲', '🎵'],
  ),
  RomanceProfile(
    id: 'sacha_p',
    name: 'Sacha',
    age: 30,
    profession: 'Psychologue clinicien',
    quartier: '10e',
    detail: 'parle des affects',
    bio: 'Psy. Pas le mien. Le tien si tu veux.',
    gradient: [0xFF4A5C5A, 0xFF1F2A28],
    emoji: '💭',
    photoEmojis: ['💭', '📚', '☕', '🌿'],
  ),
];

const polyBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Belle photo. Tu lis quoi ?',
      'Salut. Ta bio me fait sourire. Tu écris ?',
      'Hello. Tu fais quoi quand tu veux pas rentrer chez toi ?',
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
        reply: 'Salut. Et toi ?',
        setBranch: 'shen_curieuse_po',
      ),
      RomanceChoice(
        label: 'Joueuse',
        reply: 'Je marche sous la pluie. Toi ?',
        moodDelta: 1,
        setBranch: 'shen_joueuse_po',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_po',
      ),
    ],
  ),
  // ── J+1-3 — Conversation excellente
  RomanceBeat(
    dayOffset: 1,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Annie Ernaux, « L\'événement ». Tu connais ? Je viens de le finir.',
      'Tu écoutes quoi quand tu marches seule la nuit ?',
      'Question idiote : tu préfères les gens qui parlent ou ceux qui écoutent ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.voiceNote,
    voiceDurationS: 28,
    textVariants: [
      'vocal 28 s — voix douce, légère ironie — il dit que sa journée a '
          'été ridicule et qu\'il a pensé à elle en faisant les courses',
    ],
  ),
  // ── J+4 — Propose un verre
  RomanceBeat(
    dayOffset: 4,
    atHour: 15,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Verre vendredi 19h, Combat dans le 19e ?',
      'Café samedi 11h, Ten Belles ?',
      'On se voit ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 15,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'OK. Je serai là.',
        moodDelta: 2,
        setBranch: 'rdv_po',
      ),
      RomanceChoice(
        label: 'Pas envie',
        reply: 'Pas maintenant. Bonne suite.',
        endsArc: 'shen_decline_po',
      ),
    ],
  ),
  // ── J+5 — Avant le RDV, il reveal
  RomanceBeat(
    dayOffset: 5,
    atHour: 14,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_po',
    textVariants: [
      'Petit truc à préciser avant ce soir. Je suis en couple ouverte avec '
          'Léa depuis 4 ans. C\'est cool ?',
      'Avant qu\'on se voie : ma copine et moi on est ouverts. Tu savais '
          'pas, je le dis maintenant.',
      'Important : je suis pas mono. Ma partenaire est au courant. Toi tu '
          'décides si tu viens.',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 14,
    atMinute: 26,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_po',
    choices: [
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_po',
      ),
      RomanceChoice(
        label: 'Confronter',
        reply: 'Tu pouvais pas le dire il y a 4 jours ?',
        moodDelta: 1,
        setBranch: 'shen_confronte_po',
      ),
      RomanceChoice(
        label: 'OK essayer',
        reply: 'C\'est nouveau pour moi. On peut en parler ce soir ?',
        moodDelta: 0,
        setBranch: 'shen_ouvre_po',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 14,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confronte_po',
    textVariants: [
      'Tu as raison. J\'ai pas voulu te perdre avant.\nC\'était lâche. Pardon.',
      'Je sais. C\'était calculé. J\'ai pas su être direct.\nBonne suite si tu veux.',
    ],
    endsArc: 'lui_lache_admis',
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 19,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ouvre_po',
    textVariants: [
      'OK on en parle ce soir. Sans drama.',
      'Merci. Vraiment.',
    ],
    endsArc: 'po_a_voir',
  ),
];

const polyTemplate = RomanceTemplate(
  id: 'poly_ambigu',
  archetypeLabel: 'Poly non-dit',
  tone: RomanceTone.ambiguous,
  profilePool: polyProfiles,
  beats: polyBeats,
  minStartDay: 1,
  spawnWeight: 0.7,
  cooldownDays: 30,
  description: 'Cache la couple ouverte 4 j, reveal J+5 avant RDV. '
      'Block, confronter ou tenter.',
);
