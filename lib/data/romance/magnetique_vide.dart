import '../../models/romance.dart';

/// MAGNÉTIQUE MAIS VIDE
/// Femme 24-28 ans, physiquement saisissante (danseuse, mannequin),
/// photos sublimes mais conversation creuse : emojis, "haha", monosyllabes.
/// Shen se rend compte progressivement. Arc 4 jours, frustration esthétique.

const magnetiqueProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'jade_t',
    name: 'Jade',
    age: 24,
    profession: 'Danseuse contemporaine',
    quartier: '11e',
    detail: 'CCN Montpellier',
    bio: 'Danseuse. Le corps parle mieux que moi.',
    gradient: [0xFFD17A8A, 0xFF66364A],
    emoji: '💃',
    photoEmojis: ['💃', '🌹', '🌅', '🪞'],
  ),
  RomanceProfile(
    id: 'lola_p',
    name: 'Lola',
    age: 26,
    profession: 'Mannequin freelance',
    quartier: '8e',
    detail: 'Paris/Milan',
    bio: 'Modèle. Je suis pas que ça mais on me croit pas.',
    gradient: [0xFFB0A088, 0xFF504538],
    emoji: '🌷',
    photoEmojis: ['🌷', '🪞', '🌊', '🥂'],
  ),
  RomanceProfile(
    id: 'eva_s',
    name: 'Eva',
    age: 28,
    profession: 'Coach pilates',
    quartier: '16e',
    detail: 'cliente Heng International',
    bio: 'Coach. Yoga. Vegan. Lyon-Paris-Bali.',
    gradient: [0xFFA8C0B0, 0xFF4A5A50],
    emoji: '🧘‍♀️',
    photoEmojis: ['🧘‍♀️', '🌿', '🌊', '🥥'],
  ),
];

const magnetiqueBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: ['hey 😊', 'salut 🌹', 'hi ✨'],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Charmée',
        reply: 'Salut. Tes photos sont folles.',
        setBranch: 'shen_charmee_m',
      ),
      RomanceChoice(
        label: 'Question',
        reply: 'Salut. Tu fais quoi dans la vie ?',
        setBranch: 'shen_question_m',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_m',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.text,
    textVariants: ['merci 😘', 'aw merci toi ✨', 'tnks ❤️'],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 16,
    atMinute: 22,
    type: RomanceBeatType.photoShared,
    photoLabels: [
      'selfie dans un studio de danse, miroir, lumière dorée',
      'selfie sur une plage à 17h, mer bleue, sans contexte',
      'gros plan de ses cils, café à côté',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 16,
    atMinute: 23,
    type: RomanceBeatType.text,
    textVariants: ['🌞', '✨✨', 'mood'],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'tu fais quoi ce soir ? 😏',
      'tu sors où d\'habitude ?',
      'on se boit un verre ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'Tenter',
        reply: 'OK. Où ?',
        setBranch: 'rdv_m',
      ),
      RomanceChoice(
        label: 'Tester',
        reply: 'Tu m\'as répondu en monosyllabes 3 jours. Tu sais que je sais lire ?',
        moodDelta: 1,
        setBranch: 'shen_test_m',
      ),
      RomanceChoice(
        label: 'Lâcher',
        reply: 'En fait c\'est pas ça. Bonne suite.',
        endsArc: 'shen_lache_m',
      ),
    ],
  ),
  // ── J+2 — Réponse à la provoc
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_test_m',
    textVariants: [
      'haha ok ben tant pis',
      'tu es agressive là',
      'je parle pas beaucoup je suis comme ça',
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 23,
    atMinute: 32,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_test_m',
    endsArc: 'elle_unmatch_vexe',
  ),
  // ── J+4 — Le RDV : conversation toujours pauvre IRL
  RomanceBeat(
    dayOffset: 4,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_m',
    photoLabels: [
      'Le Perchoir Marais · rooftop · 20h00',
      'L\'Ami Pierre · rue de la Verrerie · 21h00',
      'Marais Plage · 19h30',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 23,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_m',
    textVariants: ['c\'était cool 🌹', 'merci 😊', 'on refait ?'],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 23,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_m',
    choices: [
      RomanceChoice(
        label: 'S\'éloigner',
        reply: 'C\'était joli. Mais c\'est pas pour moi.',
        moodDelta: 0,
        endsArc: 'shen_lache_post_rdv',
      ),
      RomanceChoice(
        label: 'Mensonge poli',
        reply: 'Oui carrément.',
        moodDelta: -1,
        setBranch: 'shen_ment_m',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 7,
    atHour: 22,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ment_m',
    textVariants: ['hey 😊 dispo ce week-end ?'],
  ),
  RomanceBeat(
    dayOffset: 14,
    atHour: 22,
    atMinute: 8,
    type: RomanceBeatType.unmatch,
    requireBranch: 'shen_ment_m',
    endsArc: 'elle_unmatch_oubli',
  ),
];

const magnetiqueTemplate = RomanceTemplate(
  id: 'magnetique_vide',
  archetypeLabel: 'Magnétique mais vide',
  tone: RomanceTone.intense,
  profilePool: magnetiqueProfiles,
  beats: magnetiqueBeats,
  minStartDay: 1,
  spawnWeight: 0.8,
  cooldownDays: 25,
  description: 'Femme physiquement saisissante. Conversation en monosyllabes. '
      'Frustration esthétique 4 j.',
);
