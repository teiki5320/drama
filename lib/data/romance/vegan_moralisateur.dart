import '../../models/romance.dart';

/// VEGAN MORALISATEUR
/// Homme 28-32 ans, vegan militant. Juge chaque choix de Shen (UberEats
/// non-vegan, cuir, Heng International = capitalisme). Arc 4 jours,
/// comédie de l'éthique sermon.

const veganProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'vincent_g',
    name: 'Vincent',
    age: 28,
    profession: 'Activiste L214',
    quartier: '19e',
    detail: 'tatouages éthiques',
    bio: 'Vegan depuis 9 ans. Antispéciste. Cherche partenaire de luttes.',
    gradient: [0xFF4A6850, 0xFF1E2E22],
    emoji: '🌱',
    photoEmojis: ['🌱', '✊', '🥗', '🚴'],
  ),
  RomanceProfile(
    id: 'leo_m',
    name: 'Léo',
    age: 30,
    profession: 'Chef vegan',
    quartier: '10e',
    detail: 'restaurant 100% plant',
    bio: 'Chef. Plant-based depuis 10 ans. Cuisine consciente.',
    gradient: [0xFF5C7050, 0xFF283022],
    emoji: '🥬',
    photoEmojis: ['🥬', '🍅', '🌶️', '🌻'],
  ),
  RomanceProfile(
    id: 'tristan_d',
    name: 'Tristan',
    age: 27,
    profession: 'Doctorant éthique animale',
    quartier: '6e',
    detail: 'thèse à finir',
    bio: 'Doctorant. J\'écris ma thèse sur la sentience. Je vis ce que j\'écris.',
    gradient: [0xFF4A5A50, 0xFF22282A],
    emoji: '📗',
    photoEmojis: ['📗', '🌳', '🥗', '☕'],
  ),
];

const veganBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Petit point avant : t\'es plutôt omni ou vegan ?',
      'Salut. Joli sourire mais ton bio dit rien sur l\'alimentation. Tu manges quoi ?',
      'Hello. Tu sais que le lait c\'est du viol institutionnalisé ?',
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
        label: 'Honnête',
        reply: 'Je mange de tout. Pas militante.',
        setBranch: 'shen_omni_v',
      ),
      RomanceChoice(
        label: 'Évasive',
        reply: 'Pas une question pour Tinder à 23h.',
        moodDelta: 1,
        setBranch: 'shen_evasive_v',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_v',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_omni_v',
    textVariants: [
      'OK. C\'est un point bloquant pour moi mais je peux essayer.',
      'Tu sais que chaque steak c\'est 15 000 L d\'eau ?',
      'Je vais te dire un truc : tu fermes les yeux sur 60 milliards d\'animaux par an.',
    ],
  ),
  // ── J+1 — Il enchaîne sur autres jugements
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'T\'es archi ? Tu travailles pour qui ? Promoteurs ?',
      'J\'ai vu tes photos. Tu portes du cuir. Ça pue.',
      'Tu vis dans le 8e ou le 16e ? Ces quartiers c\'est des micro-mondes complices.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Patiente',
        reply: 'Tu enchaînes les jugements depuis 24h.',
        moodDelta: 1,
        setBranch: 'shen_patient_v',
      ),
      RomanceChoice(
        label: 'Ironique',
        reply: 'Tu fais quoi sur Tinder un mardi à midi alors ?',
        moodDelta: 1,
        setBranch: 'shen_ironique_v',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_unmatch_v',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_patient_v',
    textVariants: [
      'Je sais. Mais j\'assume.',
      'Pardon je suis fatigué de devoir convaincre.',
      'Tu vois pas que je veux juste être avec quelqu\'un qui partage mes valeurs ?',
    ],
  ),
  // ── J+2 — Propose un café vegan obligatoire
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 14,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_ironique_v',
    textVariants: [
      'Café samedi 11h, Hank Vegan Burger. Si tu refuses, t\'as ta réponse.',
      'Resto 100% plant Wild & The Moon, mardi 20h. Test ultime.',
      'Tu peux me prouver que tu peux manger sans cadavre 1 fois.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_ironique_v',
    choices: [
      RomanceChoice(
        label: 'Tester',
        reply: 'OK je teste.',
        moodDelta: 0,
        setBranch: 'rdv_v',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_unmatch_post_v',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 23,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_v',
    textVariants: [
      'Tu m\'as demandé du lait de soja pour ton café. Je suis déçu.',
      'Tu as ri quand j\'ai dit "antispéciste". Je crois qu\'on n\'est pas alignés.',
      'Je sais que tu as commandé un kebab après. Mon copain t\'a vue.',
    ],
    endsArc: 'lui_juge_final',
  ),
];

const veganTemplate = RomanceTemplate(
  id: 'vegan_moralisateur',
  archetypeLabel: 'Vegan moralisateur',
  tone: RomanceTone.pedant,
  profilePool: veganProfiles,
  beats: veganBeats,
  minStartDay: 1,
  spawnWeight: 0.6,
  cooldownDays: 25,
  description: 'Vegan militant qui juge chaque choix de Shen. Comédie sermon 4 j.',
);
