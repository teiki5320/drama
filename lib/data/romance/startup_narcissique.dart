import '../../models/romance.dart';

/// STARTUP NARCISSIQUE
/// 30-34 ans, founder ou C-level. Parle de lui à 95%, anglicismes
/// constants, propose "networking" plutôt qu'un café. Shen ghoste ou
/// trolle. Arc 4-6 jours, comédie pénible.

const startupProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'pierre_h_c',
    name: 'Pierre-Henri',
    age: 32,
    profession: 'CEO Foncia.io',
    quartier: '8e',
    detail: 'lance sa 3e boîte',
    bio: 'CEO. Disrupting real estate. Looking for HVL (High Value Life Partner).',
    gradient: [0xFFC09060, 0xFF5A4030],
    emoji: '🚀',
    photoEmojis: ['🚀', '💼', '🏢', '☕'],
  ),
  RomanceProfile(
    id: 'gauthier_m',
    name: 'Gauthier',
    age: 30,
    profession: 'Founder fintech',
    quartier: '2e',
    detail: 'Station F résident',
    bio: 'Founder · Levée Série A 2024 · NYC 6 mois/an',
    gradient: [0xFFB08868, 0xFF503A28],
    emoji: '💎',
    photoEmojis: ['💎', '🏙️', '🛩️', '🥃'],
  ),
  RomanceProfile(
    id: 'edouard_t',
    name: 'Édouard',
    age: 34,
    profession: 'CMO scale-up',
    quartier: '17e',
    detail: 'TEDx speaker',
    bio: 'CMO. Storyteller. Ex-McKinsey. Père d\'aucune startup encore mais '
        'on va y arriver.',
    gradient: [0xFF8C7460, 0xFF3D2F25],
    emoji: '📈',
    photoEmojis: ['📈', '👔', '🍷', '🏔️'],
  ),
];

const startupBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Hi. Ton profil est aligné avec ce que je cherche. On synchronise un coffee ?',
      'Salut. Disrupting Tinder by actually being honest : je cherche une HVL.',
      'Hello. Question : tu es plutôt early adopter ou late majority ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Trolle',
        reply: 'Plutôt « tu m\'agaces déjà ». Tu KPIes ça comment ?',
        moodDelta: 2,
        setBranch: 'shen_trolle_s',
      ),
      RomanceChoice(
        label: 'Polie',
        reply: 'Bonsoir. Tu fais quoi exactement ?',
        setBranch: 'shen_polie_s',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_s',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_polie_s',
    textVariants: [
      'CEO d\'une startup PropTech. On disrupte l\'immo. Levée Série A imminente.',
      'Founder. 4 ans McKinsey, 2 ans LVMH, maintenant je build mon thing.',
      'CMO de Lydia. Avant Boston Consulting. Avant HEC.',
    ],
  ),
  // ── J+1 — Il enchaîne sur lui-même
  RomanceBeat(
    dayOffset: 1,
    atHour: 8,
    atMinute: 14,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_trolle_s',
    textVariants: [
      'J\'ai 2 réunions de board ce matin. Je t\'écris entre deux.',
      'Closing dans 12 jours. Tu auras peu de moi cette semaine.',
      'Je vais à Dubai jeudi. Tu veux venir ? On en parle ce soir.',
    ],
  ),
  // ── J+1 — Quand troll, il se vexe vite
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 16,
    type: RomanceBeatType.text,
    requireBranch: 'shen_trolle_s',
    textVariants: [
      'Hum. Pas la peine si tu prends pas au sérieux.',
      'OK passe ton chemin. Ce sera dommage pour toi.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 23,
    atMinute: 48,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_trolle_s',
    endsArc: 'lui_unmatch_vexe_s',
  ),
  // ── J+3 — Il propose "networking"
  RomanceBeat(
    dayOffset: 3,
    atHour: 16,
    atMinute: 22,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_trolle_s',
    textVariants: [
      'Cocktail VC vendredi 19h, Pavillon Royal. Plus 1 ?',
      'Mon coach me dit que je devrais déléguer mes RDV Tinder. T\'as un café 30min mardi ?',
      'On peut faire un Zoom 15 min ? Plus efficient que texto.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 16,
    atMinute: 26,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_trolle_s',
    choices: [
      RomanceChoice(
        label: 'Ironique',
        reply: 'Tu calendly tes flirts ? OK.',
        moodDelta: 1,
        setBranch: 'shen_ironie_s',
      ),
      RomanceChoice(
        label: 'Ghost',
        reply: '',
        endsArc: 'shen_ghost_s',
      ),
    ],
  ),
  // ── J+4 — Il continue tout seul
  RomanceBeat(
    dayOffset: 4,
    atHour: 7,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ironie_s',
    textVariants: [
      'Hum. Tu as un sense of humour intéressant. À discuter.',
      'OK. Je te propose un slot de 20 min mardi 18h, mon resto fav 8e.',
      'Tu sais que je peux te faire embaucher ? Tu es archi, j\'ai des contacts.',
    ],
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 12,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ironie_s',
    textVariants: [
      'Tu ne m\'as pas répondu sur le slot mardi. Je te re-propose mercredi.',
    ],
    endsArc: 'shen_lasse_s',
  ),
];

const startupTemplate = RomanceTemplate(
  id: 'startup_narcissique',
  archetypeLabel: 'Startup narcissique',
  tone: RomanceTone.narcissist,
  profilePool: startupProfiles,
  beats: startupBeats,
  minStartDay: 1,
  spawnWeight: 0.9,
  cooldownDays: 20,
  description: '30-34 ans founder/C-level. 95 % de lui, anglicismes, '
      'networking. Comédie pénible 4-6 j.',
);
