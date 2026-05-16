import '../../models/romance.dart';

/// ESCORT REVEAL
/// Femme 24-28 ans, mystérieuse, "consultante". Reveal J+3 qu'elle est
/// escort qui chasse les clientes par jeu — pas pour de l'argent.
/// Arc 3 jours choc.

const escortProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'elise_v',
    name: 'Élise',
    age: 26,
    profession: 'Consultante',
    quartier: '8e',
    detail: 'horaires opaques',
    bio: 'Consultante indépendante. Ne demande pas. Devine.',
    gradient: [0xFFA88098, 0xFF50384A],
    emoji: '🍸',
    photoEmojis: ['🍸', '🌹', '🏨', '💋'],
  ),
  RomanceProfile(
    id: 'margaux_a',
    name: 'Margaux',
    age: 24,
    profession: 'Hospitality',
    quartier: '7e',
    detail: 'Crillon · Bristol',
    bio: 'Hôtellerie de luxe. Service de nuit.',
    gradient: [0xFFC0A088, 0xFF584A3A],
    emoji: '🥂',
    photoEmojis: ['🥂', '🌹', '🏨', '💄'],
  ),
  RomanceProfile(
    id: 'charlotte_b',
    name: 'Charlotte',
    age: 28,
    profession: 'Coach lifestyle',
    quartier: '16e',
    detail: 'clients pré-tirés',
    bio: 'J\'accompagne des gens à devenir eux-mêmes. Avec talent.',
    gradient: [0xFFB08CB0, 0xFF504048],
    emoji: '💎',
    photoEmojis: ['💎', '🌹', '🍸', '🎭'],
  ),
];

const escortBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Vous êtes différente.',
      'Salut. Ton bio est intriguant.',
      'Hello. T\'as un visage qui dit beaucoup et rien à la fois.',
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
        reply: 'Bonsoir. Vous faites quoi ?',
        setBranch: 'shen_curieuse_e',
      ),
      RomanceChoice(
        label: 'Méfiante',
        reply: 'Tu vends quelque chose ?',
        moodDelta: 1,
        setBranch: 'shen_mef_e',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_e',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu as l\'air seule. Pas dans le sens triste. Dans le sens libre.',
      'Tu sais ce que c\'est, le luxe ? C\'est avoir 10 min pour soi entre deux RDV.',
      'Tu m\'amuses. Tu sais ?',
    ],
  ),
  // ── J+2 — Propose un dîner intriguant
  RomanceBeat(
    dayOffset: 2,
    atHour: 20,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Demain 22h, bar du Park Hyatt, Vendôme ?',
      'Mardi 23h, Hemingway au Ritz. Je t\'attendrai au comptoir.',
      'Tu viens dîner ce soir au Bristol ? Je connais le chef.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 20,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'OK intriguée',
        reply: 'OK. Pourquoi pas.',
        setBranch: 'rdv_e',
      ),
      RomanceChoice(
        label: 'Trop chic',
        reply: 'Pas mon budget.',
        setBranch: 'shen_budget_e',
      ),
    ],
  ),
  // ── J+3 — REVEAL au bar
  RomanceBeat(
    dayOffset: 3,
    atHour: 23,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_e',
    textVariants: [
      'Avant que tu commandes. Je t\'invite. Et je t\'explique.\n'
          'Je suis escort. Hommes clients. Je swipe les femmes pour le jeu. '
          'Pas pour l\'argent.',
      'Je dois te dire un truc. Je suis dans le métier. Hôtels, clients '
          'aisés. Les femmes ici c\'est mon vrai loisir.',
      'Tu me plais. Avant qu\'on perde du temps : je vis avec un client '
          'à temps plein. Ceci est mes vacances.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 23,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_e',
    choices: [
      RomanceChoice(
        label: 'Partir',
        reply: 'Je m\'en vais. Merci pour l\'honnêteté.',
        moodDelta: 1,
        endsArc: 'shen_part_e',
      ),
      RomanceChoice(
        label: 'Questionner',
        reply: 'Tu fais ça parce que tu en as besoin ou parce que tu aimes ?',
        moodDelta: 1,
        setBranch: 'shen_question_e',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        endsArc: 'shen_block_e',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 23,
    atMinute: 42,
    type: RomanceBeatType.text,
    requireBranch: 'shen_question_e',
    textVariants: [
      'Les deux. C\'est rare qu\'on me pose la vraie question.',
      'J\'aime. C\'est moche à dire. Mais je l\'ai choisi.',
      'C\'est pour ne plus jamais avoir besoin.',
    ],
    endsArc: 'e_conversation_lucide',
  ),
];

const escortTemplate = RomanceTemplate(
  id: 'escort_reveal',
  archetypeLabel: 'Escort reveal',
  tone: RomanceTone.escort,
  profilePool: escortProfiles,
  beats: escortBeats,
  minStartDay: 3,
  spawnWeight: 0.3,
  cooldownDays: 45,
  description: 'Femme escort qui chasse les clientes par jeu. Reveal J+3 au bar.',
);
