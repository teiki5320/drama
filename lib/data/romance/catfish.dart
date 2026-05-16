import '../../models/romance.dart';

/// CATFISH
/// Profil "jeune et beau" trop lisse. Conversation OK, propose une
/// vidéo J+2, reveal d'un homme bien plus vieux. Shen bloque + signale.
/// Arc 3 jours, micro-thriller.

const catfishProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'damien_k',
    name: 'Damien',
    age: 28,
    profession: 'DJ',
    quartier: '20e',
    detail: 'photos trop léchées',
    bio: 'DJ. Soirées undergrond. Musique d\'auteur.',
    gradient: [0xFF6C5B8C, 0xFF2D2440],
    emoji: '🎧',
    photoEmojis: ['🎧', '🎚️', '🌃', '🍸'],
  ),
  RomanceProfile(
    id: 'marco_r',
    name: 'Marco',
    age: 30,
    profession: 'Voyageur',
    quartier: '11e',
    detail: 'pas d\'adresse fixe',
    bio: 'Vagabond moderne. Asie · Brésil · Lisbonne.',
    gradient: [0xFF8C6A4A, 0xFF3A2A1E],
    emoji: '🌍',
    photoEmojis: ['🌍', '🌊', '⛰️', '🏛️'],
  ),
  RomanceProfile(
    id: 'antonin_l',
    name: 'Antonin',
    age: 27,
    profession: 'Consultant freelance',
    quartier: '4e',
    detail: 'photos en costume',
    bio: 'Consultant. Hôtels d\'affaires. Cherche quelqu\'un de simple.',
    gradient: [0xFF4A4060, 0xFF222033],
    emoji: '👔',
    photoEmojis: ['👔', '🏨', '✈️', '🥂'],
  ),
];

const catfishBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: RomanceBeatType.text,
    textVariants: [
      'Hello. T\'as un sourire incroyable.',
      'Bonjour. Ton bio est joli.',
      'Salut. Toi sur Tinder, surprenant.',
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
        label: 'Polie',
        reply: 'Merci. Et toi ?',
        setBranch: 'shen_polie_cf',
      ),
      RomanceChoice(
        label: 'Méfiante',
        reply: 'Tes photos sont parfaites. Trop parfaites.',
        moodDelta: 1,
        setBranch: 'shen_mef_cf',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_cf',
      ),
    ],
  ),
  // ── J+1 — Conversation normale ──────────────────────────────
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 4,
    type: RomanceBeatType.text,
    forbidBranch: 'shen_mef_cf',
    textVariants: [
      'Tu fais quoi ce soir ?',
      'Ton métier te plaît ?',
      'On se voit ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 1,
    atHour: 12,
    atMinute: 6,
    type: RomanceBeatType.text,
    requireBranch: 'shen_mef_cf',
    textVariants: [
      'Tu me trouves trop parfait ? J\'ai un bon photographe.',
      'C\'est gentil. T\'es la première à me le dire comme ça.',
    ],
  ),
  // ── J+2 — Propose visioconf
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'On s\'appelle en vidéo ce soir 21h ? Pour de vrai, pas comme tout le monde.',
      'Visioconf demain soir ? Histoire de mettre une voix sur l\'écran.',
      'Tu m\'appelles ce soir ? Vidéo. 10 min.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 19,
    atMinute: 16,
    type: RomanceBeatType.choice,
    fromThem: false,
    choices: [
      RomanceChoice(
        label: 'OK',
        reply: 'OK. 21h.',
        setBranch: 'visio_acceptee',
      ),
      RomanceChoice(
        label: 'Plus tard',
        reply: 'Plus tard. Je préfère texter.',
        setBranch: 'visio_decline',
      ),
      RomanceChoice(
        label: 'Unmatch',
        reply: '',
        endsArc: 'shen_unmatch_cf',
      ),
    ],
  ),
  // ── J+2 21h — REVEAL ──────────────────────────────────────
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 0,
    type: RomanceBeatType.callRing,
    requireBranch: 'visio_acceptee',
    callDurationS: 18,
    textVariants: [
      'Appel vidéo entrant — l\'écran s\'allume sur un homme de 47 ans '
          'en chemise blanche derrière un papier peint Ikea. Il sourit comme '
          'si tout allait bien : « Ah, finalement c\'est toi. »',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 1,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'visio_acceptee',
    choices: [
      RomanceChoice(
        label: 'Raccrocher + block',
        reply: '',
        moodDelta: -1,
        endsArc: 'shen_block_catfish',
      ),
      RomanceChoice(
        label: 'Confronter',
        reply: 'Tu as quel âge vraiment ?',
        setBranch: 'shen_confronte_cf',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 4,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confronte_cf',
    textVariants: [
      '47 ans. Pardon. Personne ne répond aux photos de mon âge.',
      '46 ans. Mais le sourire est vrai.',
      'Quel âge ça change ? On a parlé. C\'est pas suffisant ?',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 6,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_confronte_cf',
    choices: [
      RomanceChoice(
        label: 'Block + signal',
        reply: '',
        endsArc: 'shen_block_signal_cf',
      ),
      RomanceChoice(
        label: 'Disparaître',
        reply: '',
        endsArc: 'shen_disappear_cf',
      ),
    ],
  ),
  // ── J+3 — Pop-up signalement reçu
  RomanceBeat(
    dayOffset: 3,
    atHour: 9,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'visio_decline',
    textVariants: [
      'Pourquoi pas la vidéo ? T\'as peur ?',
      'On est tous bizarres. Allez juste 2 min.',
    ],
  ),
];

const catfishTemplate = RomanceTemplate(
  id: 'catfish',
  archetypeLabel: 'Catfish',
  tone: RomanceTone.catfish,
  profilePool: catfishProfiles,
  beats: catfishBeats,
  minStartDay: 1,
  spawnWeight: 0.5,
  cooldownDays: 40,
  description: 'Profil trop lisse. Visio J+2 → reveal homme 47 ans. '
      'Block + signal.',
);
