/// Catalogue des templates d'archétypes de romance Tinder.
///
/// Chaque template = squelette de beats + pool de profils + variantes
/// texte/choix. Le scheduler pioche un profil et un set de variantes au
/// spawn. Deux runs du même archétype ne sont jamais identiques.
///
/// PR1 — premier archétype profond : Slow burn sincère.
library;

import '../models/romance.dart';

// ─────────────────────────────────────────────────────────────────────
// ARCHÉTYPE 1 — SLOW BURN SINCÈRE
//
// Profil : architecte 27-31 ans, lecteur, calme, ne presse pas.
// Arc : 9-12 jours, opener posé → warmup littéraire → RDV café/balade
// → IRL → branchement (Shen confesse / esquive / ment) → fin honnête
// ou ghost selon le chemin.
// ─────────────────────────────────────────────────────────────────────

const _slowBurnProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'antoine_m',
    name: 'Antoine',
    age: 27,
    profession: 'Architecte',
    quartier: '10e',
    detail: 'sketches à l\'encre',
    bio: 'Architecte. Boit son café noir. Lit le soir.',
    gradient: [0xFF4A5568, 0xFF1A202C],
    emoji: '✏️',
    photoEmojis: ['✏️', '☕', '📐', '🏛️'],
  ),
  RomanceProfile(
    id: 'paul_l',
    name: 'Paul',
    age: 29,
    profession: 'Archi ENSA Marne',
    quartier: '11e',
    detail: 'aime Tarkovski',
    bio: '« Le temps scellé » m\'a abîmé. Je m\'en remets en dessinant.',
    gradient: [0xFF2D3748, 0xFF1A202C],
    emoji: '🎬',
    photoEmojis: ['🎬', '🏗️', '📚', '🌧️'],
  ),
  RomanceProfile(
    id: 'marc_a',
    name: 'Marc',
    age: 31,
    profession: 'Archi freelance',
    quartier: '18e',
    detail: 'a un chat',
    bio: 'Freelance. Goutte d\'Or. Un chat noir nommé Tabac.',
    gradient: [0xFF553C2A, 0xFF2D1F12],
    emoji: '🐈‍⬛',
    photoEmojis: ['🐈‍⬛', '📐', '☕', '🍷'],
  ),
  RomanceProfile(
    id: 'theo_v',
    name: 'Théo',
    age: 28,
    profession: 'Archi paysagiste',
    quartier: '12e',
    detail: 'vélo cargo',
    bio: 'Je plante des arbres pour des gens qui ne les verront pas pousser.',
    gradient: [0xFF2F5233, 0xFF1B3320],
    emoji: '🌳',
    photoEmojis: ['🌳', '🚲', '🌱', '🪴'],
  ),
  RomanceProfile(
    id: 'julien_d',
    name: 'Julien',
    age: 30,
    profession: 'Architecte d\'intérieur',
    quartier: '9e',
    detail: 'parle bas',
    bio: 'L\'espace dit ce qu\'on n\'arrive pas à dire.',
    gradient: [0xFF7B5E57, 0xFF3E2F2A],
    emoji: '🪑',
    photoEmojis: ['🪑', '🕯️', '🖼️', '📖'],
  ),
];

const _slowBurnBeats = <RomanceBeat>[
  // ── J+0 — Opener immédiat après match ───────────────────────────
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,                       // posé à l'heure exacte du match
    atMinute: 3,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Ton bio dit « Architecte ». Vrai ou clin d\'œil ?',
      'Hey. Tu bois quoi le matin ?',
      'Bonjour. T\'as quoi sur ta table de chevet ?',
      'Salut. Tu jures bien quand tu travailles ?',
      'Hey. Un projet en ce moment ?',
      'T\'as choisi ta photo principale exprès, ou tu jures que non ?',
      'Salut. Je suis pas très texteur, donc voilà.',
    ],
  ),

  // ── J+0 — Choix Shen : réponse au premier message ──────────────
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 4,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Posée',
        reply: 'Salut. Vrai. Et toi ?',
        moodDelta: 0,
        setBranch: 'shen_posee',
      ),
      RomanceChoice(
        label: 'Drôle',
        reply: 'Clin d\'œil. Je dessine pour de vrai mais ça sonne moins bien.',
        moodDelta: 1,
        setBranch: 'shen_drole',
      ),
      RomanceChoice(
        label: 'Sèche',
        reply: 'Vrai. Pas envie d\'expliquer.',
        moodDelta: -1,
        setBranch: 'shen_seche',
      ),
      RomanceChoice(
        label: 'Ignorer',
        reply: '',
        moodDelta: 0,
        endsArc: 'shen_ghost_early',
      ),
    ],
  ),

  // ── J+1 — Il enchaîne avec UN type parmi 4 ─────────────────────
  // Variante A : photo carnet d'esquisses
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 12,
    type: RomanceBeatType.photoShared,
    photoLabels: [
      'carnet d\'esquisses ouvert sur une page de café',
      'fenêtre du studio à 8h, lumière froide',
      'sa main sur une tasse, sans tête dans le cadre',
      'plan d\'un escalier en colimaçon',
    ],
    forbidBranch: 'shen_seche',
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 13,
    type: RomanceBeatType.text,
    textVariants: [
      'Mon dimanche commence comme ça.',
      'C\'est la quatrième fois que je redessine cet escalier.',
      'J\'ai pris la photo en pensant à ce que tu m\'as répondu hier.',
      'Voilà. Sans contexte.',
    ],
    forbidBranch: 'shen_seche',
  ),

  // ── J+1 — Choix Shen sur la photo ──────────────────────────────
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 20,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_seche',
    choices: [
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Pourquoi quatre fois ?',
        moodDelta: 1,
        setBranch: 'shen_curieuse',
      ),
      RomanceChoice(
        label: 'Renvoyer',
        reply: 'Voilà le mien. *photo café froid Belleville*',
        moodDelta: 1,
        setBranch: 'shen_partage',
      ),
      RomanceChoice(
        label: 'Esquiver',
        reply: 'Joli.',
        moodDelta: 0,
        setBranch: 'shen_esquive',
      ),
    ],
  ),

  // ── J+1 — Si Shen curieuse, il explique. Si Shen partage, il
  //          renchérit. Si Shen esquive, beat plus court.
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 24,
    type: RomanceBeatType.text,
    requireBranch: 'shen_curieuse',
    textVariants: [
      'Parce que la troisième marche refuse d\'être à la bonne hauteur.\n'
          'C\'est pas un détail. C\'est tout le reste.',
      'Parce que les escaliers tiennent les maisons. Si je rate ça, '
          'j\'ai rien.',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 24,
    type: RomanceBeatType.text,
    requireBranch: 'shen_partage',
    textVariants: [
      'Joli. Tu vis dans la lumière froide aussi.',
      'C\'est où ça ? Belleville haut ou bas ?',
    ],
  ),

  // ── J+2-3 — Question de plus en plus directe ───────────────────
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'T\'es comment quand t\'es fatiguée ?',
      'C\'était quoi ton dernier livre lu en entier ?',
      'Question bête : t\'aimes les escaliers ?',
      'Si tu pouvais effacer une pièce d\'une maison, ce serait laquelle ?',
    ],
  ),

  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 9,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Honnête',
        reply: 'Pas terrible en ce moment. Truc familial.',
        moodDelta: 0,
        setBranch: 'shen_confie',
      ),
      RomanceChoice(
        label: 'Détourner',
        reply: 'Je te raconterai si tu réponds toi-même d\'abord.',
        moodDelta: 1,
        setBranch: 'shen_renvoie',
      ),
      RomanceChoice(
        label: 'Mentir',
        reply: 'Ça va. Beaucoup de boulot.',
        moodDelta: -1,
        setBranch: 'shen_ment',
      ),
    ],
  ),

  // ── J+3 — Vocal s'il s'est confiée, ou texte sec sinon ─────────
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.voiceNote,
    voiceDurationS: 38,
    textVariants: [
      'vocal 38 s : voix calme — il dit qu\'il n\'attend pas de toi que tu '
          'sois bien, juste que tu sois là',
    ],
    requireBranch: 'shen_confie',
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ment',
    textVariants: [
      'Ok. Tu me dis quand t\'as une vraie soirée libre ?',
      'Beaucoup de boulot je comprends. On voit cette semaine ?',
    ],
  ),

  // ── J+4 — Proposition RDV — type pioché ────────────────────────
  RomanceBeat(
    dayOffset: 4,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      // Café
      'Café samedi 10h, Boot Café rue Niel ? J\'y suis souvent.',
      'Y a un café qui ouvre à 8h dans le 11e qui sert le meilleur '
          'cortado de Paris. Dimanche matin ?',
      // Verre
      'Verre jeudi 19h, Le Mary Celeste rue Commines ?',
      'Un bar à vin pas prétentieux dans le 10e, ça te dit ? Vendredi 18h30.',
      // Balade
      'Buttes-Chaumont dimanche matin si tu veux. Je marche lentement.',
      'Promenade plantée dimanche après-midi ? On voit les toits.',
      // Cinéma
      'Le Champo passe « L\'Avventura » mardi 20h30. Ça te tente ?',
      // Appel
      'On s\'appelle mardi soir 22h ? Texto c\'est trop lent.',
    ],
  ),

  RomanceBeat(
    dayOffset: 4,
    atHour: 14,
    atMinute: 10,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'Oui. Je serai là.',
        moodDelta: 1,
        setBranch: 'rdv_accept',
      ),
      RomanceChoice(
        label: 'Décaler',
        reply: 'Pas ce week-end. La semaine d\'après ?',
        moodDelta: 0,
        setBranch: 'rdv_decaler',
      ),
      RomanceChoice(
        label: 'Décliner poli',
        reply: 'C\'est compliqué en ce moment. Une autre fois ?',
        moodDelta: -1,
        setBranch: 'rdv_decline',
      ),
      RomanceChoice(
        label: 'Ghost',
        reply: '',
        moodDelta: -1,
        endsArc: 'shen_ghost_pre_rdv',
      ),
    ],
  ),

  // ── J+5 — Pré-RDV — situation pioché si rdv_accept ─────────────
  RomanceBeat(
    dayOffset: 5,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_accept',
    textVariants: [
      'J\'ai hâte. Bonne nuit.',
      'Demain est demain. Dors bien.',
      'Je sais pas pourquoi je suis nerveux. Pardon.',
    ],
  ),

  // ── J+6 — Le jour du RDV — il envoie la carte / la photo lieu ──
  RomanceBeat(
    dayOffset: 6,
    atHour: 9,
    atMinute: 14,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_accept',
    photoLabels: [
      'Boot Café · 19 rue d\'Hauteville · 10h00',
      'Mary Celeste · 1 rue Commines · 19h00',
      'Buttes-Chaumont · entrée Botzaris · 10h30',
      'Le Champo · 51 rue des Écoles · 20h30',
      'Promenade plantée · accès Bastille · 14h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 9,
    atMinute: 16,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_accept',
    textVariants: [
      'À tout à l\'heure.',
      'Je serai en avance. Pas grave, je lis.',
      'Pull bleu. Pour que tu me repères.',
    ],
  ),

  // ── J+6 — Pendant le RDV : photo subtile partagée ──────────────
  RomanceBeat(
    dayOffset: 6,
    atHour: 11,
    atMinute: 42,
    type: RomanceBeatType.photoShared,
    requireBranch: 'rdv_accept',
    photoLabels: [
      'sa main sur la tasse, ta main hors champ',
      'le livre qu\'il a posé entre vous',
      'la rue par la fenêtre, ton sac est dans le coin',
    ],
  ),

  // ── J+6 — Post-RDV — variantes selon mood Shen pendant ─────────
  RomanceBeat(
    dayOffset: 6,
    atHour: 19,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_accept',
    textVariants: [
      'Merci. J\'ai pas eu envie de regarder mon téléphone une seule fois.',
      'Pardon si j\'étais trop bavard.',
      'Je t\'écris parce que j\'ai pas voulu le faire devant toi.',
      'C\'était court, c\'était bien. On recommence ?',
    ],
  ),

  RomanceBeat(
    dayOffset: 6,
    atHour: 19,
    atMinute: 11,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_accept',
    choices: [
      RomanceChoice(
        label: 'Confier',
        reply: 'Je vis avec quelqu\'un. C\'est compliqué. Pardon.',
        moodDelta: 2,
        setBranch: 'shen_confesse',
      ),
      RomanceChoice(
        label: 'Renvoyer',
        reply: 'Pareil. Je voulais le dire avant.',
        moodDelta: 1,
        setBranch: 'shen_partage_rdv',
      ),
      RomanceChoice(
        label: 'Esquiver',
        reply: 'C\'était bien oui.',
        moodDelta: 0,
        setBranch: 'shen_evite',
      ),
    ],
  ),

  // ── J+7 — Réaction selon confession ────────────────────────────
  RomanceBeat(
    dayOffset: 7,
    atHour: 11,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse',
    textVariants: [
      'Ok. Merci d\'être honnête.\nBonne suite, vraiment.',
      'Je préfère le savoir maintenant. Prends soin de toi.',
      'C\'est dur à entendre. Mais merci. Je vais m\'éloigner.',
    ],
    endsArc: 'rupture_honnete',
  ),

  RomanceBeat(
    dayOffset: 7,
    atHour: 21,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_partage_rdv',
    textVariants: [
      'Alors on fait quoi.',
      'D\'accord. C\'est mieux qu\'on s\'arrête là, non ?',
    ],
    endsArc: 'rupture_mutuelle',
  ),

  // ── J+8-12 — Si Shen évite, il insiste un peu puis fade ────────
  RomanceBeat(
    dayOffset: 8,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_evite',
    textVariants: [
      'On se revoit ?',
      'Tu m\'as paru loin par moments. Je me trompe ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 8,
    atHour: 22,
    atMinute: 16,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_evite',
    choices: [
      RomanceChoice(
        label: 'Honnête tardive',
        reply: 'Tu te trompes pas. Je ne peux pas. Pardon.',
        moodDelta: 1,
        endsArc: 'rupture_tardive',
      ),
      RomanceChoice(
        label: 'Continuer mentir',
        reply: 'Mais non. Juste fatiguée.',
        moodDelta: -2,
        setBranch: 'shen_ment_encore',
      ),
      RomanceChoice(
        label: 'Ghost',
        reply: '',
        moodDelta: -1,
        endsArc: 'shen_ghost_post_rdv',
      ),
    ],
  ),

  RomanceBeat(
    dayOffset: 10,
    atHour: 14,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ment_encore',
    textVariants: [
      'On se revoit ce week-end ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 12,
    atHour: 22,
    atMinute: 30,
    type: RomanceBeatType.typingThenNothing,
    requireBranch: 'shen_ment_encore',
  ),
  RomanceBeat(
    dayOffset: 13,
    atHour: 23,
    atMinute: 8,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_ment_encore',
    endsArc: 'il_unmatch_silencieux',
  ),

  // ── Si Shen a ghost juste après match — il insiste 2× puis stop
  RomanceBeat(
    dayOffset: 1,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_seche',
    textVariants: [
      'Ok. T\'avais l\'air sec, je voulais vérifier.',
      'Pardon. Bon courage.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 18,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_seche',
    textVariants: [
      'Je suppose qu\'on s\'arrête là. Bonne suite.',
    ],
    endsArc: 'il_fade_seche',
  ),
];

/// Catalogue des templates disponibles dans PR1 — un seul pour valider
/// la profondeur. Les 26 autres viennent en PR2+.
const kRomanceTemplates = <RomanceTemplate>[
  RomanceTemplate(
    id: 'slow_burn_sincere',
    archetypeLabel: 'Slow burn sincère',
    tone: RomanceTone.sincere,
    profilePool: _slowBurnProfiles,
    beats: _slowBurnBeats,
    minStartDay: 1,
    spawnWeight: 1.0,
    cooldownDays: 20,
    description: 'Architecte calme, lecteur, propose un RDV au J4-5. '
        'Branche selon mensonge Shen : rupture honnête, ghost, fade.',
  ),
];
