import '../../models/romance.dart';

/// PASSION FOUGUEUSE → DISPARAÎT DANS SON ART
/// 28-31 ans, chef cuisinier / sommelier / chocolatier. Démarre fort,
/// propose un RDV intense, puis disparaît à cause de son boulot.
/// Reviens 1× épuisé. Arc 12 jours, mélancolie de l'absence.

const passionProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'theo_b',
    name: 'Théo',
    age: 28,
    profession: 'Chef de cuisine',
    quartier: '10e',
    detail: 'service jusqu\'à 2h',
    bio: 'Cuisinier. Je travaille quand tu sors. Je sors quand tu travailles.',
    gradient: [0xFFA0522D, 0xFF3D1F12],
    emoji: '🔪',
    photoEmojis: ['🔪', '🍅', '🔥', '🍷'],
  ),
  RomanceProfile(
    id: 'lucas_m',
    name: 'Lucas',
    age: 30,
    profession: 'Maître chocolatier',
    quartier: '12e',
    detail: 'mains tachées de cacao',
    bio: 'Je fais fondre du chocolat à 32°. Pour 12h par jour.',
    gradient: [0xFF6B3D2A, 0xFF2E1812],
    emoji: '🍫',
    photoEmojis: ['🍫', '🧪', '🔥', '☕'],
  ),
  RomanceProfile(
    id: 'quentin_h',
    name: 'Quentin',
    age: 31,
    profession: 'Sommelier',
    quartier: '7e',
    detail: 'crachoir argent',
    bio: 'Sommelier 3 étoiles. Je goûte 80 vins par jour. Je ne dors plus.',
    gradient: [0xFF4A1F2B, 0xFF22101A],
    emoji: '🍷',
    photoEmojis: ['🍷', '🍾', '🥂', '🌙'],
  ),
];

const passionBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 6,
    type: RomanceBeatType.photoShared,
    photoLabels: [
      'son plan de travail à 2h du matin, tout est rangé',
      'un fond de marmite avec une herbe verte',
      'la cuisine du resto vide, néons éteints',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 7,
    type: RomanceBeatType.text,
    textVariants: [
      'Je rentre. Tinder à 2h du matin, c\'est mauvais signe.',
      'Service fini. Je swipe sans regarder. Pardon.',
      'Salut. Je suis crevé mais ton sourire m\'a réveillé.',
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
        label: 'Curieuse',
        reply: 'Tu cuisines quoi ?',
        moodDelta: 1,
        setBranch: 'shen_curieuse_p',
      ),
      RomanceChoice(
        label: 'Sec',
        reply: 'Va dormir.',
        setBranch: 'shen_sec_p',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ghost_p',
      ),
    ],
  ),
  // ── J+1-2 — Échange intense
  RomanceBeat(
    dayOffset: 1,
    atHour: 15,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_curieuse_p',
    textVariants: [
      'Cuisine de bistrot, viande maturée, légumes oubliés. Tu manges quoi le soir ?',
      'Une cuisine de saison qui fait pleurer les vieux. Tu cuisines toi ?',
      'Je tape vite parce que je dois être au labo dans 1h. Tu vis où ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 23,
    atMinute: 14,
    type: RomanceBeatType.voiceNote,
    voiceDurationS: 24,
    requireBranch: 'shen_curieuse_p',
    textVariants: [
      'vocal 24 s — il chuchote depuis sa cuisine — « j\'ai goûté '
          'le bouillon en pensant à toi, c\'est ridicule, je sais »',
    ],
  ),
  // ── J+3 — Propose un RDV intense
  RomanceBeat(
    dayOffset: 3,
    atHour: 12,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_curieuse_p',
    textVariants: [
      'Demain je ferme à minuit. Tu viens au resto à 23h30 ? Je te fais à manger après.',
      'Lundi je suis off. Marché Aligre 9h, après mon appart. Je cuisine pour toi.',
      'Vendredi 1h du matin, après service. Je sais c\'est tard. Mais c\'est la vérité.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 12,
    atMinute: 12,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_curieuse_p',
    choices: [
      RomanceChoice(
        label: 'OK fou',
        reply: 'OK. Je viendrai.',
        moodDelta: 2,
        setBranch: 'rdv_intense',
      ),
      RomanceChoice(
        label: 'Contre-proposer',
        reply: 'Plutôt un café normal en pleine journée ?',
        setBranch: 'rdv_normal',
      ),
      RomanceChoice(
        label: 'Décliner',
        reply: 'Trop intense pour moi.',
        endsArc: 'shen_decline_p',
      ),
    ],
  ),
  // ── J+4 — Pré-RDV, il ne répond pas tout de suite à un message
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_intense',
    textVariants: [
      'Service du soir compliqué. On reste sur 23h30 si tu veux.',
      'Désolé, gros service. À tout à l\'heure.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 23,
    atMinute: 48,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_intense',
    textVariants: [
      'Je sors dans 10 min. Tu es où ?',
      'Pardon retard. Service infernal. J\'arrive.',
      'Encore 5 min. Bois un truc.',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 9,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_intense',
    textVariants: [
      'Hier était une nuit. Merci.',
      'Je dors enfin. À ce soir si tu veux.',
      'Tu as quitté ma cuisine il y a 4h, j\'ai pas dormi.',
    ],
  ),
  // ── J+6 — Premier silence, le job revient
  RomanceBeat(
    dayOffset: 6,
    atHour: 23,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_intense',
    textVariants: [
      'Pardon. Semaine de fou. Sous-chef tombé malade.',
      'Pas de signe. Je remonte de la cave dans 1h.',
      'Plus d\'oxygène. Reviens si tu veux.',
    ],
  ),
  // ── J+8-9 — Il disparaît
  RomanceBeat(
    dayOffset: 9,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_intense',
    choices: [
      RomanceChoice(
        label: 'Relancer',
        reply: 'Tu es vivant ?',
        setBranch: 'shen_relance',
      ),
      RomanceChoice(
        label: 'Attendre',
        reply: '',
        moodDelta: -1,
        setBranch: 'shen_attend_p',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        endsArc: 'shen_unmatch_p',
      ),
    ],
  ),
  // ── J+10 — Il revient épuisé
  RomanceBeat(
    dayOffset: 10,
    atHour: 3,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_relance',
    textVariants: [
      'Pardon. Je vois ça maintenant. Je suis défoncé.',
      'Pardon pardon. La semaine m\'a mangé.',
      'Coucou. Désolé. Service de 18h.',
    ],
  ),
  RomanceBeat(
    dayOffset: 10,
    atHour: 3,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_relance',
    textVariants: [
      'Je peux pas faire mieux. C\'est mon métier. C\'est moi.',
      'Si tu veux d\'un mec qui rentre à 1h, je suis ton homme. '
          'Sinon je comprendrai.',
    ],
  ),
  RomanceBeat(
    dayOffset: 10,
    atHour: 3,
    atMinute: 22,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_relance',
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'OK. À ton rythme.',
        moodDelta: 1,
        setBranch: 'shen_accepte_rythme',
      ),
      RomanceChoice(
        label: 'Lâcher',
        reply: 'Je peux pas vivre dans tes restes de service. Bonne suite.',
        moodDelta: 1,
        endsArc: 'shen_lache_p',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 12,
    atHour: 2,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_accepte_rythme',
    textVariants: [
      'Sous-chef remplacé. Je dors lundi. Tu viens ?',
    ],
    endsArc: 'rdv_planifie_long',
  ),
  // ── J+14 — Si Shen attend silencieusement, il oublie
  RomanceBeat(
    dayOffset: 14,
    atHour: 22,
    atMinute: 8,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_attend_p',
    endsArc: 'lui_unmatch_oubli',
  ),
];

const passionTemplate = RomanceTemplate(
  id: 'passion_fougueuse',
  archetypeLabel: 'Passion fougueuse → disparaît',
  tone: RomanceTone.passionate,
  profilePool: passionProfiles,
  beats: passionBeats,
  minStartDay: 1,
  spawnWeight: 0.9,
  cooldownDays: 25,
  description: '28-31 ans chef/artiste. Démarre fort, RDV nocturne intense, '
      'disparaît dans son art. Revient 1× épuisé.',
);
