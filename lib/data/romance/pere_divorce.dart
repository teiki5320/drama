import '../../models/romance.dart';

/// PÈRE DIVORCÉ ÉPUISÉ
/// 36-42 ans, séparé avec 1-2 enfants. Honnête sur sa fatigue, propose
/// uniquement des cafés courts entre garde et garde. Amitié possible si
/// Shen accepte le rythme. Arc 8 jours.

const pereProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'vincent_l',
    name: 'Vincent',
    age: 38,
    profession: 'Directeur commercial',
    quartier: 'Vincennes',
    detail: 'garde alternée 2 enfants',
    bio: 'Séparé, deux enfants 8 et 11 ans, garde alternée. '
        'Pas pressé. Pas non-disponible.',
    gradient: [0xFF55504A, 0xFF2A2520],
    emoji: '👨‍👧‍👦',
    photoEmojis: ['👨‍👧‍👦', '☕', '🚲', '🍂'],
  ),
  RomanceProfile(
    id: 'philippe_n',
    name: 'Philippe',
    age: 41,
    profession: 'Avocat fiscaliste',
    quartier: 'Boulogne',
    detail: 'fils 9 ans 1 week-end/2',
    bio: 'Père de Léo, 9 ans. Divorcé propre. Cherche calme.',
    gradient: [0xFF4A5260, 0xFF1F2530],
    emoji: '⚖️',
    photoEmojis: ['⚖️', '👨‍👦', '📚', '☕'],
  ),
  RomanceProfile(
    id: 'thomas_g',
    name: 'Thomas',
    age: 36,
    profession: 'Architecte salarié',
    quartier: '15e',
    detail: 'fille de 6 ans',
    bio: 'Papa solo 50%. Pas de drama. Du temps quand j\'en ai.',
    gradient: [0xFF606060, 0xFF2A2A2A],
    emoji: '👨‍👧',
    photoEmojis: ['👨‍👧', '🎨', '🚲', '☕'],
  ),
];

const pereBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 10,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Je préviens d\'avance : père divorcé, deux enfants. '
          'C\'est pas une excuse, c\'est une donnée.',
      'Salut. Je swipe en couchant mon petit. Tu auras un retour tardif probablement.',
      'Hello. Je suis honnête : peu de disponibilité, beaucoup de présence quand je suis là.',
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
        label: 'Respect',
        reply: 'Merci d\'être clair. Salut.',
        moodDelta: 1,
        setBranch: 'shen_respect_p',
      ),
      RomanceChoice(
        label: 'Curieuse',
        reply: 'Quel âge les enfants ?',
        setBranch: 'shen_curieuse_p2',
      ),
      RomanceChoice(
        label: 'Pas envie',
        reply: '',
        endsArc: 'shen_ghost_pere',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 8,
    atMinute: 32,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonjour. Réveil 6h30 ce matin avec petit déj de gosses.',
      'Bien dormi ? Moi pas vraiment, le grand a fait un cauchemar.',
      'Hello. Tu fais quoi le matin avant que la vraie journée commence ?',
    ],
  ),
  // ── J+2 — Proposition café honnête, courte fenêtre
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 18,
    type: RomanceBeatType.text,
    textVariants: [
      'Je suis libre mardi entre 14h et 16h pendant qu\'ils sont chez '
          'leur mère. Café Square Daviel ?',
      'Vendredi 12h-13h30, déjeuner rapide ? C\'est la fenêtre que j\'ai.',
      'Samedi matin 8h-10h avant que je les récupère. Coutume Babylone ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 22,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'OK fenêtre',
        reply: 'OK. Cette fenêtre me convient.',
        moodDelta: 1,
        setBranch: 'rdv_pere',
      ),
      RomanceChoice(
        label: 'Plus tard',
        reply: 'Pas cette semaine. Une autre ?',
        setBranch: 'pere_plus_tard',
      ),
      RomanceChoice(
        label: 'Trop compliqué',
        reply: 'C\'est trop compliqué pour moi. Pardon.',
        endsArc: 'shen_decline_pere',
      ),
    ],
  ),
  // ── J+3 — Le RDV bref
  RomanceBeat(
    dayOffset: 3,
    atHour: 13,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_pere',
    photoLabels: [
      'Square Daviel · 13e · 14h00',
      'Coutume Babylone · 47 rue de Babylone · 8h00',
      'Le Comptoir Général · Canal · 12h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 16,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_pere',
    textVariants: [
      'Merci pour cet entre-deux. C\'était rare.',
      'Je dois récupérer la grande à 17h. Mais c\'était bien.',
      'Je vois pas quand on se revoit avant 10 jours. Tu te projettes ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 16,
    atMinute: 12,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_pere',
    choices: [
      RomanceChoice(
        label: 'OK long',
        reply: 'OK on s\'écrit en attendant. Pas pressée.',
        moodDelta: 1,
        setBranch: 'shen_patient_pere',
      ),
      RomanceChoice(
        label: 'Amitié',
        reply: 'Et si on restait amis simplement ? Sans projection ?',
        moodDelta: 1,
        setBranch: 'shen_amitie_pere',
      ),
      RomanceChoice(
        label: 'Trop dur',
        reply: 'Je vais pas pouvoir attendre 10 jours à chaque fois.',
        endsArc: 'shen_lache_pere',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 7,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_amitie_pere',
    textVariants: [
      'OK. C\'est sage. Tu seras la première personne qui me propose ça.',
      'Sage. Merci.',
      'Si tu veux qu\'on se voie en ami, je dis oui.',
    ],
    endsArc: 'pere_amitie',
  ),
  RomanceBeat(
    dayOffset: 8,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_patient_pere',
    textVariants: [
      'Tu es là encore ? J\'aime bien.',
      'Petit message du soir : t\'es la première à qui j\'écris ce soir.',
    ],
    endsArc: 'pere_continue',
  ),
];

const pereTemplate = RomanceTemplate(
  id: 'pere_divorce',
  archetypeLabel: 'Père divorcé épuisé',
  tone: RomanceTone.fragile,
  profilePool: pereProfiles,
  beats: pereBeats,
  minStartDay: 1,
  spawnWeight: 0.7,
  cooldownDays: 30,
  description: '36-42 ans, séparé, enfants 50%. Fenêtres courtes, honnête. '
      'Amitié possible. 5 fins.',
);
