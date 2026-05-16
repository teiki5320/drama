import '../../models/messages_arc.dart';

/// MATHIEU B — ami d'enfance retour Tokyo
/// 28 ans, ami d'enfance, expat Tokyo 6 ans, rentre à Paris. Ancien amour
/// non avoué. Arc 10-14 jours, retrouvailles à creuser ou rater.

const mathieuContact = MessagesArcContact(
  id: 'arc_mathieu_tokyo',
  displayName: 'Mathieu B.',
  emoji: '🌸',
  avatarTint: '#DCE2D4',
  subtitle: 'Ami d\'enfance',
  gradient: [0xFFC4A0A8, 0xFF6A4858],
);

const mathieuBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Shen. C\'est Mathieu B. Six ans c\'est long. Je rentre à Paris '
          'mardi prochain. T\'es là ?',
      'Hello. Je sais pas si tu te rappelles de moi. CM2-3e à Buttes-'
          'Chaumont. Mathieu. Je rentre à Paris.',
      'Bonjour Marchand. Mathieu. J\'ai rêvé de toi à Shinjuku, c\'est '
          'ridicule. Je rentre en France et je veux te voir.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Surprise heureuse',
        reply: 'Mathieu ! Putain six ans oui. Reviens me dire.',
        moodDelta: 2,
        setBranch: 'shen_surprise_m',
      ),
      MessagesArcChoice(
        label: 'Curieuse',
        reply: 'Mathieu. Salut. Bizarre que tu m\'écrives. Pourquoi maintenant ?',
        setBranch: 'shen_curieuse_m',
      ),
      MessagesArcChoice(
        label: 'Distante',
        reply: 'Bonjour Mathieu. Heureuse pour ton retour.',
        moodDelta: -1,
        setBranch: 'shen_distante_m',
      ),
    ],
  ),
  // ── J+1 — Il rebondit
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_surprise_m',
    textVariants: [
      'OK alors quick update : Tokyo c\'est fini, je suis vendu. J\'ai '
          'failli ouvrir une boulangerie française là-bas. Failli.',
      'Je suis chez ma sœur le temps de trouver un appart. Je veux te '
          'voir mais je veux pas que ça fasse vieux truc.',
      'Petite question chelou : tu te rappelles de la fontaine derrière '
          'le collège ? On y était les jeudis. T\'as gardé ces lieux ?',
    ],
  ),
  // ── J+1 — Curieuse, il s'ouvre plus
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_curieuse_m',
    textVariants: [
      'Parce que je me suis fiancé en juin et j\'ai annulé en septembre. '
          'Je suis pas dans un bon état. Et tu as toujours été un point '
          'fixe pour moi. J\'ai pas le droit, je le dis quand même.',
      'Parce que mes parents ont divorcé fin août. Et je sais pas à qui '
          'parler à Paris. Tu es la seule à qui je veuille écrire.',
      'Parce que je suis trop honnête à Tokyo et trop seul à Paris. '
          'Je voulais te dire bonjour avant qu\'on devienne complètement '
          'des étrangers.',
    ],
  ),
  // ── J+3 — Proposition RDV
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 19,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    forbidBranch: 'shen_distante_m',
    textVariants: [
      'Café samedi 11h, Boot Café Niel ? Tu peux refuser, je serai pas '
          'vexé.',
      'On marche autour des Buttes-Chaumont dimanche matin ? Sans plan '
          'fixe.',
      'Sushi vendredi 20h, rue Sainte-Anne ? Je connais un place que tu '
          'vas aimer.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 19,
    atMinute: 36,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_distante_m',
    choices: [
      MessagesArcChoice(
        label: 'Oui',
        reply: 'Oui. Je viens.',
        moodDelta: 2,
        setBranch: 'rdv_m',
      ),
      MessagesArcChoice(
        label: 'Plus tard',
        reply: 'Pas cette semaine. La suivante ?',
        setBranch: 'rdv_m_decale',
      ),
      MessagesArcChoice(
        label: 'Refuser',
        reply: 'Je peux pas. Pardon Mathieu.',
        endsArc: 'shen_recule_m',
      ),
    ],
  ),
  // ── J+5 — RDV
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 10,
    atMinute: 8,
    type: MessagesArcBeatType.mapLocation,
    requireBranch: 'rdv_m',
    photoLabels: [
      'Boot Café · 19 rue d\'Hauteville · 11h00',
      'Buttes-Chaumont · entrée Botzaris · 10h30',
      'Hidakaya · rue Sainte-Anne · 20h00',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 17,
    atMinute: 28,
    type: MessagesArcBeatType.text,
    requireBranch: 'rdv_m',
    textVariants: [
      'On a parlé 4h. Je crois que j\'ai pleuré.\nMerci.',
      'Tu m\'as rien demandé sur Tokyo. T\'as senti que c\'était la bonne '
          'distance. Personne fait ça.',
      'Je sais pas ce qu\'on a fait là, mais on a fait quelque chose.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 17,
    atMinute: 32,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_m',
    choices: [
      MessagesArcChoice(
        label: 'Confier',
        reply: 'Mathieu, je vis avec un homme. C\'est un contrat de 3 mois. '
            'Je voulais te le dire avant qu\'on continue.',
        moodDelta: 2,
        setBranch: 'shen_confesse_m',
      ),
      MessagesArcChoice(
        label: 'Doux',
        reply: 'Moi aussi. C\'était nécessaire.',
        moodDelta: 1,
        setBranch: 'shen_doux_post_m',
      ),
      MessagesArcChoice(
        label: 'Esquiver',
        reply: 'Sympa.',
        setBranch: 'shen_esquive_post_m',
      ),
    ],
  ),
  // ── J+7 — Réaction confession
  MessagesArcBeat(
    dayOffset: 7,
    atHour: 22,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_confesse_m',
    textVariants: [
      'Un contrat. OK. Pour ta mère ?\nJe vais pas faire semblant que je '
          'comprends mais je vais pas te juger non plus.\nTu m\'écris '
          'quand le contrat est fini ?',
      'Tu sais quoi : tu mérites d\'être aimée vraiment.\nQuand ce sera '
          'fini, écris-moi.',
      'Je vois Paris d\'une autre façon depuis ce que tu m\'as dit. Je '
          'vais essayer d\'être patient. Si je dois être patient.',
    ],
    endsArc: 'mathieu_attend',
  ),
  MessagesArcBeat(
    dayOffset: 9,
    atHour: 21,
    atMinute: 18,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_doux_post_m',
    textVariants: [
      'On se revoit ce week-end ?',
      'Je veux retravailler avec toi sur le projet de fontaine.',
      'Cinéma mardi ? Le Champo.',
    ],
    endsArc: 'mathieu_continue',
  ),
  MessagesArcBeat(
    dayOffset: 12,
    atHour: 22,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_esquive_post_m',
    textVariants: [
      'Bonne suite Shen.',
    ],
    endsArc: 'mathieu_blesse_silence',
  ),
];

const mathieuTemplate = MessagesArcTemplate(
  id: 'mathieu_tokyo',
  label: 'Mathieu B. (retour Tokyo)',
  category: MessagesArcCategory.ex,
  contact: mathieuContact,
  beats: mathieuBeats,
  minStartDay: 6,
  spawnWeight: 0.6,
  cooldownDays: 70,
  description: 'Ami d\'enfance rentre de Tokyo. Ancien amour non avoué. '
      'Confession Heng possible.',
);
