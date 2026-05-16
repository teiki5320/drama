import '../../models/romance.dart';

/// MANIPULATRICE SOFT
/// Femme 32-38 ans, prof yoga / coach. Douce, voix sucrée. Pose de
/// fausses questions thérapeutiques, fait sentir à Shen qu'elle est
/// "abîmée mais récupérable". Arc 7 jours, malaise insidieux.

const manipProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'sophie_k',
    name: 'Sophie',
    age: 35,
    profession: 'Prof yoga · coach intuitive',
    quartier: '16e',
    detail: 'divorcée 2 ans',
    bio: 'Yoga. Coach. Mère célibataire forte. Je sens les âmes en peine.',
    gradient: [0xFFC0A088, 0xFF55473A],
    emoji: '🪷',
    photoEmojis: ['🪷', '🌿', '🧘‍♀️', '🌅'],
  ),
  RomanceProfile(
    id: 'isabelle_v',
    name: 'Isabelle',
    age: 38,
    profession: 'Thérapeute bien-être',
    quartier: '7e',
    detail: 'reiki et lithothérapie',
    bio: 'Healer. Présence. Je vois les personnes que personne ne voit.',
    gradient: [0xFFB0A8C0, 0xFF50485A],
    emoji: '🔮',
    photoEmojis: ['🔮', '🕯️', '🌿', '🪨'],
  ),
  RomanceProfile(
    id: 'helena_p',
    name: 'Helena',
    age: 33,
    profession: 'Coach de vie',
    quartier: '6e',
    detail: 'a publié un livre',
    bio: 'Auteur. Coach. Maman de Solal. Cherche femme avec un univers.',
    gradient: [0xFFA08CB0, 0xFF483F50],
    emoji: '✨',
    photoEmojis: ['✨', '📖', '🧘‍♀️', '🌹'],
  ),
];

const manipBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Je sens beaucoup dans ton regard. Une fatigue ancienne. '
          'Je me trompe ?',
      'Salut. Tu as un visage qui porte des choses. Je sens. '
          'C\'est mon métier.',
      'Hello. Tu cherches quelqu\'un qui te voit vraiment, c\'est ça ?',
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
        label: 'Hum...',
        reply: 'Bonsoir. C\'est rapide comme analyse.',
        moodDelta: 1,
        setBranch: 'shen_mef_man2',
      ),
      RomanceChoice(
        label: 'Touchée',
        reply: 'Oui un peu. Comment tu sais ?',
        moodDelta: -1,
        setBranch: 'shen_touche_man2',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_man2',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_touche_man2',
    textVariants: [
      'Je vois les âmes blessées. Je suis comme ça depuis petite.',
      'Mon ex me disait : « Tu lis les gens comme un livre. » Pas fière, juste consciente.',
      'C\'est un don. Et une responsabilité. Tu sais.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_touche_man2',
    textVariants: [
      'J\'ai dormi en pensant à toi. Doucement. Pas inquiète.',
      'Tu portes une lourdeur. Tu peux me la confier sans peur.',
      'Question : tes parents étaient comment quand tu étais enfant ?',
    ],
  ),
  // ── J+2 — Elle pose ses griffes
  RomanceBeat(
    dayOffset: 2,
    atHour: 20,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_touche_man2',
    textVariants: [
      'Je sens que tu es très seule. Ne te juge pas. Tu as juste pas '
          'rencontré la bonne personne pour t\'aider à te déposer.',
      'Tu as besoin qu\'on te tienne. Tu mérites ça. Je peux le faire si tu veux.',
      'Je pense que tu es très abîmée mais récupérable. C\'est pas une insulte. '
          'C\'est un constat.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 20,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_touche_man2',
    choices: [
      RomanceChoice(
        label: 'Réveil',
        reply: 'Tu sais quoi. Tu me parles comme à une cliente.',
        moodDelta: 2,
        setBranch: 'shen_reveil',
      ),
      RomanceChoice(
        label: 'Continue',
        reply: 'Pardon. Tu as raison. J\'ai besoin de ça.',
        moodDelta: -2,
        setBranch: 'shen_avalee',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_man2',
      ),
    ],
  ),
  // ── J+2 — Si shen_reveil, elle se vexe
  RomanceBeat(
    dayOffset: 2,
    atHour: 20,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_reveil',
    textVariants: [
      'Tu te trompes. Mais OK, je respecte ta défense.',
      'Bon courage. Tu en auras besoin.',
      'Quand tu seras prête à recevoir, tu sauras où me trouver.',
    ],
    endsArc: 'shen_arret_propre_man2',
  ),
  // ── J+2 — Méfiante depuis le début, elle teste 2 fois
  RomanceBeat(
    dayOffset: 1,
    atHour: 19,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_mef_man2',
    textVariants: [
      'Je suis pas analyste, juste sensible. Promis.',
      'Tu te défends. C\'est OK. Ça veut dire que j\'ai touché juste.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_mef_man2',
    textVariants: [
      'Je te laisse réfléchir. Je suis là quand tu veux.',
    ],
    endsArc: 'man2_lache',
  ),
  // ── J+5 — Avalée : retour de bâton
  RomanceBeat(
    dayOffset: 5,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_avalee',
    textVariants: [
      'Mon premier RDV individuel est à 80 €/séance. Tu en aurais besoin de 6 minimum.',
      'Je peux te recommander une retraite à Bali en mai. 1200 €. Je t\'accompagne.',
      'Mon livre est sorti. 18 €. Lis-le et on en reparle.',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_avalee',
    choices: [
      RomanceChoice(
        label: 'Réveil tardif',
        reply: 'Tu as réussi ton coup. Bravo.',
        moodDelta: 1,
        endsArc: 'shen_reveil_tardif',
      ),
      RomanceChoice(
        label: 'Block',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_late_man2',
      ),
    ],
  ),
];

const manipulatriceTemplate = RomanceTemplate(
  id: 'manipulatrice_soft',
  archetypeLabel: 'Manipulatrice soft',
  tone: RomanceTone.manipulative,
  profilePool: manipProfiles,
  beats: manipBeats,
  minStartDay: 5,
  spawnWeight: 0.5,
  cooldownDays: 40,
  description: 'Femme 32-38 coach/healer. Pose de fausses questions thérapeutiques, '
      'pousse à payer ses séances. Malaise insidieux.',
);
