import '../../models/romance.dart';

/// REFUGE SAIN
/// 28-33 ans, posé, lit, n'attend rien. Devient un espace de calme si
/// Shen se confie. Reste longtemps même sans demande, s'éteint
/// doucement si Shen reste fermée.

const refugeProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'sebastien_o',
    name: 'Sébastien',
    age: 31,
    profession: 'Ingénieur · médite',
    quartier: '14e',
    detail: 'silence',
    bio: 'Pas pressé. Pas vendeur. Disponible si tu veux.',
    gradient: [0xFF5B7A5C, 0xFF2E4530],
    emoji: '🍃',
    photoEmojis: ['🍃', '🪴', '☕', '📖'],
  ),
  RomanceProfile(
    id: 'thibault_p',
    name: 'Thibault',
    age: 29,
    profession: 'Prof de piano',
    quartier: '5e',
    detail: 'écoute longtemps',
    bio: 'Je joue. J\'écoute. Je ne pose pas de questions inutiles.',
    gradient: [0xFF4A4060, 0xFF221A30],
    emoji: '🎹',
    photoEmojis: ['🎹', '🕯️', '📚', '🌙'],
  ),
  RomanceProfile(
    id: 'daniel_k',
    name: 'Daniel',
    age: 33,
    profession: 'Luthier',
    quartier: '11e',
    detail: 'mains marquées',
    bio: 'Je fabrique des violons. Lentement. Comme tout.',
    gradient: [0xFF6B4423, 0xFF2D1B0E],
    emoji: '🎻',
    photoEmojis: ['🎻', '🪵', '🪛', '🌿'],
  ),
];

const refugeBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Pas pressé. Quand tu veux.',
      'Bonjour. Pas obligée de répondre.',
      'Salut. Tu m\'as eu en swipant, je ne sais pas pourquoi mais ça m\'a touché.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 19,
    atMinute: 4,
    type: RomanceBeatType.text,
    textVariants: [
      'Pour info : t\'es pas obligée de répondre vite. Ou pas du tout.',
      'Tu as eu une journée comment ?',
      'Pas de pression. Juste curieux.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 19,
    atMinute: 6,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Ouvert',
        reply: 'Compliquée. Mais merci de le demander comme ça.',
        moodDelta: 1,
        setBranch: 'shen_ouvre',
      ),
      RomanceChoice(
        label: 'Léger',
        reply: 'Ça va. Toi ?',
        setBranch: 'shen_leger',
      ),
      RomanceChoice(
        label: 'Tester',
        reply: 'Tu poses des questions comme ça à tout le monde ?',
        moodDelta: 1,
        setBranch: 'shen_teste',
      ),
    ],
  ),
  // ── J+2-3 : il dépose une question vraie, sans poids
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ouvre',
    textVariants: [
      'Tu as quelqu\'un avec qui en parler ?',
      'Si tu veux pas dire pourquoi, je comprends. Je suis là quand même.',
      'Compliquée comment ? Si tu veux.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 22,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_ouvre',
    choices: [
      RomanceChoice(
        label: 'Maman',
        reply: 'Ma mère est malade. Beaucoup d\'argent à trouver. Beaucoup.',
        moodDelta: 1,
        setBranch: 'shen_dit_maman',
      ),
      RomanceChoice(
        label: 'Vague',
        reply: 'Famille. Argent. Le combo.',
        setBranch: 'shen_vague',
      ),
      RomanceChoice(
        label: 'Refermer',
        reply: 'En fait je préfère qu\'on parle de toi.',
        setBranch: 'shen_referme',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 28,
    type: RomanceBeatType.text,
    requireBranch: 'shen_dit_maman',
    textVariants: [
      'Ok. Je vais pas te dire que je comprends parce que je comprends pas. '
          'Mais je peux écouter.',
      'Merci de m\'avoir dit. Vraiment.',
      'Je suis désolé. Tu te débrouilles toute seule pour l\'argent ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 20,
    atMinute: 8,
    type: RomanceBeatType.voiceNote,
    voiceDurationS: 52,
    requireBranch: 'shen_dit_maman',
    textVariants: [
      'vocal 52 s : voix calme et basse — il dit qu\'il n\'a pas de solution, '
          'qu\'il n\'essaiera pas d\'en inventer, et que si elle veut '
          'parler à 3h du matin c\'est ouvert',
    ],
  ),
  // ── J+5 : proposition légère
  RomanceBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_dit_maman',
    textVariants: [
      'Buttes-Chaumont dimanche matin si tu veux. Pas de pression.',
      'Si tu as envie de marcher sans parler dimanche. Je suis là.',
      'Café samedi 11h ou pas. Comme tu veux.',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_dit_maman',
    choices: [
      RomanceChoice(
        label: 'Oui',
        reply: 'Oui. J\'aimerais bien.',
        moodDelta: 2,
        setBranch: 'rdv_refuge',
      ),
      RomanceChoice(
        label: 'Pas maintenant',
        reply: 'Plus tard. Mais reste si tu veux.',
        moodDelta: 1,
        setBranch: 'rdv_plus_tard',
      ),
    ],
  ),
  // ── J+7 — Le RDV (si rdv_refuge)
  RomanceBeat(
    dayOffset: 7,
    atHour: 10,
    atMinute: 8,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_refuge',
    photoLabels: [
      'Buttes-Chaumont · kiosque · 11h00',
      'Square du Temple · entrée Bretagne · 11h00',
      'Promenade plantée · Bastille · 11h30',
    ],
  ),
  RomanceBeat(
    dayOffset: 7,
    atHour: 13,
    atMinute: 42,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_refuge',
    textVariants: [
      'Merci pour ce matin. Pas besoin de répondre.',
      'C\'était une belle marche. Vraiment.',
      'Tu peux m\'écrire à 3h du matin, je l\'ai pensé. Je le dis.',
    ],
  ),
  // ── J+15+ — Il reste présent en SMS sporadiques sains
  RomanceBeat(
    dayOffset: 15,
    atHour: 21,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_refuge',
    textVariants: [
      'Hey. Je pense à toi. Pas plus.',
      'Tu vas bien ?',
      'J\'ai vu un escalier ce matin qui m\'a fait penser à toi sans savoir pourquoi.',
    ],
  ),
  RomanceBeat(
    dayOffset: 22,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_refuge',
    textVariants: [
      'Si t\'as besoin de quelqu\'un qui connaît personne dans ta vie, je suis là.',
      'Ne me réponds pas si tu veux. C\'est juste un signe.',
    ],
  ),
  RomanceBeat(
    dayOffset: 30,
    atHour: 20,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_refuge',
    textVariants: [
      'Toujours là. Sans urgence.',
    ],
    endsArc: 'refuge_durable',
  ),
  // ── Si Shen referme tôt — il s'éteint doucement ──────────────
  RomanceBeat(
    dayOffset: 5,
    atHour: 21,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_referme',
    textVariants: [
      'Ok. Bonne soirée alors.',
      'Pas de problème. Bonne suite.',
    ],
  ),
  RomanceBeat(
    dayOffset: 12,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_referme',
    textVariants: [
      'Prends soin de toi.',
    ],
    endsArc: 'refuge_fade_doux',
  ),
  // ── Si shen_leger — RDV léger possible ─────────────────────
  RomanceBeat(
    dayOffset: 4,
    atHour: 14,
    atMinute: 12,
    type: RomanceBeatType.text,
    requireBranch: 'shen_leger',
    textVariants: [
      'Café samedi 11h, Coutume Babylone ? Sans engagement.',
      'Si t\'as envie d\'un thé sans devoir parler de soi, dimanche 15h.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 14,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_leger',
    choices: [
      RomanceChoice(
        label: 'Oui léger',
        reply: 'OK. Sans engagement.',
        moodDelta: 1,
        setBranch: 'rdv_leger',
      ),
      RomanceChoice(
        label: 'Pas envie',
        reply: 'Je préfère pas. Bonne suite.',
        endsArc: 'shen_decline_leger',
      ),
    ],
  ),
];

const refugeTemplate = RomanceTemplate(
  id: 'refuge_sain',
  archetypeLabel: 'Refuge sain',
  tone: RomanceTone.refuge,
  profilePool: refugeProfiles,
  beats: refugeBeats,
  minStartDay: 1,
  spawnWeight: 0.8,
  cooldownDays: 35,
  description: '28-33 ans, posé, écoute. Devient un espace calme. '
      'Peut durer 30 j+, ou s\'éteint doucement.',
);
