import '../../models/messages_arc.dart';

/// NADIA — ex coloc Belleville
/// 25 ans, partageait l'appart de Belleville avec Shen jusqu'au J9.
/// Shen est partie sans expliquer (emménagement Avenue Foch). Nadia
/// écrit pour comprendre ou récupérer du courrier. Arc 5-7 jours.

const nadiaContact = MessagesArcContact(
  id: 'arc_nadia_coloc',
  displayName: 'Nadia (ex coloc)',
  emoji: '🌿',
  avatarTint: '#E5DCC8',
  subtitle: 'Belleville',
  gradient: [0xFFC4A87C, 0xFF5E4830],
);

const nadiaBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 6,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Shen tu as oublié plein d\'affaires. Je les ai mises dans 2 cartons. '
          'Tu repasses quand ?',
      'Hello Shen. Trois semaines sans nouvelles. Tu vis où maintenant ? '
          'On était colocs depuis 2 ans quand même.',
      'Shen. Sérieusement. Tu m\'expliques ce qui s\'est passé ?',
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
        label: 'Honnête',
        reply: 'Nadia pardon. Je suis partie vite parce que je vis '
            'temporairement chez quelqu\'un. C\'est long à expliquer.',
        moodDelta: 1,
        setBranch: 'shen_honnete_n',
      ),
      MessagesArcChoice(
        label: 'Évasive',
        reply: 'Pardon Nadia. Je suis chez ma mère un moment. Je repasse '
            'samedi.',
        setBranch: 'shen_evasive_n',
      ),
      MessagesArcChoice(
        label: 'Pratique',
        reply: 'Je passe samedi 14h prendre les cartons. Merci.',
        moodDelta: -1,
        setBranch: 'shen_pratique_n',
      ),
    ],
  ),
  // ── J+1 — Réaction selon branche
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 11,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_honnete_n',
    textVariants: [
      'OK. T\'es pas obligée de m\'expliquer. Mais t\'aurais pu dire un '
          'mot. Je commence à payer ta part du loyer.',
      'Merci de dire. Tu es chez qui ? Pas de jugement.',
      'Ça va Shen ? Tu peux me dire si t\'as besoin.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 11,
    atMinute: 18,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_honnete_n',
    choices: [
      MessagesArcChoice(
        label: 'Tout dire',
        reply: 'Je vis chez quelqu\'un qui me paie pour qu\'on fasse '
            'semblant pendant 3 mois. C\'est pour Maman. Pour ses soins.',
        moodDelta: 2,
        setBranch: 'shen_tout_dit_n',
      ),
      MessagesArcChoice(
        label: 'Pas plus',
        reply: 'Je peux pas en dire plus là. Je te paie ta part de loyer '
            'jusqu\'à la fin du bail, promis.',
        moodDelta: 1,
        setBranch: 'shen_loyer_n',
      ),
    ],
  ),
  // ── J+2 — Réaction si Shen tout dit
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 8,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_tout_dit_n',
    textVariants: [
      'Putain Shen.\nT\'aurais pu me le dire. Je suis là.\nViens dîner '
          'jeudi. Pas de pression.',
      'Tu as fait ça pour ta mère. OK. Je vais pas te juger. Je suis là '
          'si tu veux.',
      'Je suis pas sûre de comprendre mais je vais pas te juger. '
          'Tu peux venir dormir ici quand tu veux.',
    ],
    endsArc: 'nadia_alliee_silence',
  ),
  MessagesArcBeat(
    dayOffset: 4,
    atHour: 19,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_loyer_n',
    textVariants: [
      'OK. Merci pour le loyer. Je trouve un nouveau coloc pour le mois '
          'prochain.',
      'Reçu. Bonne suite Shen. J\'espère que tu vas bien.',
    ],
    endsArc: 'nadia_distance',
  ),
  // ── Évasive : elle insiste un peu
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 14,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_evasive_n',
    textVariants: [
      'Ta mère a appelé pour récupérer ton courrier. Elle savait pas que '
          'tu étais pas chez Belleville. Tu lui as menti aussi ?',
      'Shen. Je suis pas conne. Ta mère sait pas pour ton départ. Tu '
          'm\'expliques ?',
      'Bon. Je crois qu\'on doit se voir. Tu peux passer samedi ?',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 14,
    atMinute: 38,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_evasive_n',
    choices: [
      MessagesArcChoice(
        label: 'Avouer',
        reply: 'Pardon Nadia. C\'est dur à dire. Ma mère sait pas. Je '
            'gère son traitement seule. J\'ai un arrangement avec '
            'quelqu\'un. Pour l\'argent.',
        moodDelta: 1,
        setBranch: 'shen_avoue_n',
      ),
      MessagesArcChoice(
        label: 'Fermer',
        reply: 'Je peux pas en parler. Désolée.',
        endsArc: 'nadia_blesse',
      ),
    ],
  ),
  MessagesArcBeat(
    dayOffset: 4,
    atHour: 22,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_avoue_n',
    textVariants: [
      'OK Shen. C\'est lourd ce que tu portes.\nQuand tu veux dîner, je '
          'suis là.',
    ],
    endsArc: 'nadia_alliee_silence',
  ),
  // ── Pratique : Nadia se ferme
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 13,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_pratique_n',
    textVariants: [
      'Bon. Les cartons sont devant la porte. Bonne suite.',
      'Pas la peine de sonner. Je serai sortie samedi.',
    ],
    endsArc: 'nadia_glace',
  ),
];

const nadiaTemplate = MessagesArcTemplate(
  id: 'nadia_coloc',
  label: 'Nadia (ex coloc Belleville)',
  category: MessagesArcCategory.ancien,
  contact: nadiaContact,
  beats: nadiaBeats,
  minStartDay: 10,  // après le J9 emménagement
  spawnWeight: 0.8,
  cooldownDays: 80,
  description: 'Ex coloc Belleville. Shen est partie sans expliquer. '
      'Confession possible, alliance ou glaciation.',
);
