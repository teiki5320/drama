import '../../models/messages_arc.dart';

/// KARIM — wrong number qui devient ami
/// Karim, ~28 ans, mécano à Pantin, envoie un SMS à un mauvais numéro
/// ("t'es où ?"). Si Shen répond gentil, conversation continue. Si
/// elle ignore, il finit par s'excuser. Arc 4-7 jours.

const karimContact = MessagesArcContact(
  id: 'arc_karim_wrong',
  displayName: '+33 6 79 24 31 88',
  emoji: '❓',
  avatarTint: '#E9DBC8',
  subtitle: 'Numéro inconnu',
  gradient: [0xFFB5957A, 0xFF5A4838],
  isUnknown: true,
);

const karimBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 4,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Salut Karim t\'es où ?',
      'Vas-y bro tu pars sans dire',
      'T\'es où t\'as oublié les clés du garage',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 12,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Doux',
        reply: 'Bonjour, je crois que vous vous trompez de numéro.',
        moodDelta: 1,
        setBranch: 'shen_doux_k',
      ),
      MessagesArcChoice(
        label: 'Joueuse',
        reply: 'Je suis pas Karim mais j\'ai pas les clés non plus.',
        moodDelta: 1,
        setBranch: 'shen_joueuse_k',
      ),
      MessagesArcChoice(
        label: 'Ignore',
        reply: '',
        endsArc: 'shen_ignore_k_silent',
      ),
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    forbidBranch: 'shen_ignore_k_silent',
    textVariants: [
      'Oh putain pardon. Mauvais numéro.\nDésolé Madame.',
      'Mince. Bonne soirée.',
      'Pardon. Bonne journée.',
    ],
  ),
  // ── J+0 — Si joueuse il rebondit
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 16,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_joueuse_k',
    textVariants: [
      'Haha. Vous m\'avez fait rire en plein stress. Merci. Bonne soirée Madame.',
      'C\'est cool. Vraiment. J\'avais pas la tête au taf, ça m\'a remis en route.',
      'Le mec à qui je tape ne répond jamais. Vous gagnez le concours du soir.',
    ],
  ),
  // ── J+1 — Il rappelle pour s'excuser et tend une main
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 13,
    atMinute: 42,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_joueuse_k',
    textVariants: [
      'Salut Madame. C\'est moi du mauvais numéro hier. Karim — le vrai. '
          '24 ans, mécano à Pantin. Pas relou je vous jure.',
      'Du coup je m\'appelle Karim aussi 😅 c\'est mon prénom. Et hier '
          'j\'écrivais à mon associé. Petite vie quoi.',
      'Promis je vais pas devenir relou. Mais merci pour hier. C\'était '
          'cool d\'avoir un rire en plein gros caca.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 13,
    atMinute: 48,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_joueuse_k',
    choices: [
      MessagesArcChoice(
        label: 'Continuer',
        reply: 'Hey Karim. Moi Shen. Pas tellement plus vieille que toi. '
            'Bonne fin de journée.',
        moodDelta: 1,
        setBranch: 'shen_continue_k',
      ),
      MessagesArcChoice(
        label: 'Couper poli',
        reply: 'C\'est gentil. Bonne suite Karim.',
        setBranch: 'shen_coupe_poli_k',
      ),
      MessagesArcChoice(
        label: 'Couper sec',
        reply: 'OK bye.',
        setBranch: 'shen_coupe_sec_k',
      ),
    ],
  ),
  // ── J+3 — Si continue, il revient avec une petite confidence
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 21,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_continue_k',
    textVariants: [
      'Salut. Petite question chelou : t\'as déjà parlé à un inconnu '
          'plus simplement qu\'aux gens que tu connais ?',
      'Bizarre que je t\'écrive. Je m\'attendais pas à toi. Bonne soirée.',
      'Je t\'envoie ce truc parce qu\'au taf personne écoute. Pas obligée '
          'de répondre.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 21,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_continue_k',
    textVariants: [
      'Mon père est en chimio depuis 8 mois. Ma mère est forte mais je vois '
          'qu\'elle craque la nuit. Je travaille la journée et je suis ailleurs '
          'le soir. Voilà.',
      'On ouvre un garage à 4. J\'ai investi tout ce que j\'avais. Si ça '
          'capote dans 6 mois je sais pas ce que je deviens.',
      'Mon associé Karim — l\'autre Karim — il vient de me lâcher. Du coup '
          'j\'ai un truc qui pend.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 21,
    atMinute: 28,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_continue_k',
    choices: [
      MessagesArcChoice(
        label: 'Confier',
        reply: 'Ma mère est malade aussi. C\'est cher et c\'est court. '
            'J\'ai pas dit ça à grand monde.',
        moodDelta: 2,
        setBranch: 'shen_confie_k',
      ),
      MessagesArcChoice(
        label: 'Écouter',
        reply: 'Je suis désolée Karim. C\'est dur. Tu fais comment ?',
        moodDelta: 1,
        setBranch: 'shen_ecoute_k',
      ),
      MessagesArcChoice(
        label: 'Reculer',
        reply: 'Pardon Karim, je peux pas être ton oreille. Bonne soirée.',
        endsArc: 'k_recule_k',
      ),
    ],
  ),
  // ── J+5 : Si confie, ils deviennent compagnons d'angoisse
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 22,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_confie_k',
    textVariants: [
      'Wesh. On se ressemble plus que je pensais. Tu veux qu\'on se voie '
          'pour un café ? Je suis pas chelou promis.',
      'Pareil pour moi cette semaine. Si tu craques la nuit, tu m\'écris.',
      'Tu sais quoi : si t\'as besoin d\'un mec qui sait pas quoi dire mais '
          'qui répond, je suis là.',
    ],
    endsArc: 'karim_compagnon_angoisse',
  ),
  MessagesArcBeat(
    dayOffset: 4,
    atHour: 22,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_ecoute_k',
    textVariants: [
      'Merci. Bonne soirée.',
      'Merci d\'avoir lu en fait.',
    ],
    endsArc: 'karim_ami_distant',
  ),
];

const karimTemplate = MessagesArcTemplate(
  id: 'karim_wrong_number',
  label: 'Karim (wrong number)',
  category: MessagesArcCategory.wrongNumber,
  contact: karimContact,
  beats: karimBeats,
  minStartDay: 1,
  spawnWeight: 0.7,
  cooldownDays: 60,
  description: 'Wrong number qui devient confident d\'angoisse. Karim '
      'mécano à Pantin, père en chimio.',
);
