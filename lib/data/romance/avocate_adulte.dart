import '../../models/romance.dart';

/// AVOCATE / MAGISTRATE MÈRE CÉLIB
/// Femme 32-38 ans, vie carrée, conversations adultes. Filtre vite,
/// décide vite, propose un dîner. Tendre mais peut couper net si
/// urgence enfant. Arc 8 jours.

const avocateProfiles = <RomanceProfile>[
  RomanceProfile(
    id: 'estelle_l',
    name: 'Estelle',
    age: 33,
    profession: 'Avocate droit pénal',
    quartier: '6e',
    detail: 'fils Mateo 5 ans',
    bio: 'Avocate. Mère solo de Mateo. Vie pleine. Je sais ce que je veux.',
    gradient: [0xFF6C5A8C, 0xFF302840],
    emoji: '⚖️',
    photoEmojis: ['⚖️', '📚', '🍷', '🌷'],
  ),
  RomanceProfile(
    id: 'catherine_v',
    name: 'Catherine',
    age: 36,
    profession: 'Magistrate',
    quartier: '7e',
    detail: 'fille Léa 8 ans',
    bio: 'Juge. Mère. Femme. Pas dans cet ordre nécessairement.',
    gradient: [0xFF5C6A78, 0xFF282E36],
    emoji: '🏛️',
    photoEmojis: ['🏛️', '📖', '☕', '🌳'],
  ),
  RomanceProfile(
    id: 'florence_p',
    name: 'Florence',
    age: 34,
    profession: 'Procureure',
    quartier: 'Versailles',
    detail: 'jumeaux 7 ans',
    bio: 'Procureure de la République. Deux fils. Pas le temps pour les jeux.',
    gradient: [0xFF705C6E, 0xFF302830],
    emoji: '📜',
    photoEmojis: ['📜', '🍷', '📚', '🌷'],
  ),
];

const avocateBeats = <RomanceBeat>[
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: RomanceBeatType.text,
    textVariants: [
      'Bonsoir. Je vais à l\'essentiel. Vous êtes architecte, vous vivez où, '
          'êtes-vous mariée, vegan, ou en thérapie ?',
      'Bonsoir. J\'ai 2h le mardi soir et 4h le samedi quand ma mère prend Mateo. '
          'Plage horaire intéressante ?',
      'Bonjour. Pas de petits jeux. Vous cherchez quoi exactement ?',
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
        label: 'Direct',
        reply: 'Architecte, 24, célibataire officielle, ni vegan ni thérapie.',
        moodDelta: 1,
        setBranch: 'shen_direct_av',
      ),
      RomanceChoice(
        label: 'Recule',
        reply: 'Vous allez vite.',
        setBranch: 'shen_recule_av',
      ),
      RomanceChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_av',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: RomanceBeatType.text,
    requireBranch: 'shen_direct_av',
    textVariants: [
      'Bien. Mardi 21h, Septime Cave, rue Charonne ?',
      'Excellent. Dîner samedi 20h, Chez la Vieille, rue Bailleul.',
      'OK. Verre demain 19h, Le Mary Celeste. Vous me direz vite si on continue.',
    ],
  ),
  RomanceBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 24,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_direct_av',
    choices: [
      RomanceChoice(
        label: 'Accepter',
        reply: 'OK.',
        moodDelta: 1,
        setBranch: 'rdv_av',
      ),
      RomanceChoice(
        label: 'Trop vite',
        reply: 'Trop vite. La semaine prochaine.',
        setBranch: 'rdv_av_decale',
      ),
    ],
  ),
  // ── J+2 — RDV adulte, conversation directe
  RomanceBeat(
    dayOffset: 2,
    atHour: 18,
    atMinute: 14,
    type: RomanceBeatType.mapLocation,
    requireBranch: 'rdv_av',
    photoLabels: [
      'Septime Cave · 3 rue Basfroi · 21h00',
      'Chez la Vieille · 1 rue Bailleul · 20h00',
      'Mary Celeste · 1 rue Commines · 19h00',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 22,
    atMinute: 48,
    type: RomanceBeatType.text,
    requireBranch: 'rdv_av',
    textVariants: [
      'Merci pour ce soir. Sincèrement.\nVotre métier vous occupe ou vous protège ?',
      'Vous m\'avez parlé d\'un projet d\'aménagement comme on parle de Bach. '
          'C\'est rare.\nOn se revoit ?',
      'Mateo dort. Je profite du calme pour vous écrire : c\'était bien.',
    ],
  ),
  RomanceBeat(
    dayOffset: 2,
    atHour: 22,
    atMinute: 52,
    type: RomanceBeatType.choice,
    fromThem: false,
    requireBranch: 'rdv_av',
    choices: [
      RomanceChoice(
        label: 'Continuer',
        reply: 'Oui. Je voudrais vous revoir.',
        moodDelta: 2,
        setBranch: 'shen_continue_av',
      ),
      RomanceChoice(
        label: 'Confier',
        reply: 'Je dois être honnête : ma vie est en contrat. Je vis avec un homme.',
        moodDelta: 1,
        setBranch: 'shen_confesse_av',
      ),
      RomanceChoice(
        label: 'Reculer',
        reply: 'Je peux pas en fait. Pardon.',
        endsArc: 'shen_recule_post_rdv_av',
      ),
    ],
  ),
  RomanceBeat(
    dayOffset: 3,
    atHour: 8,
    atMinute: 32,
    type: RomanceBeatType.text,
    requireBranch: 'shen_confesse_av',
    textVariants: [
      'Bien. Merci de m\'avoir dit. Mateo doit me voir et personne d\'autre. '
          'Bonne suite.',
      'Pas mon truc les vies contractuelles. Mais c\'était bien.',
      'Vous êtes courageuse de le dire. Je préfère m\'éloigner.',
    ],
    endsArc: 'av_arret_droit',
  ),
  RomanceBeat(
    dayOffset: 7,
    atHour: 21,
    atMinute: 8,
    type: RomanceBeatType.text,
    requireBranch: 'shen_continue_av',
    textVariants: [
      'Crise petite. Mateo aux urgences. On reportera.',
      'Garde demain matin. Trop tôt pour décider. On se voit dans 10 jours.',
      'Désolée. Affaire qui prend tout l\'air. Plus tard.',
    ],
    endsArc: 'av_couupe_urgence',
  ),
];

const avocateTemplate = RomanceTemplate(
  id: 'avocate_adulte',
  archetypeLabel: 'Avocate mère célib',
  tone: RomanceTone.adult,
  profilePool: avocateProfiles,
  beats: avocateBeats,
  minStartDay: 1,
  spawnWeight: 0.6,
  cooldownDays: 30,
  description: 'Femme 32-36 vie carrée, mère solo. Décide vite, '
      'coupe net sur urgence enfant.',
);
