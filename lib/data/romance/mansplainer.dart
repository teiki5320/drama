import '../../models/romance.dart';

/// MANSPLAINER PÉDANT
/// 34-38 ans, prof / chercheur / critique. Pose des questions piège,
/// corrige Shen sur son propre métier, cite Heidegger sans raison.
/// Comédie pénible. Shen ghoste ou tient pour rigoler.

const mansplainerProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'marc_v',
    name: 'Marc',
    age: 34,
    profession: 'Prof de philo Sorbonne',
    quartier: '5e',
    detail: 'cite Heidegger',
    bio: 'Penseur. Marcheur. Cherche femme cultivée et patiente.',
    gradient: [0xFF454035, 0xFF22201A],
    emoji: '📚',
    photoEmojis: ['📚', '🚶‍♂️', '☕', '🍷'],
  ),
  RomanceProfile(
    id: 'etienne_m',
    name: 'Étienne',
    age: 36,
    profession: 'Chercheur CNRS',
    quartier: '15e',
    detail: 'parle de ses publications',
    bio: 'Sciences sociales. Père d\'aucun enfant et fier.',
    gradient: [0xFF4A5A60, 0xFF1E2A30],
    emoji: '🔬',
    photoEmojis: ['🔬', '📖', '🚶‍♂️', '🍵'],
  ),
  RomanceProfile(
    id: 'florent_d',
    name: 'Florent',
    age: 32,
    profession: 'Critique de cinéma',
    quartier: '6e',
    detail: 'écrit pour les Cahiers',
    bio: 'Voit 4 films par semaine. Aimera les commenter avec toi.',
    gradient: [0xFF6B5A4A, 0xFF302418],
    emoji: '🎞️',
    photoEmojis: ['🎞️', '📝', '🎭', '🥃'],
  ),
];

const mansplainerBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Question : tu sais ce que veut dire « architecte » étymologiquement ?',
      'Ton bio mentionne l\'archi. Tu as lu Vitruve ?',
      'Hello. Tu connais le concept de Bauen-Wohnen-Denken ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Répondre vrai',
        reply: 'Oui. Et toi tu sais ce que ça fait, dessiner un escalier ?',
        moodDelta: 1,
        setBranch: 'shen_tient',
      ),
      RomanceChoice(
        label: 'Esquiver',
        reply: 'Bonsoir.',
        setBranch: 'shen_esq_man',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        endsArc: 'shen_unmatch_man_immediate',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_tient',
    textVariants: [
      'Joli renvoi. Sauf que justement, dessiner relève de la techné, '
          'pas de la poiesis. Petite confusion classique.',
      'Tu aurais pu citer Alberti plutôt. Mais bon.',
      'Hé hé. Tu me plais déjà.',
    ],
  ),
  // ── J+1 — Il revient avec un cours non demandé
  RomanceBeat(
    dayOffset: 1,
    atHour: 8,
    atMinute: 32,
    type: RomanceBeatType.text,
    textVariants: [
      'J\'ai relu ta réponse d\'hier. Quelques précisions s\'imposent.',
      'Tu permets que je te corrige un petit point ?',
      'Lecture du jour : « L\'origine de l\'œuvre d\'art ». Tu connais ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'En fait l\'architecte est moins un créateur qu\'un médiateur. '
          'Ton bio l\'évoque mal.',
      'Tu fais quoi exactement comme archi ? Intérieur ? Urbanisme ? '
          'Ça change tout.',
      'Petit fact-checking : « Architecture » vient de archi-tekton, '
          'le maître charpentier. Pas l\'artiste.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 16,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Vacharde',
        reply: 'Tu as expliqué mon métier 3 fois en 24h. Bravo.',
        moodDelta: 1,
        setBranch: 'shen_vacharde',
      ),
      RomanceChoice(
        label: 'Patiente',
        reply: 'Merci pour la leçon. Je note.',
        moodDelta: -1,
        setBranch: 'shen_patient_man',
      ),
      RomanceChoice(
        label: 'Ghost',
        reply: '',
        endsArc: 'shen_ghost_man',
      ),
    ],
  ),
  // ── J+1 — Quand vacharde, il prend mal mais continue
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_vacharde',
    textVariants: [
      'Oh. Je voulais juste élever la conversation.',
      'Pardon, tu n\'es pas obligée d\'être agressive.',
      'On peut quand même se voir si tu veux. Café samedi 11h, rue Soufflot ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 24,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_vacharde',
    choices: [
      RomanceChoice(
        label: 'Pour rigoler',
        reply: 'OK je viens pour voir.',
        moodDelta: 0,
        setBranch: 'rdv_man_curiosite',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        endsArc: 'shen_unmatch_man_late',
      ),
    ],
  ),
  // ── J+3 — RDV : il arrive avec un livre offert ──────────────
  RomanceBeat(
    dayOffset: 3,
    atHour: 10,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_man_curiosite',
    photoLabels: [
      'Café de Flore · 172 Bd Saint-Germain · 11h00',
      'Café Rostand · rue Médicis · 11h00',
      'Boulangerie Boris · rue Soufflot · 10h30',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 13,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_man_curiosite',
    textVariants: [
      'Ravi de t\'avoir éclairée sur ton métier ce matin. Le livre est à la page 47.',
      'Belle rencontre. J\'espère que tu as pris des notes mentalement.',
      'On refait ça vendredi ? J\'ai préparé une bibliographie.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 13,
    atMinute: 10,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_man_curiosite',
    choices: [
      RomanceChoice(
        label: 'Block définitif',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_man',
      ),
      RomanceChoice(
        label: 'Sarcasme final',
        reply: 'Page 47 c\'est juste un peu prétentieux non ?',
        endsArc: 'shen_sarcasme_final',
      ),
    ],
  ),
  // ── Si shen_esq_man — il insiste 2 fois puis lâche
  RomanceBeat(
    dayOffset: 1,
    atHour: 18,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_esq_man',
    textVariants: [
      'Tu refuses d\'engager le dialogue. Dommage.',
      'Je te trouvais intrigante. Tant pis.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 22,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_esq_man',
    textVariants: [
      'Une dernière question : tu lis Annie Ernaux ?',
    ],
    endsArc: 'lui_lache_apres_3',
  ),
];

const mansplainerTemplate = RomanceTemplate(
  id: 'mansplainer',
  archetypeLabel: 'Mansplainer pédant',
  tone: RomanceTone.pedant,
  profilePool: mansplainerProfiles,
  beats: mansplainerBeats,
  minStartDay: 1,
  spawnWeight: 1.0,
  cooldownDays: 20,
  description: '32-36 ans intello. Corrige Shen sur son métier, '
      'cite des références. Comédie pénible 5 jours.',
);
