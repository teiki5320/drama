import '../../models/romance.dart';

/// DÉPART IMMINENT
/// 28-33 ans, va partir loin sous 1-2 semaines. Romance compressée,
/// intense, conscience du temps qui file. Arc 5-7 jours.

const departProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'nathan_d',
    name: 'Nathan',
    age: 29,
    profession: 'Militaire OPEX',
    quartier: '8e',
    detail: 'départ Mali J+12',
    bio: 'Capitaine. Je pars en mission dans 12 jours. Cherche peu, donne tout.',
    gradient: [0xFF45525C, 0xFF1E262C],
    emoji: '🪖',
    photoEmojis: ['🪖', '✈️', '🏜️', '☕'],
  ),
  RomanceProfile(
    id: 'simon_e',
    name: 'Simon',
    age: 31,
    profession: 'Doctorant astrophysique',
    quartier: '13e',
    detail: 'expat Chili 18 mois',
    bio: 'Astrophysique. Je pars 18 mois à La Silla dans 10 jours.',
    gradient: [0xFF2D3F5C, 0xFF12192E],
    emoji: '🌌',
    photoEmojis: ['🌌', '🔭', '🏔️', '📖'],
  ),
  RomanceProfile(
    id: 'jules_r',
    name: 'Jules',
    age: 33,
    profession: 'Diplomate Quai d\'Orsay',
    quartier: '7e',
    detail: 'départ Hanoï J+14',
    bio: 'Diplomate. Prochain poste Hanoï dans deux semaines.',
    gradient: [0xFF5A3D2A, 0xFF2A1A12],
    emoji: '🌏',
    photoEmojis: ['🌏', '✈️', '☕', '📰'],
  ),
];

const departBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Important : je pars dans deux semaines pour longtemps. '
          'Tu décides si on perd notre temps ou pas.',
      'Salut. Je dois t\'avertir : départ imminent. Pas d\'embrouilles.',
      'Bonjour. Profil Tinder spécial départ : 12 jours avant l\'avion. '
          'À toi.',
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
        label: 'Tentée',
        reply: 'OK tu m\'intrigues.',
        moodDelta: 1,
        setBranch: 'shen_tentee_d',
      ),
      RomanceChoice(
        label: 'Trop court',
        reply: 'Trop court pour moi. Pardon.',
        endsArc: 'shen_decline_d',
      ),
      RomanceChoice(
        label: 'Mathieu',
        reply: 'Pourquoi tu veux rencontrer quelqu\'un avant de partir ?',
        moodDelta: 1,
        setBranch: 'shen_question_d',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 1,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_question_d',
    textVariants: [
      'Pour savoir que je sais encore. Avant la mission.',
      'Pour ne pas partir avec des sacs en moins.',
      'Pour ressentir un truc qui ne se termine pas dans un mémo militaire.',
    ],
  ),
  // ── J+1 — Proposition rapide
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 8,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_decline_d',
    textVariants: [
      'Je suis libre ce soir 20h. Le Petit Vendôme. Je te plais ?',
      'Demain 19h, Le Mary Celeste. Pas besoin de te maquiller.',
      'Ce week-end, balade Vincennes ? J\'ai 8 jours.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_decline_d',
    choices: [
      RomanceChoice(
        label: 'OK ce soir',
        reply: 'OK. Ce soir.',
        moodDelta: 2,
        setBranch: 'rdv_express_d',
      ),
      RomanceChoice(
        label: 'Reporter doux',
        reply: 'Demain plutôt. Aujourd\'hui c\'est compliqué.',
        moodDelta: 1,
        setBranch: 'rdv_d2',
      ),
      RomanceChoice(
        label: 'Pas envie',
        reply: 'En fait je peux pas. Bon départ.',
        endsArc: 'shen_recule_d',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 9,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_express_d',
    textVariants: [
      'Merci pour hier soir. C\'était dense et bref. Comme moi.',
      'J\'ai rarement parlé autant avec quelqu\'un.',
      'Je crois que tu m\'as donné une raison de revenir.',
    ],
  ),
  // ── J+4 — Lui propose un deuxième moment
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_express_d',
    textVariants: [
      'Samedi 14h, Vincennes ? J\'ai 6 jours.',
      'Vendredi soir, restaurant ? J\'invite. J\'ai pas envie d\'économiser.',
      'On peut juste passer un week-end ensemble. Sans étiquette.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_express_d',
    choices: [
      RomanceChoice(
        label: 'Tout donner',
        reply: 'OK. Le week-end. Sans étiquette.',
        moodDelta: 2,
        setBranch: 'shen_donne_d',
      ),
      RomanceChoice(
        label: 'Reculer',
        reply: 'Je peux pas faire ça. Trop dur quand tu partiras.',
        moodDelta: 1,
        setBranch: 'shen_recule_d2',
      ),
    ],
  ),
  // ── J+8 — Avant départ, vocal d'adieu
  RomanceBeat(
    dayOffset: 8,
    atHour: 23,
    atMinute: 32,
    type: RomanceBeatType.voiceNote,
    voiceDurationS: 62,
    requireBranch: 'shen_donne_d',
    textVariants: [
      'vocal 62 s — voix grave et basse, fond de bagage qui se ferme — '
          'il dit qu\'il ne demandera rien quand il sera là-bas et que '
          's\'il revient elle saura',
    ],
  ),
  RomanceBeat(
    dayOffset: 9,
    atHour: 6,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_donne_d',
    textVariants: [
      'Je pars dans 2h. Pas la peine de répondre.',
      'Avion 8h. Je t\'écrirai peut-être pas tout de suite. Pas peur.',
    ],
    endsArc: 'lui_part_promesse',
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_recule_d2',
    textVariants: [
      'Je comprends. Je suis pas amer.',
      'Tu as raison. Je pars vivant grâce à toi quand même.',
    ],
    endsArc: 'shen_protege_d',
  ),
];

const departTemplate = RomanceTemplate(
  id: 'depart_imminent',
  archetypeLabel: 'Départ imminent',
  tone: RomanceTone.imminent,
  profilePool: departProfiles,
  beats: departBeats,
  minStartDay: 1,
  spawnWeight: 0.6,
  cooldownDays: 35,
  description: 'Va partir loin sous 2 semaines. Romance compressée intense. '
      'Vocal d\'adieu 62s.',
);
