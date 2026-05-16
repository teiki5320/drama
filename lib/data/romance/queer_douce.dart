import '../../models/romance.dart';

/// INATTENDUE QUEER DOUCE
/// Femme 22-28 ans, lit beaucoup, propose librairie ou expo. Pose pas
/// de pression. Ouverture nouvelle pour Shen — possibilité de longue
/// durée si confession, fade doux si fermeture.

const queerDouceProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'mathilde_a',
    name: 'Mathilde',
    age: 25,
    profession: 'Étudiante littérature comparée',
    quartier: '4e',
    detail: 'lit Maggie Nelson',
    bio: 'Je ne sais plus à quoi je crois. Au moins j\'écris.',
    gradient: [0xFFB07A5C, 0xFF50321F],
    emoji: '📔',
    photoEmojis: ['📔', '🌷', '☕', '🖋️'],
  ),
  RomanceProfile(
    id: 'camille_h',
    name: 'Camille',
    age: 28,
    profession: 'Photographe argentique',
    quartier: '20e',
    detail: 'expose Belleville',
    bio: 'Photo. Pellicule. Lumière naturelle uniquement.',
    gradient: [0xFFA8826B, 0xFF4A3328],
    emoji: '📷',
    photoEmojis: ['📷', '🌷', '🎞️', '🌳'],
  ),
  RomanceProfile(
    id: 'lucie_d',
    name: 'Lucie',
    age: 22,
    profession: 'Étudiante archi ENSAPLV',
    quartier: '19e',
    detail: 'éclairs de génie',
    bio: 'Plus jeune que je le voudrais. Plus lumineuse aussi.',
    gradient: [0xFFE3A5C7, 0xFF7B4566],
    emoji: '🌻',
    photoEmojis: ['🌻', '✏️', '📐', '🌷'],
  ),
];

const queerDouceBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Ton bio est très « je ne sais plus à quoi je crois ». J\'aime.',
      'Bonjour. T\'as un visage qui n\'essaie pas de plaire. C\'est rare.',
      'Hello. Tu lis quoi en ce moment ?',
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
        reply: 'Hello. Et toi tu lis quoi ?',
        moodDelta: 1,
        setBranch: 'shen_curieuse_q',
      ),
      RomanceChoice(
        label: 'Hésitante',
        reply: 'Salut. Je suis nouvelle dans la catégorie femme. Tu prévois quoi ?',
        moodDelta: 1,
        setBranch: 'shen_hesite_q',
      ),
      RomanceChoice(
        label: 'Décliner doux',
        reply: 'En fait je me sens pas trop dispo. Bonne suite.',
        endsArc: 'shen_decline_q',
      ),
    ],
  ),
  // ── J+0 — Réponse à la curiosité
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_curieuse_q',
    textVariants: [
      'Maggie Nelson, « Bluets ». Un livre sur le bleu et sur le deuil. '
          'Pas mauvais pour Tinder à 23h.',
      'Annie Ernaux, encore. Je relis pour la 4ᵉ fois. Tu connais ?',
      'Lispector, « Près du cœur sauvage ». Ça me secoue.',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 36,
    type: RomanceBeatType.text,
    requireBranch: 'shen_hesite_q',
    textVariants: [
      'Rien. Je prévois rien. C\'est la beauté.',
      'Aucune pression. On peut juste parler.',
      'Ouf. Pareil. On commence par un café ou un message ?',
    ],
  ),
  // ── J+1-2 — Conversation littéraire / artistique
  RomanceBeat(
    dayOffset: 1,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu as quoi sur ta table de chevet ?',
      'Si tu pouvais retirer un mois de ta vie passée, ce serait lequel ?',
      'Le silence te fait peur ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Vrai',
        reply: 'Le silence non. Le bruit oui.',
        moodDelta: 1,
        setBranch: 'shen_vrai_q',
      ),
      RomanceChoice(
        label: 'Joueur',
        reply: 'Question piège. Tu commences.',
        moodDelta: 1,
        setBranch: 'shen_joueur_q',
      ),
      RomanceChoice(
        label: 'Esquiver',
        reply: 'Compliqué là.',
        setBranch: 'shen_esq_q',
      ),
    ],
  ),
  // ── J+3 — Proposition douce
  RomanceBeat(
    dayOffset: 3,
    atHour: 15,
    atMinute: 8,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_esq_q',
    textVariants: [
      'Tu veux un café à L\'Écume des Pages samedi 16h ? On regarde les livres.',
      'Expo « Femmes peintres » au Luxembourg dimanche après-midi. Si tu veux.',
      'Petite balade Canal Saint-Martin samedi 11h. Sans pression.',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 15,
    atMinute: 12,
    type: RomanceBeatType.choice,
    fromThem: false,
    forbidBranch: 'shen_esq_q',
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'Oui. Bonne idée.',
        moodDelta: 2,
        setBranch: 'rdv_q',
      ),
      RomanceChoice(
        label: 'Reporter',
        reply: 'Pas ce week-end. La semaine prochaine ?',
        setBranch: 'rdv_reporter_q',
      ),
      RomanceChoice(
        label: 'Décliner doux',
        reply: 'Je peux pas. Mais merci de proposer.',
        endsArc: 'shen_decline_post_q',
      ),
    ],
  ),
  // ── J+5 — Le RDV
  RomanceBeat(
    dayOffset: 5,
    atHour: 10,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_q',
    photoLabels: [
      'L\'Écume des Pages · 174 Bd Saint-Germain · 16h00',
      'Musée du Luxembourg · 19 rue de Vaugirard · 15h00',
      'Quai de Valmy · pont tournant · 11h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_q',
    textVariants: [
      'Merci pour cet après-midi. Tu m\'as fait du bien sans le savoir.',
      'J\'ai aimé t\'écouter parler de tes escaliers.',
      'On peut se revoir quand tu veux. Vraiment.',
    ],
  ),
  RomanceBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_q',
    choices: [
      RomanceChoice(
        label: 'Confier',
        reply: 'Je vis avec un homme. Contrat. C\'est compliqué.',
        moodDelta: 2,
        setBranch: 'shen_confesse_q',
      ),
      RomanceChoice(
        label: 'Doux retour',
        reply: 'Toi aussi tu m\'as fait du bien.',
        moodDelta: 1,
        setBranch: 'shen_doux_q',
      ),
      RomanceChoice(
        label: 'Esquiver',
        reply: 'C\'était sympa oui.',
        setBranch: 'shen_esq_post_q',
      ),
    ],
  ),
  // ── J+6 — Réponse à la confession (étonnamment ouverte)
  RomanceBeat(
    dayOffset: 6,
    atHour: 11,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse_q',
    textVariants: [
      'Oh. C\'est dense.\nJe préfère le savoir. On peut être amies, ou autre chose, '
          'ou rien. C\'est toi qui sais.',
      'Merci d\'avoir dit. Vraiment.\nJe reste là si tu veux.',
      'Un contrat ? Tu m\'expliqueras un jour. Pas obligée.',
    ],
  ),
  // ── J+10+ — Reste présente sans demander
  RomanceBeat(
    dayOffset: 10,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse_q',
    textVariants: [
      'J\'ai pensé à toi en lisant un truc. Je te l\'envoie ?',
      'Tu vas bien ?',
      'Si tu veux qu\'on se revoie sans étiquette, je suis là.',
    ],
  ),
  RomanceBeat(
    dayOffset: 20,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse_q',
    textVariants: [
      'Toujours là.',
    ],
    endsArc: 'q_amitie_durable',
  ),
  // ── Doux retour : 2e RDV puis Shen referme ou pas
  RomanceBeat(
    dayOffset: 12,
    atHour: 18,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_doux_q',
    textVariants: [
      'On se revoit ce week-end ? Cinéma ?',
      'Tu reviens à L\'Écume avec moi ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 12,
    atHour: 18,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_doux_q',
    choices: [
      RomanceChoice(
        label: 'Oui',
        reply: 'Oui.',
        moodDelta: 1,
        endsArc: 'q_relation_continue',
      ),
      RomanceChoice(
        label: 'Reculer',
        reply: 'Je peux pas en fait. Désolée.',
        endsArc: 'q_shen_recule',
      ),
    ],
  ),
  // ── Si Shen esquive, elle recule en douceur
  RomanceBeat(
    dayOffset: 8,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_esq_post_q',
    textVariants: [
      'Si tu te poses des questions, c\'est OK. Prends ton temps.',
      'Tu n\'as pas répondu beaucoup. Pas grave. Bonne suite si on s\'arrête là.',
    ],
    endsArc: 'q_fade_doux',
  ),
];

const queerDouceTemplate = RomanceTemplate(
  id: 'queer_douce',
  archetypeLabel: 'Inattendue queer douce',
  tone: RomanceTone.queer,
  profilePool: queerDouceProfiles,
  beats: queerDouceBeats,
  minStartDay: 5,
  spawnWeight: 0.8,
  cooldownDays: 30,
  description: 'Femme 22-28 cultivée. RDV librairie/expo. Ouverture nouvelle. '
      'Long terme possible si confession.',
);
