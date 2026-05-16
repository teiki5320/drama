import '../../models/romance.dart';

/// LOVEBOMBER PATHÉTIQUE
/// Profil 23-25 ans, créatif autoproclamé. Submerge en 24h, devient
/// jaloux J+1, s'écroule J+2, désamorce J+3.
/// Arc court (3-4 jours), comédie pénible.

const lovebombProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'leo_g',
    name: 'Léo',
    age: 23,
    profession: 'Photographe',
    quartier: '20e',
    detail: 'shoots argentiques',
    bio: 'Photographe. Pellicule 35mm. Tes yeux.',
    gradient: [0xFFE07A5F, 0xFF813A2A],
    emoji: '📸',
    photoEmojis: ['📸', '🎞️', '🌅', '🖤'],
  ),
  RomanceProfile(
    id: 'adrien_s',
    name: 'Adrien',
    age: 25,
    profession: 'Master cinéma',
    quartier: '5e',
    detail: 'cite Truffaut sans raison',
    bio: 'Je rêve en 24 images/seconde. Pour de vrai.',
    gradient: [0xFFB07D4A, 0xFF5C3A20],
    emoji: '🎞️',
    photoEmojis: ['🎞️', '🍷', '🎬', '✍️'],
  ),
  RomanceProfile(
    id: 'yann_b',
    name: 'Yann',
    age: 24,
    profession: 'Community manager',
    quartier: '19e',
    detail: 'parle en hashtags',
    bio: 'Vibes only. Sois vraie.',
    gradient: [0xFFD17C9C, 0xFF6B3D55],
    emoji: '✨',
    photoEmojis: ['✨', '🌈', '🌺', '🌸'],
  ),
];

const lovebombBeats = <RomanceBeat>[
  // ── J+0 — Burst immédiat dans la première heure ───────────────
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 1,
    type: RomanceBeatType.text,
    textVariants: ['Salut'],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 2,
    type: RomanceBeatType.text,
    textVariants: ['T\'es magnifique', 'Je crois que t\'es spéciale', 'Wahou'],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 3,
    type: RomanceBeatType.text,
    textVariants: [
      'T\'aimes quoi',
      'Tu fais quoi ce soir',
      'On peut s\'appeler ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 4,
    type: RomanceBeatType.text,
    textVariants: [
      'Moi photo',
      'Moi cinéma c\'est ma life',
      'J\'ai vu ta photo 4 fois en 2 min',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 5,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu fais quoi vendredi',
      'On se voit quand',
      'Réponds bébé',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 7,
    type: RomanceBeatType.text,
    textVariants: ['Réponds', '?', 'Allô', 'Tu m\'ignores ?'],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Calmer',
        reply: 'Calme-toi, j\'étais sous la douche.',
        moodDelta: 0,
        setBranch: 'shen_calme',
      ),
      RomanceChoice(
        label: 'Sec',
        reply: 'Tu as envoyé 6 messages en 7 minutes. Stop.',
        moodDelta: 1,
        setBranch: 'shen_stop',
      ),
      RomanceChoice(
        label: 'Ironique',
        reply: 'On a déjà fait l\'amour, là ? J\'ai loupé un truc ?',
        moodDelta: 2,
        setBranch: 'shen_ironique',
      ),
      RomanceChoice(
        label: 'Unmatch direct',
        reply: '',
        endsArc: 'shen_unmatch_immediate',
      ),
    ],
  ),
  // ── J+1 — Il revient comme si de rien ────────────────────────
  RomanceBeat(
    dayOffset: 1,
    atHour: 7,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonjour bébé. Bien dormi ?',
      'Coucou ma douce',
      'Salut ma muse',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 11,
    atMinute: 32,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu réponds à qui ce matin ?',
      'T\'es en ligne et tu me lis pas. C\'est moche.',
      'Tu fais exprès là',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 11,
    atMinute: 35,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Distance',
        reply: 'Je ne te dois rien. On s\'est matchés hier.',
        moodDelta: 1,
        setBranch: 'shen_distance',
      ),
      RomanceChoice(
        label: 'Cassant',
        reply: 'Bébé je suis pas. Et tu sais pas mon prénom.',
        moodDelta: 2,
        setBranch: 'shen_cassant',
      ),
      RomanceChoice(
        label: 'Silencieuse',
        reply: '',
        setBranch: 'shen_silence',
      ),
    ],
  ),
  // ── J+1 — Il s'effondre selon la branche ────────────────────
  RomanceBeat(
    dayOffset: 1,
    atHour: 18,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_cassant',
    textVariants: [
      'OK TU SAIS QUOI OUBLIE',
      'C\'EST BON J\'AI COMPRIS',
      'Tu sais pas ce que tu perds',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 18,
    atMinute: 5,
    type: RomanceBeatType.text,
    requireBranch: 'shen_cassant',
    textVariants: [
      'Pardon. Je voulais juste te parler.',
      'Excuse-moi. Tu peux m\'oublier.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 18,
    atMinute: 7,
    type: RomanceBeatType.text,
    requireBranch: 'shen_cassant',
    textVariants: [
      'En vrai j\'avais bu deux gins. Pardon.',
      'Bonne soirée.',
    ],
    endsArc: 'lui_excuses_basses',
  ),
  // ── J+2 — Silence treatment puis "OUBLIE" final ──────────────
  RomanceBeat(
    dayOffset: 2,
    atHour: 14,
    atMinute: 2,
    type: RomanceBeatType.text,
    requireBranch: 'shen_silence',
    textVariants: [
      'OUBLIE OUBLIE J\'AI RIEN DIT',
      'Tu m\'ignores. C\'est fait. Adieu.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 23,
    atMinute: 12,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_silence',
    endsArc: 'lui_unmatch_dignite',
  ),
  // ── Si Shen calme — il propose RDV très vite ────────────────
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_calme',
    textVariants: [
      'On se voit ce soir 21h, chez moi 20e ?',
      'Vendredi 18h, hôtel République ?',
      'Je passe te chercher à 19h. Donne moi l\'adresse.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 35,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_calme',
    choices: [
      RomanceChoice(
        label: 'Non merci',
        reply: 'Non. Trop tôt.',
        endsArc: 'shen_decline_rdv',
      ),
      RomanceChoice(
        label: 'Unmatch maintenant',
        reply: '',
        endsArc: 'shen_unmatch_late',
      ),
    ],
  ),
  // ── Si ironique, il prend mal ───────────────────────────────
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ironique',
    textVariants: [
      'Tu te crois drôle ?',
      'OK bouffonne.',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 23,
    atMinute: 48,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_ironique',
    endsArc: 'lui_unmatch_vexe',
  ),
];

const lovebombTemplate = RomanceTemplate(
  id: 'lovebomber',
  archetypeLabel: 'Lovebomber pathétique',
  tone: RomanceTone.lovebomb,
  profilePool: lovebombProfiles,
  beats: lovebombBeats,
  minStartDay: 1,
  spawnWeight: 1.2,
  cooldownDays: 15,
  description: '23-25 ans, créatif autoproclamé. Submerge en 24h, '
      'jaloux J+1, s\'effondre J+2. 4 fins possibles.',
);
