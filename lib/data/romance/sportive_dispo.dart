import '../../models/romance.dart';

/// SPORTIVE DISPO
/// Femme 28-33 ans, kiné / coach running / prof natation. Propose un
/// footing, une rando, une séance commune. Shen physiquement épuisée
/// (livraisons + Maman) ne peut pas suivre. Arc 5 jours.

const sportiveProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'romane_v',
    name: 'Romane',
    age: 31,
    profession: 'Kinésithérapeute',
    quartier: '15e',
    detail: 'marathon Berlin',
    bio: 'Kiné. Marathon. Cherche partenaire de footing et plus.',
    gradient: [0xFF7AA88C, 0xFF38543E],
    emoji: '🏃‍♀️',
    photoEmojis: ['🏃‍♀️', '🌲', '🥗', '☕'],
  ),
  RomanceProfile(
    id: 'camille_s',
    name: 'Camille',
    age: 28,
    profession: 'Coach running',
    quartier: '12e',
    detail: 'tour de Paris 2x/sem',
    bio: 'Je cours. Beaucoup. Tu cours ?',
    gradient: [0xFFA8B098, 0xFF505546],
    emoji: '👟',
    photoEmojis: ['👟', '🌳', '🌅', '💪'],
  ),
  RomanceProfile(
    id: 'elodie_g',
    name: 'Élodie',
    age: 30,
    profession: 'Prof natation',
    quartier: '11e',
    detail: 'piscine 6h-8h',
    bio: 'Bassin tous les matins 6h. Je dors à 21h. Pas pour tout le monde.',
    gradient: [0xFF6E94B0, 0xFF324050],
    emoji: '🏊‍♀️',
    photoEmojis: ['🏊‍♀️', '🌊', '🥑', '🌅'],
  ),
];

const sportiveBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 10,
    type: RomanceBeatType.text,
    textVariants: [
      'Salut. Footing demain matin 7h Buttes-Chaumont ? Pas obligée de matcher mon allure.',
      'Hello. Bassin demain 6h45 ? Je t\'apprends crawl si tu veux.',
      'Hey. Rando dimanche forêt de Fontainebleau ? 12 km. Tranquille.',
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
        label: 'Tentée',
        reply: 'Tentée mais je suis pas en forme.',
        setBranch: 'shen_tentee_sp',
      ),
      RomanceChoice(
        label: 'Direct non',
        reply: 'Pas possible physiquement. Mais on peut boire un café ?',
        setBranch: 'shen_cafe_sp',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_sp',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: RomanceBeatType.text,
    requireBranch: 'shen_tentee_sp',
    textVariants: [
      'Pas grave. On y va lentement. 30 min, jamais essoufflée.',
      'OK tranquille. Plutôt balade rapide alors. 7h30 ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_cafe_sp',
    textVariants: [
      'Tu sais quoi : OK pour un café. Mais après je t\'amène marcher.',
      'Un café d\'abord, sport après si tu te sens. Samedi 10h ?',
    ],
  ),
  // ── J+2 — Le RDV sport
  RomanceBeat(
    dayOffset: 2,
    atHour: 7,
    atMinute: 8,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'shen_tentee_sp',
    photoLabels: [
      'Buttes-Chaumont · entrée Botzaris · 7h30',
      'Bois de Vincennes · porte Dorée · 8h00',
      'Canal de l\'Ourcq · Rosa Parks · 7h30',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 9,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'shen_tentee_sp',
    textVariants: [
      'T\'as tenu 12 minutes. Bravo. On remet ça ?',
      'Pardon je t\'ai poussée. Tu vas bien ?',
      'T\'as failli vomir. Très charmant en vrai 😅',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 9,
    atMinute: 18,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_tentee_sp',
    choices: [
      RomanceChoice(
        label: 'Tenter encore',
        reply: 'OK. Plus court la prochaine fois.',
        moodDelta: 1,
        setBranch: 'shen_essaie_sp',
      ),
      RomanceChoice(
        label: 'Avouer',
        reply: 'Je suis pas faite pour. Désolée.',
        endsArc: 'shen_avoue_sp',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 18,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_essaie_sp',
    textVariants: [
      'Tu manges quoi le soir ? Si c\'est sucre, on a un problème.',
      'Marathon Berlin en sept. Tu viens m\'encourager ?',
    ],
    endsArc: 'sp_decalage_durable',
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 22,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_cafe_sp',
    textVariants: [
      'C\'était sympa le café. Mais je sens pas trop le truc.',
      'Tu fumes encore. Je peux pas. Pardon.',
    ],
    endsArc: 'sp_lui_part_doux',
  ),
];

const sportiveTemplate = RomanceTemplate(
  id: 'sportive_dispo',
  archetypeLabel: 'Sportive dispo',
  tone: RomanceTone.sporty,
  profilePool: sportiveProfiles,
  beats: sportiveBeats,
  minStartDay: 1,
  spawnWeight: 0.6,
  cooldownDays: 25,
  description: 'Femme 28-31 sportive. Footing 7h, Shen KO. Décalage physique.',
);
