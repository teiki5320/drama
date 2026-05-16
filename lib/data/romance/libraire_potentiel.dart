import '../../models/romance.dart';

/// LIBRAIRE — VRAI POTENTIEL
/// Homme 26-29 ans, libraire indépendant, lecteur exigeant, ami de
/// Camille. Si Shen tombe sur lui, il a un vrai potentiel — peut durer
/// 30 jours+. Mais si elle ment, il sent et se retire en douceur.

const libraireProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'bastien_m',
    name: 'Bastien',
    age: 26,
    profession: 'Libraire indépendant',
    quartier: 'Goutte d\'Or',
    detail: 'ami de Camille Roux',
    bio: 'Libraire. Goutte d\'Or. Je ne suis pas drôle mais je vous écoute bien.',
    gradient: [0xFF5C4630, 0xFF2A1E12],
    emoji: '📕',
    photoEmojis: ['📕', '☕', '📰', '🌧️'],
  ),
  RomanceProfile(
    id: 'pierre_d',
    name: 'Pierre',
    age: 28,
    profession: 'Libraire spécialisé poésie',
    quartier: '5e',
    detail: 'écrit la nuit',
    bio: 'Poésie. Édition. Café à 17h, vin à 19h. La rigueur.',
    gradient: [0xFF4A4060, 0xFF22192E],
    emoji: '🖋️',
    photoEmojis: ['🖋️', '📖', '🍷', '☕'],
  ),
  RomanceProfile(
    id: 'alex_v',
    name: 'Alex',
    age: 27,
    profession: 'Libraire jeunesse',
    quartier: '11e',
    detail: 'écrit pour enfants',
    bio: 'Je passe ma journée à raconter des histoires à des humains de 4 ans.',
    gradient: [0xFF6C5060, 0xFF302430],
    emoji: '🐦',
    photoEmojis: ['🐦', '📚', '☕', '🌳'],
  ),
];

const libraireBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Camille Roux m\'a montré ta photo dans le magasin. Petite blague entre amis. Tu me détestes ?',
      'Bonsoir. Camille Roux dit que tu lis bien. C\'est un bon argument.',
      'Hello. Camille m\'a parlé de toi sans le savoir. Du coup je swipe.',
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
        label: 'Camille !',
        reply: 'Camille fait l\'entremetteuse. Bien sûr.',
        moodDelta: 1,
        setBranch: 'shen_camille_l',
      ),
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Comment tu connais Camille ?',
        setBranch: 'shen_curieuse_l',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_l',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.text,
    textVariants: [
      'On bossait ensemble à la librairie Vendredi. Elle est partie en com, moi pas.',
      'On a une relation amitié qui a survécu à 4 ans d\'ennuis communs.',
      'On boit des cafés depuis 6 ans. Pour toi ça veut dire quoi ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu lis quoi en ce moment ? Et ne mens pas. Camille m\'a dit que tu fais semblant parfois.',
      'Question piège : tu lis encore par plaisir ou seulement par fatigue ?',
      'Je viens de finir « La Recherche perdue » de Lispector. T\'as déjà entendu parler ?',
    ],
  ),
  // ── J+2 — Proposition naturelle
  RomanceBeat(
    dayOffset: 2,
    atHour: 14,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Je suis seul à la librairie samedi 10h-13h. Viens. Sans pression.',
      'Ten Belles, samedi 11h. Camille peut venir si tu veux qu\'elle te chaperonne.',
      'Un verre chez moi vendredi 21h ? J\'invite Camille pour la première fois si tu veux.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 14,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Avec Camille',
        reply: 'Avec Camille. Plus simple pour moi.',
        moodDelta: 1,
        setBranch: 'rdv_avec_camille',
      ),
      RomanceChoice(
        label: 'Sans Camille',
        reply: 'Juste toi et moi. Camille en saura assez sans qu\'on l\'invite.',
        moodDelta: 2,
        setBranch: 'rdv_solo_l',
      ),
      RomanceChoice(
        label: 'Reporter',
        reply: 'Plus tard. Pas dispo cette semaine.',
        setBranch: 'rdv_decale_l',
      ),
    ],
  ),
  // ── J+4 — Le RDV
  RomanceBeat(
    dayOffset: 4,
    atHour: 10,
    atMinute: 22,
    type: RomanceBeatType.mapLocation,
    forbidBranch: 'rdv_decale_l',
    photoLabels: [
      'Librairie Vendredi · 67 rue Léon · 10h00',
      'Ten Belles · 10 rue de la Grange aux Belles · 11h00',
      'Chez Bastien · 18e · 21h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.text,
    forbidBranch: 'rdv_decale_l',
    textVariants: [
      'C\'était bien. Je vais pas faire le malin.\nCamille avait raison. Tu lis vraiment bien.',
      'Tu m\'as dit pas grand-chose mais ce que tu as dit était dense.',
      'Tu m\'as caché un truc cet après-midi. J\'ai vu. Je dis rien.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'rdv_decale_l',
    choices: [
      RomanceChoice(
        label: 'Confier',
        reply: 'Je vis avec quelqu\'un. Camille le sait. C\'est compliqué.',
        moodDelta: 2,
        setBranch: 'shen_confesse_l',
      ),
      RomanceChoice(
        label: 'Continuer doux',
        reply: 'On se revoit ?',
        moodDelta: 1,
        setBranch: 'shen_continue_l',
      ),
      RomanceChoice(
        label: 'Mentir',
        reply: 'Je vois pas de quoi tu parles.',
        moodDelta: -2,
        setBranch: 'shen_ment_l',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 11,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse_l',
    textVariants: [
      'OK. Merci d\'avoir dit. Camille m\'avait fait deviner sans dire.\n'
          'On peut être amis. Vraiment. Si tu veux.',
      'C\'est dense ce que tu portes. Je prendrai pas la place de personne.\n'
          'On peut juste continuer à lire ensemble. Si tu veux.',
    ],
    endsArc: 'l_amitie_durable',
  ),
  RomanceBeat(
    dayOffset: 7,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_continue_l',
    textVariants: [
      'Viens samedi 16h, je ferme la librairie tôt.',
      'J\'ai pensé à toi en lisant un truc. Je te le mets de côté ?',
    ],
    endsArc: 'l_continue_quotidien',
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 19,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ment_l',
    textVariants: [
      'OK. Je dirai rien à Camille.\nMais je vais me reculer. Bonne suite.',
      'Tu mens mal. Camille m\'avait prévenu. Bonne suite.',
    ],
    endsArc: 'l_recule_ment',
  ),
];

const libraireTemplate = RomanceTemplate(
  id: 'libraire_potentiel',
  archetypeLabel: 'Libraire — vrai potentiel',
  tone: RomanceTone.sincere,
  profilePool: libraireProfiles,
  beats: libraireBeats,
  minStartDay: 5,
  spawnWeight: 0.7,
  cooldownDays: 50,
  description: 'Libraire ami de Camille Roux. Vrai potentiel romance ou amitié. '
      'Si Shen ment, il sent et se retire.',
);
