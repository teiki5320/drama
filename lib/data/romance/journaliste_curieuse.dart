import '../../models/romance.dart';

/// JOURNALISTE TROP CURIEUSE
/// Femme 28-34 ans, journaliste investigation. Pose des questions
/// précises, dérive vers le pro. Shen recule par peur d'être démasquée
/// (contrat Heng). Arc 5-6 jours.

const journalisteProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'ines_b',
    name: 'Inès',
    age: 30,
    profession: 'Journaliste Libé',
    quartier: '10e',
    detail: 'enquête immobilier de luxe',
    bio: 'Journaliste investigation. Je pose les questions que personne ne pose.',
    gradient: [0xFF7C5E8C, 0xFF382A40],
    emoji: '🗞️',
    photoEmojis: ['🗞️', '🖊️', '☕', '🎤'],
  ),
  RomanceProfile(
    id: 'alice_t',
    name: 'Alice',
    age: 32,
    profession: 'Mediapart',
    quartier: '11e',
    detail: 'enquête influence',
    bio: 'Journaliste politique. Mediapart. Je laisse personne tranquille.',
    gradient: [0xFF5C5078, 0xFF2A2438],
    emoji: '📰',
    photoEmojis: ['📰', '🎙️', '☕', '📖'],
  ),
  RomanceProfile(
    id: 'sarah_d',
    name: 'Sarah',
    age: 28,
    profession: 'Le Monde — pige éco',
    quartier: '15e',
    detail: 'écrit sur le luxe',
    bio: 'Économie du luxe. Pige Le Monde. Travailler tard ne me pèse pas.',
    gradient: [0xFF6C5C70, 0xFF2E2A36],
    emoji: '🖋️',
    photoEmojis: ['🖋️', '☕', '🌃', '📚'],
  ),
];

const journalisteBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Tu es archi, et ta bio dit que tu cherches du calme. '
          'Quel genre de calme ?',
      'Salut. Architecte, c\'est un métier de privilégiés ou d\'esclaves ? '
          'Vrai question.',
      'Bonjour. Tu fais des projets bureau ou résidentiel ?',
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
        reply: 'Bonsoir. Question intéressante.',
        setBranch: 'shen_curieuse_j',
      ),
      RomanceChoice(
        label: 'Méfiante',
        reply: 'Tu es journaliste, c\'est ça ?',
        moodDelta: 1,
        setBranch: 'shen_mef_j',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_j',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 24,
    type: RomanceBeatType.text,
    requireBranch: 'shen_mef_j',
    textVariants: [
      'Oui. Et alors ?',
      'Bien vu. Libé. Tu connais ?',
      'C\'est mon métier mais c\'est pas ce soir.',
    ],
  ),
  // ── J+1-2 — Elle pose des questions plus précises
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 18,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu connais Heng International ? Je couvre un dossier là-dessus.',
      'Tu m\'as dit que tu vivais où exactement ? Le 8e a beaucoup changé.',
      'Question chelou peut-être : tu connais Tristan Heng ? On me l\'a cité dans une enquête.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 24,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Panique',
        reply: 'Pourquoi tu poses cette question ?',
        moodDelta: -1,
        setBranch: 'shen_panique_j',
      ),
      RomanceChoice(
        label: 'Évasive',
        reply: 'De nom, comme tout le monde.',
        setBranch: 'shen_evasive_j',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        endsArc: 'shen_block_j',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 28,
    type: RomanceBeatType.text,
    requireBranch: 'shen_panique_j',
    textVariants: [
      'Oh. T\'as réagi vite. Note prise.',
      'Pardon. C\'est mon réflexe. Je te lâche.',
      'On peut juste boire un verre sans que je sois en interview, promis.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 32,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_panique_j',
    choices: [
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_panic_j',
      ),
      RomanceChoice(
        label: 'Tenter',
        reply: 'Verre sans interview. Promis ?',
        setBranch: 'rdv_j',
      ),
    ],
  ),
  // ── J+4 — Le RDV, elle tient parole 90%
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_j',
    photoLabels: [
      'Combat · 63 rue de Belleville · 19h00',
      'La Buvette · rue Saint-Maur · 19h30',
      'Le Syndicat · 51 rue du Faubourg-Saint-Denis · 20h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 23,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_j',
    textVariants: [
      'Merci pour ce soir. J\'ai pas posé une question pro. Tu vois.',
      'C\'était bien. Mais tu m\'as à peine regardée dans les yeux.',
      'Tu as menti deux fois ce soir. Petit mensonge, mais menti.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 23,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_j',
    choices: [
      RomanceChoice(
        label: 'Confession partielle',
        reply: 'Tu as raison. Je peux pas tout dire.',
        moodDelta: 1,
        endsArc: 'j_arret_propre',
      ),
      RomanceChoice(
        label: 'Bloquer',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_post_rdv_j',
      ),
    ],
  ),
];

const journalisteTemplate = RomanceTemplate(
  id: 'journaliste_curieuse',
  archetypeLabel: 'Journaliste trop curieuse',
  tone: RomanceTone.adult,
  profilePool: journalisteProfiles,
  beats: journalisteBeats,
  minStartDay: 1,
  spawnWeight: 0.5,
  cooldownDays: 35,
  description: 'Femme journaliste investigation. Pose questions pro, '
      'dérive vers Heng. Shen panique.',
);
