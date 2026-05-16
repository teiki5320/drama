import '../../models/romance.dart';

/// TENDRE IMMATURE
/// 23-26 ans, étudiant ou jeune diplômé. Doux mais pas prêt — dit
/// « je sais pas trop ce que je veux » à J+5, panique à la moindre
/// pression. Arc 10 jours, frustration mélancolique.

const tendreProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'marin_a',
    name: 'Marin',
    age: 25,
    profession: 'Master photo ENS Louis-Lumière',
    quartier: '20e',
    detail: 'vit chez ses parents',
    bio: 'Photo. Pâtes au beurre. Je ne sais pas faire grand-chose d\'autre.',
    gradient: [0xFFA88B6E, 0xFF4A3B2A],
    emoji: '🌼',
    photoEmojis: ['🌼', '📷', '🍝', '🎒'],
  ),
  RomanceProfile(
    id: 'gabriel_p',
    name: 'Gabriel',
    age: 23,
    profession: 'Étudiant Sciences Po',
    quartier: '7e',
    detail: 'fume trop',
    bio: 'Sciences Po. Je sais pas trop. C\'est honnête.',
    gradient: [0xFFB89A82, 0xFF5A4839],
    emoji: '🚬',
    photoEmojis: ['🚬', '📚', '🍷', '🌧️'],
  ),
  RomanceProfile(
    id: 'theo_l',
    name: 'Théo',
    age: 26,
    profession: 'Stagiaire édition Gallimard',
    quartier: '6e',
    detail: 'écharpe tout le temps',
    bio: 'Lit. Écrit un peu. Mange chez ses parents le dimanche.',
    gradient: [0xFF4A3D5C, 0xFF22192E],
    emoji: '🧣',
    photoEmojis: ['🧣', '📖', '☕', '🍂'],
  ),
];

const tendreBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Je sais pas trop quoi dire. Mais tu as l\'air bien.',
      'Hello. Tes photos sont douces. Ça me plaît.',
      'Bonsoir. Tu fais quoi ce soir ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Douce',
        reply: 'Salut. Toi aussi tu as l\'air bien.',
        moodDelta: 1,
        setBranch: 'shen_douce_t',
      ),
      RomanceChoice(
        label: 'Joueuse',
        reply: 'Bonsoir. Tu sais pas trop quoi dire mais tu as essayé. C\'est bien.',
        moodDelta: 1,
        setBranch: 'shen_joueuse_t',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_t',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 17,
    atMinute: 22,
    type: RomanceBeatType.text,
    textVariants: [
      'J\'ai pensé à toi en mangeant mes pâtes. C\'est ridicule mais bon.',
      'Mes parents demandent qui me fait sourire au téléphone.',
      'Je dois rendre un mémoire dans 3 semaines. Et j\'ai 4 lignes.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'On se voit demain ? Café Belleville ? Je connais pas mais paraît bien.',
      'Vendredi soir on boit un verre ? J\'ai jamais proposé ça à personne.',
      'Tu veux qu\'on se voie ? Je peux quoi proposer ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 21,
    atMinute: 12,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'OK. Tu choisis.',
        moodDelta: 1,
        setBranch: 'rdv_t',
      ),
      RomanceChoice(
        label: 'Diriger',
        reply: 'Café Ten Belles, samedi 16h. Je serai là.',
        moodDelta: 1,
        setBranch: 'rdv_t_shen_drive',
      ),
      RomanceChoice(
        label: 'Pas envie',
        reply: 'Je sens pas trop. Désolée.',
        endsArc: 'shen_decline_t',
      ),
    ],
  ),
  // ── J+5 — Le RDV passe doux mais il panique
  RomanceBeat(
    dayOffset: 5,
    atHour: 10,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    forbidBranch: 'shen_decline_t',
    photoLabels: [
      'Ten Belles · 10 rue de la Grange aux Belles · 16h00',
      'Café de la Mairie · place Saint-Sulpice · 18h00',
      'Le Petit Vendôme · 8 rue des Capucines · 17h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_decline_t',
    textVariants: [
      'Merci. C\'était bizarre et bien. Tu m\'as fait peur.',
      'J\'ai pas l\'habitude de ce genre de moment.',
      'Je rentre. Je dois réfléchir. Pardon si je dis ça.',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 19,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_decline_t',
    choices: [
      RomanceChoice(
        label: 'Doux retour',
        reply: 'Pareil. Pas obligée d\'aller vite.',
        moodDelta: 1,
        setBranch: 'shen_doux_t',
      ),
      RomanceChoice(
        label: 'Question',
        reply: 'Peur de quoi ?',
        setBranch: 'shen_question_t',
      ),
      RomanceChoice(
        label: 'Pression',
        reply: 'Tu veux quoi exactement ?',
        moodDelta: -1,
        setBranch: 'shen_pression_t',
      ),
    ],
  ),
  // ── J+7 — Panique selon shen_pression_t
  RomanceBeat(
    dayOffset: 7,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_pression_t',
    textVariants: [
      'Je sais pas trop ce que je veux. Je crois.',
      'C\'est pas toi. C\'est moi. (je sais c\'est nul comme phrase)',
      'Désolé. Je peux pas être ce que tu attends. Pardon.',
    ],
    endsArc: 'lui_recule_panique',
  ),
  // ── J+7 — Question : il s'ouvre un peu
  RomanceBeat(
    dayOffset: 7,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_question_t',
    textVariants: [
      'Peur de pas être assez. Peur que ça compte vraiment.',
      'Peur de te décevoir. C\'est bête.',
      'Peur de devenir comme mon père. (sorry)',
    ],
  ),
  RomanceBeat(
    dayOffset: 9,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_doux_t',
    textVariants: [
      'Je crois que je suis pas prêt. Pardon.',
      'Tu m\'aurais mérité quelqu\'un de mieux.',
      'On peut rester en contact ? Sans étiquette ?',
    ],
    endsArc: 'lui_fade_immature',
  ),
];

const tendreTemplate = RomanceTemplate(
  id: 'tendre_immature',
  archetypeLabel: 'Tendre immature',
  tone: RomanceTone.immature,
  profilePool: tendreProfiles,
  beats: tendreBeats,
  minStartDay: 1,
  spawnWeight: 1.0,
  cooldownDays: 22,
  description: '23-26 ans, doux mais pas prêt. Panique J+7 si pression. '
      'Frustration mélancolique 10 j.',
);
