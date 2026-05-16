import '../../models/romance.dart';

/// PREDATOR TRANSACTIONNEL
/// 26-32 ans, fric ostentatoire. Direct, agressif, escalade vite vers
/// transactionnel ou explicite. Shen bloque, signal, fin.
/// Arc 2 jours, sketch glaçant.

const predatorProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'quentin_v',
    name: 'Quentin',
    age: 27,
    profession: 'Trader chez Société Générale',
    quartier: '8e',
    detail: 'crossfit',
    bio: 'Charcuterie · Crossfit · Bons vivants',
    gradient: [0xFF888888, 0xFF2A2A2A],
    emoji: '🍖',
    photoEmojis: ['🍖', '💪', '🏎️', '🥃'],
  ),
  RomanceProfile(
    id: 'pierry_c',
    name: 'Pierry',
    age: 30,
    profession: 'Conseil stratégique',
    quartier: '7e',
    detail: 'beaucoup d\'anglicismes',
    bio: 'Closer. Driven. Pragmatique.',
    gradient: [0xFFA38A6E, 0xFF4A3A2E],
    emoji: '👔',
    photoEmojis: ['👔', '🏢', '🥃', '🚁'],
  ),
  RomanceProfile(
    id: 'leopold_e',
    name: 'Léopold',
    age: 32,
    profession: 'Promoteur immobilier',
    quartier: '16e',
    detail: 'monte ses dossiers vite',
    bio: 'Les vraies femmes, je sais comment les traiter.',
    gradient: [0xFF5C3D2E, 0xFF2E1F18],
    emoji: '🏛️',
    photoEmojis: ['🏛️', '🛥️', '🍾', '🚗'],
  ),
];

const predatorBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 4,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Toi ce soir ?',
      'Salut. T\'es belle. Où ?',
      'Hey. Tu vis seule ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 5,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Stop',
        reply: 'Direct là. Tu peux ralentir ?',
        setBranch: 'shen_stop_pred',
      ),
      RomanceChoice(
        label: 'Ironique',
        reply: 'Et toi t\'as un Q.I. ?',
        moodDelta: 2,
        setBranch: 'shen_ironique_pred',
      ),
      RomanceChoice(
        label: 'Block direct',
        reply: '',
        endsArc: 'shen_block_immediate',
      ),
    ],
  ),
  // ── J+0 — Il escalade ────────────────────────────────────────
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_stop_pred',
    textVariants: [
      'Tu fais quoi. Envoie une photo.',
      'T\'es libre maintenant ?',
      'J\'ai un appart à Bastille. Free pour toi.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 10,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_stop_pred',
    choices: [
      RomanceChoice(
        label: 'Sec',
        reply: 'Non.',
        setBranch: 'shen_sec_pred',
      ),
      RomanceChoice(
        label: 'Block + signal',
        reply: '',
        endsArc: 'shen_block_signal',
      ),
    ],
  ),
  // ── J+1 — Quand sec, il escalade encore ─────────────────────
  RomanceBeat(
    dayOffset: 2,
    atHour: 9,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_sec_pred',
    textVariants: [
      'J\'ai un appart à République. 250 € la soirée. Je paie le trajet.',
      'Tu veux quoi exactement ? Soyons clairs.',
      'Tu t\'inscris sur Tinder pour faire la sucrée ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 9,
    atMinute: 8,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_sec_pred',
    choices: [
      RomanceChoice(
        label: 'Block + signal',
        reply: '',
        endsArc: 'shen_block_signal_late',
      ),
    ],
  ),
  // ── Ironique : il prend mal et insulte ──────────────────────
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ironique_pred',
    textVariants: [
      'Bof. Pas intéressé en fait.',
      'Tu te crois drôle. Bonne suite.',
      'Pute.',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 10,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_ironique_pred',
    choices: [
      RomanceChoice(
        label: 'Block + signal',
        reply: '',
        endsArc: 'shen_block_signal_insulte',
      ),
    ],
  ),
];

const predatorTemplate = RomanceTemplate(
  id: 'predator',
  archetypeLabel: 'Predator transactionnel',
  tone: RomanceTone.predator,
  profilePool: predatorProfiles,
  beats: predatorBeats,
  minStartDay: 1,
  spawnWeight: 0.7,
  cooldownDays: 30,
  description: '26-32 ans fric. Direct, agressif, transactionnel. '
      'Sketch glaçant 2 jours.',
);
