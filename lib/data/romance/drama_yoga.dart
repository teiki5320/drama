import '../../models/romance.dart';

/// DRAMA YOGA INTERNE
/// Femme 28-32 ans prof yoga. Conversation OK, propose une séance, puis
/// drama interne s'invite : ex-élève jalouse, rumeurs studio, accusations
/// croisées. Shen prise en otage d'un milieu. Arc 4 jours.

const dramaYogaProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'anais_p',
    name: 'Anaïs',
    age: 29,
    profession: 'Prof yoga Vinyasa',
    quartier: '4e',
    detail: 'studio Marais',
    bio: 'Yoga. Vinyasa. Belleville-Marais. Présence pleine.',
    gradient: [0xFFC0A8B0, 0xFF584A50],
    emoji: '🧘‍♀️',
    photoEmojis: ['🧘‍♀️', '🌿', '🕯️', '🌷'],
  ),
  RomanceProfile(
    id: 'lila_b',
    name: 'Lila',
    age: 31,
    profession: 'Prof yoga Ashtanga',
    quartier: '11e',
    detail: 'rivale Sophie K.',
    bio: 'Ashtanga. Sérieux. Présent.',
    gradient: [0xFFA09078, 0xFF48413A],
    emoji: '🪷',
    photoEmojis: ['🪷', '🌿', '☕', '🌅'],
  ),
  RomanceProfile(
    id: 'astrid_m',
    name: 'Astrid',
    age: 28,
    profession: 'Prof Pilates',
    quartier: '17e',
    detail: 'studio nouveau',
    bio: 'Pilates. Doux. Strict. Si tu sens la différence, on s\'entendra.',
    gradient: [0xFFA8B0A0, 0xFF504A48],
    emoji: '🌸',
    photoEmojis: ['🌸', '🧘‍♀️', '🌿', '☕'],
  ),
];

const dramaYogaBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Tu as un visage qui mérite une heure de yoga par jour.',
      'Hello. Ton bio dit calme. Le mien dit pareil. Hasard ?',
      'Salut. Je viens d\'enseigner 2h. Je t\'écris doucement.',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Bonsoir. Tu enseignes où ?',
        setBranch: 'shen_curieuse_y',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_y',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_curieuse_y',
    textVariants: [
      'Studio Tigre Yoga 4e. Tu connais ?',
      'Marais et Belleville. Cours du soir.',
      'Studio TruYoga 17e. Nouveau.',
    ],
  ),
  // ── J+2 — Proposition séance gratuite
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_curieuse_y',
    textVariants: [
      'Cours offert jeudi 19h, Tigre Yoga. Tu viens ?',
      'Mardi 18h30, séance privée chez moi. Si tu veux essayer.',
      'Vendredi 12h, méditation guidée Parc Monceau. Gratuit. Viens.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_curieuse_y',
    choices: [
      RomanceChoice(
        label: 'OK',
        reply: 'OK.',
        moodDelta: 1,
        setBranch: 'rdv_y',
      ),
      RomanceChoice(
        label: 'Refuser doux',
        reply: 'Je préfère un café normal.',
        setBranch: 'shen_cafe_y',
      ),
    ],
  ),
  // ── J+3 — Drama externe : screenshot d'une élève jalouse
  RomanceBeat(
    dayOffset: 3,
    atHour: 14,
    atMinute: 4,
    type: RomanceBeatType.photoShared,
    requireBranch: 'rdv_y',
    photoLabels: [
      'screenshot d\'un long DM d\'une ex-élève qui l\'accuse d\'avoir copié '
          'sur Sophie K.',
      'screenshot d\'un avis Google « Anaïs draine ses élèves » 1 étoile',
      'capture d\'une story Instagram où on parle d\'elle sans la nommer',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 14,
    atMinute: 6,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_y',
    textVariants: [
      'Désolée de te dérouler ça mais je sais pas à qui parler. Tu en penses quoi ?',
      'Je sors de 3 h de pleurer. Tu peux me dire quoi en regardant ce screenshot ?',
      'Mon univers est en feu et je viens de te rencontrer. Pardon.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 14,
    atMinute: 10,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_y',
    choices: [
      RomanceChoice(
        label: 'Soutenir',
        reply: 'C\'est dur. T\'es pas obligée de tout porter seule.',
        moodDelta: 0,
        setBranch: 'shen_soutient_y',
      ),
      RomanceChoice(
        label: 'Reculer',
        reply: 'Je peux pas être ton thérapeute. Pardon.',
        endsArc: 'shen_recule_y',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_y',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 23,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_soutient_y',
    textVariants: [
      'Je crois que je vais devoir fermer le studio. Tu peux me prêter 500 ? '
          'Je rembourse vite.',
      'Tu peux dire à tes contacts archis de venir prendre cours chez moi ? '
          'J\'ai besoin que ça remplisse.',
    ],
    endsArc: 'lui_demande_argent_y',
  ),
];

const dramaYogaTemplate = RomanceTemplate(
  id: 'drama_yoga',
  archetypeLabel: 'Drama yoga interne',
  tone: RomanceTone.manipulative,
  profilePool: dramaYogaProfiles,
  beats: dramaYogaBeats,
  minStartDay: 1,
  spawnWeight: 0.4,
  cooldownDays: 35,
  description: 'Femme prof yoga, drama professionnel s\'invite J+3, '
      'demande argent J+4.',
);
