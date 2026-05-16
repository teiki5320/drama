import '../../models/romance.dart';

/// BREADCRUMBER MÉTHODIQUE
/// 30-35 ans, profession sérieuse. Donne des miettes : 1 message tous
/// les 3-4 jours, jamais de RDV concret. Shen finit par confronter et
/// unmatch après 14-16 jours.

const breadcrumberProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'karim_d',
    name: 'Karim',
    age: 30,
    profession: 'Médecin urgentiste',
    quartier: '13e',
    detail: 'gardes de nuit',
    bio: 'Médecin. Pas toujours dispo. Quand je le suis, je le suis vraiment.',
    gradient: [0xFF3D5A6C, 0xFF1C2D38],
    emoji: '🩺',
    photoEmojis: ['🩺', '🌃', '☕', '🚑'],
  ),
  RomanceProfile(
    id: 'vincent_b',
    name: 'Vincent',
    age: 33,
    profession: 'Cadre chez Total',
    quartier: 'La Défense',
    detail: 'voyages business',
    bio: 'Toujours entre deux avions. Cherche quelqu\'un de stable.',
    gradient: [0xFF4A5A75, 0xFF1F2A3D],
    emoji: '✈️',
    photoEmojis: ['✈️', '🏙️', '🥃', '👔'],
  ),
  RomanceProfile(
    id: 'olivier_f',
    name: 'Olivier',
    age: 35,
    profession: 'Journaliste politique',
    quartier: '6e',
    detail: 'écrit pour Le Monde',
    bio: 'Plume tendue. Vie intense. Patience.',
    gradient: [0xFF604030, 0xFF2A1B12],
    emoji: '🖋️',
    photoEmojis: ['🖋️', '📰', '🏛️', '🌃'],
  ),
];

const breadcrumberBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Belle photo.',
      'Salut. Ton bio est intriguant.',
      'Hello. Tu fais quoi dans la vie ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 10,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Polie',
        reply: 'Bonsoir. Et toi ?',
        setBranch: 'shen_polie',
      ),
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Bonsoir. Qu\'est-ce qui t\'intrigue ?',
        moodDelta: 1,
        setBranch: 'shen_curieuse',
      ),
      RomanceChoice(
        label: 'Pas envie',
        reply: '',
        endsArc: 'shen_ghost_b',
      ),
    ],
  ),
  // ── J+0 — Il esquive et répond vague
  RomanceBeat(
    dayOffset: 0,
    atHour: 23,
    atMinute: 48,
    type: RomanceBeatType.text,
    textVariants: [
      'On en parle bientôt 😉',
      'Tu sembles bien. À voir.',
      'Je note. Bonne nuit.',
    ],
  ),
  // ── J+3 — Premier silence
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Hey. Désolé pour le silence. Semaine de garde.',
      'Trop pris. Pardon. Tu vas bien ?',
      'Bon week-end ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 16,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Patient',
        reply: 'Pas grave. Ça va.',
        setBranch: 'shen_patient',
      ),
      RomanceChoice(
        label: 'Direct',
        reply: 'On se voit quand ?',
        moodDelta: 1,
        setBranch: 'shen_pousse',
      ),
      RomanceChoice(
        label: 'Sarcastique',
        reply: 'Trois jours pour répondre, c\'est dans la moyenne haute.',
        moodDelta: 1,
        setBranch: 'shen_sarcasme',
      ),
    ],
  ),
  // ── J+3 — Quand poussé, propose un RDV vague
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_pousse',
    textVariants: [
      'Bonne question. Bientôt promis ✨',
      'Cette semaine si garde finit tôt.',
      'Je te dis demain.',
    ],
  ),
  // ── J+7 — Photo random sans contexte
  RomanceBeat(
    dayOffset: 7,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.photoShared,
    forbidBranch: 'shen_sarcasme',
    photoLabels: [
      'coucher de soleil depuis un balcon, aucun contexte',
      'son verre de vin sur une table de café',
      'la mer floue, on dirait pas Paris',
    ],
  ),
  // ── J+11 — Réapparition comme si rien
  RomanceBeat(
    dayOffset: 11,
    atHour: 14,
    atMinute: 28,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_sarcasme',
    textVariants: [
      'Tu es comment ?',
      'Coucou, ça va ?',
      'J\'ai pensé à toi.',
    ],
  ),
  RomanceBeat(
    dayOffset: 11,
    atHour: 14,
    atMinute: 32,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_sarcasme',
    choices: [
      RomanceChoice(
        label: 'Patient encore',
        reply: 'Ça va. Et toi ?',
        moodDelta: -1,
        setBranch: 'shen_re_patient',
      ),
      RomanceChoice(
        label: 'Confronter',
        reply: 'Tu fais quoi exactement avec moi ?',
        moodDelta: 1,
        setBranch: 'shen_confronte',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        endsArc: 'shen_unmatch_breadcrumb',
      ),
    ],
  ),
  // ── J+11 confrontation — il lit, il ne répond pas ───────────
  RomanceBeat(
    dayOffset: 11,
    atHour: 14,
    atMinute: 33,
    type: RomanceBeatType.seenNoReply,
    requireBranch: 'shen_confronte',
  ),
  RomanceBeat(
    dayOffset: 11,
    atHour: 23,
    atMinute: 8,
    type: RomanceBeatType.typingThenNothing,
    requireBranch: 'shen_confronte',
  ),
  RomanceBeat(
    dayOffset: 12,
    atHour: 8,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_confronte',
    choices: [
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        endsArc: 'shen_unmatch_silent_treatment',
      ),
      RomanceChoice(
        label: 'Attendre encore',
        reply: '',
        moodDelta: -2,
        setBranch: 'shen_attend',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 16,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_attend',
    textVariants: [
      'Eh. Belle photo le truc d\'hier 😉',
    ],
    endsArc: 'shen_apprend_lecon',
  ),
  // ── Si sarcastique — il prend la fuite proprement ───────────
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 20,
    type: RomanceBeatType.text,
    requireBranch: 'shen_sarcasme',
    textVariants: [
      'Touché. Bon courage.',
      'Tu n\'as pas tort. Bonne soirée.',
    ],
    endsArc: 'lui_part_proprement',
  ),
];

const breadcrumberTemplate = RomanceTemplate(
  id: 'breadcrumber',
  archetypeLabel: 'Breadcrumber méthodique',
  tone: RomanceTone.breadcrumb,
  profilePool: breadcrumberProfiles,
  beats: breadcrumberBeats,
  minStartDay: 1,
  spawnWeight: 1.0,
  cooldownDays: 25,
  description: '30-35 ans pros sérieux. Donne des miettes (1 msg/3-4j), '
      'jamais de RDV concret. 4 fins.',
);
