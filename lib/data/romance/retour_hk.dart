import '../../models/romance.dart';

/// RETOUR HONG KONG
/// Homme 28-33 ans, ancien expat HK rentré à Paris. Apparaît à partir
/// de J35 (après l'épisode HK). Parle de Repulse Bay, des nuits Lan Kwai
/// Fong, de la promesse non tenue d'un retour. Arc variable.

const retourHkProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'romain_t',
    name: 'Romain',
    age: 30,
    profession: 'Ex-trader HK · banque Paris',
    quartier: '8e',
    detail: '5 ans à Repulse Bay',
    bio: 'Rentré l\'an dernier. Hong Kong me manque. Tu connais ?',
    gradient: [0xFF5C4A60, 0xFF2A222E],
    emoji: '🏙️',
    photoEmojis: ['🏙️', '🥟', '🌅', '🚇'],
  ),
  RomanceProfile(
    id: 'vincent_t',
    name: 'Vincent',
    age: 32,
    profession: 'Avocat international',
    quartier: '7e',
    detail: 'Paris-HK-Singapour',
    bio: 'Vie en triangle. Cherche quelqu\'un qui comprend les fuseaux.',
    gradient: [0xFF606C7C, 0xFF2A3038],
    emoji: '✈️',
    photoEmojis: ['✈️', '🏙️', '🍜', '🌃'],
  ),
  RomanceProfile(
    id: 'anthony_d',
    name: 'Anthony',
    age: 29,
    profession: 'Hôtelier · Macao puis Paris',
    quartier: '11e',
    detail: '8 ans Asie',
    bio: 'Hôtellerie. Macao puis Hong Kong. Maintenant Paris pour souffler.',
    gradient: [0xFF6C5C4C, 0xFF302820],
    emoji: '🥢',
    photoEmojis: ['🥢', '🌃', '🍜', '🎰'],
  ),
];

const retourHkBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. J\'ai vu sur ton bio une référence à HK. Vrai voyageuse ou hasard ?',
      'Hello. Marchand. Ce nom me dit quelque chose. Tu as de la famille à Hong Kong ?',
      'Salut. Je rentre d\'HK. Tu y es allée récemment ?',
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
        label: 'Hésitante',
        reply: 'J\'y suis allée oui. Pourquoi ?',
        setBranch: 'shen_hesite_h',
      ),
      RomanceChoice(
        label: 'Évasive',
        reply: 'Pourquoi cette question ?',
        moodDelta: 1,
        setBranch: 'shen_evasive_h',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_h',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 24,
    type: RomanceBeatType.text,
    textVariants: [
      'J\'ai vécu 5 ans là-bas. Banque, Causeway Bay. Et toi ?',
      'Famille Heng, ça te dit quelque chose ? Je suis tombé sur eux pour un dossier.',
      'Le Lan Kwai Fong te manque autant qu\'à moi ?',
    ],
  ),
  // ── J+2 — Vraie conversation HK
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 14,
    type: RomanceBeatType.text,
    textVariants: [
      'Tu sais pourquoi je suis rentré ? J\'ai dit que je reviendrais à quelqu\'un. '
          'Je suis pas revenu.',
      'Je crois que je viens à Paris pour oublier HK. Ça marche pas.',
      'Petite question : tu vas y retourner ?',
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
        label: 'Mélancolique',
        reply: 'Probablement. C\'est compliqué.',
        moodDelta: 1,
        setBranch: 'shen_melanco_h',
      ),
      RomanceChoice(
        label: 'Fermer',
        reply: 'Je préfère pas en parler.',
        setBranch: 'shen_ferme_h',
      ),
      RomanceChoice(
        label: 'Ouvrir',
        reply: 'J\'y suis allée pour une famille qui s\'appelle Heng. C\'était pas un voyage normal.',
        moodDelta: 2,
        setBranch: 'shen_ouvre_h',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 21,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ouvre_h',
    textVariants: [
      'Les Heng. OK. Pas mes amis non plus. Mais je connais.\n'
          'Si tu veux qu\'on en parle au sec, je t\'invite à boire un thé.',
      'Heng. Bien sûr. Je peux pas être objectif. Je sais des choses.\n'
          'Tu veux quoi vraiment de moi ?',
    ],
  ),
  // ── J+4 — RDV mélancolique
  RomanceBeat(
    dayOffset: 4,
    atHour: 19,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_ouvre_h',
    textVariants: [
      'Vendredi 19h, La Tour d\'Argent — bar — pas le resto, je te rassure.',
      'Bar du Park Hyatt mardi 22h. Calme. On peut parler.',
      'Mon appart 8e. Thé, pas de jeu. Samedi 16h.',
    ],
  ),
  RomanceBeat(
    dayOffset: 4,
    atHour: 19,
    atMinute: 36,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_ouvre_h',
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'OK je viens.',
        moodDelta: 1,
        setBranch: 'rdv_h',
      ),
      RomanceChoice(
        label: 'Sentir piège',
        reply: 'Je crois qu\'on cherche pas la même chose.',
        endsArc: 'shen_recule_h',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 6,
    atHour: 22,
    atMinute: 14,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_h',
    textVariants: [
      'Merci pour le thé. Tu m\'as dit en 1h plus que personne en 6 mois.',
      'On peut s\'écrire en chinois si tu veux. Pour personne d\'autre.',
      'Je sais qui était Mei. Pas besoin de tout dire.',
    ],
    endsArc: 'h_complicite_lourde',
  ),
];

const retourHkTemplate = RomanceTemplate(
  id: 'retour_hk',
  archetypeLabel: 'Retour de Hong Kong',
  tone: RomanceTone.reunion,
  profilePool: retourHkProfiles,
  beats: retourHkBeats,
  minStartDay: 35,
  spawnWeight: 0.8,
  cooldownDays: 60,
  description: 'Homme ex-expat HK rentré. Connaît les Heng. Contextuel ep 3+.',
);
