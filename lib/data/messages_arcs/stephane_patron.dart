import '../../models/messages_arc.dart';

/// STÉPHANE — patron livraisons UberEats
/// 39 ans, manager opérationnel pour la plateforme. Sermons réguliers
/// sur le taux d'acceptation, menaces, possibilités de promotion ou
/// licenciement. Arc 5-8 jours.

const stephaneContact = MessagesArcContact(
  id: 'arc_stephane_patron',
  displayName: 'Stéphane (Livraisons Pro)',
  emoji: '🛵',
  avatarTint: '#D8E0CC',
  subtitle: 'Manager UberEats',
  gradient: [0xFF6A7855, 0xFF2E3625],
);

const stephaneBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 14,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Shen Marchand, c\'est Stéphane, manager UberEats secteur 8e. '
          'Votre taux d\'acceptation est tombé à 67 %. On doit en parler.',
      'Bonjour. Stéphane, manager Livraisons. Vous avez refusé 4 commandes '
          'cette semaine. Au-delà de 3 sur une semaine glissante, '
          'sanction.',
      'Shen, c\'est Stéphane. Vous étiez chez les top 10 % du quartier. '
          'Vous tombez. On corrige ?',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 14,
    atMinute: 14,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Excuser',
        reply: 'Bonjour Stéphane. Pardon. Semaine compliquée. Je rectifie.',
        setBranch: 'shen_excuse_st',
      ),
      MessagesArcChoice(
        label: 'Demander stats',
        reply: 'Mes 4 refus c\'est 5h-8h matin sur vélo, dans la pluie. '
            'Vous proposez quoi ?',
        moodDelta: 1,
        setBranch: 'shen_pousse_st',
      ),
      MessagesArcChoice(
        label: 'Confier',
        reply: 'Stéphane, ma mère est malade. Je gère seule. C\'est dur '
            'd\'être à 100 % en ce moment.',
        moodDelta: 1,
        setBranch: 'shen_confie_st',
      ),
    ],
  ),
  // ── J+1 : Réaction sermon
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_excuse_st',
    textVariants: [
      'OK. Vous remontez à 80 % dans 7 jours ou on vous bascule en '
          'priorité B.',
      'Bien noté. Je vous donne 1 semaine.',
      'OK Shen. Restez focus. 3 refus max par semaine glissante.',
    ],
  ),
  // ── J+1 : Quand poussée, il rebondit
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 11,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_pousse_st',
    textVariants: [
      'Hé Shen. Pas pire que le mois dernier. Je vous lâche un peu.\n'
          'Restez sur le 8e, c\'est plus stable.',
      'OK je note. Mais 67 % c\'est sous le seuil. Vous remontez ou je '
          'remonte la note.',
      'Vous avez du caractère, j\'aime ça. Mais le système, lui, il aime pas.',
    ],
  ),
  // ── J+1 : Quand confie, il s'ouvre — un peu
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_confie_st',
    textVariants: [
      'Ah. Désolé. Je peux passer votre dossier en priorité A pour '
          '4 semaines. Ça vous laisse souffler. Promesse perso.',
      'Mince. OK. Je peux activer un bonus parental pendant 3 semaines. '
          'C\'est 200 € de plus par mois.',
      'Ma mère est passée par là. Je peux pas faire grand-chose, mais je '
          'vais activer le "mode garde-malade" sur votre profil. Refus '
          'pas comptabilisés.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 14,
    atMinute: 18,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_confie_st',
    choices: [
      MessagesArcChoice(
        label: 'Accepter aide',
        reply: 'Oh putain merci Stéphane. Vraiment.',
        moodDelta: 2,
        endsArc: 'stephane_pro_aidant',
      ),
      MessagesArcChoice(
        label: 'Refuser fierté',
        reply: 'Non merci. Je préfère pas être traitée à part.',
        moodDelta: -1,
        endsArc: 'stephane_distance',
      ),
    ],
  ),
  // ── J+5 : Suite sermon — Shen a remonté ?
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 19,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_excuse_st',
    textVariants: [
      'Mise à jour : vous êtes à 78 %. Pas mal. Continuez.',
      'Vous êtes redescendue à 62 %. Avertissement formel transmis.',
      'Top 15 % cette semaine. Bonus de 50 € activé. Merci.',
    ],
    endsArc: 'stephane_resultats',
  ),
  MessagesArcBeat(
    dayOffset: 7,
    atHour: 11,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_pousse_st',
    textVariants: [
      'Trois refus de plus cette semaine. Je suis obligé d\'enclencher la '
          'procédure de mise en veille du compte. 30 jours.',
    ],
    endsArc: 'stephane_compte_suspendu',
  ),
];

const stephaneTemplate = MessagesArcTemplate(
  id: 'stephane_patron',
  label: 'Stéphane (patron UberEats)',
  category: MessagesArcCategory.work,
  contact: stephaneContact,
  beats: stephaneBeats,
  minStartDay: 3,
  spawnWeight: 0.7,
  cooldownDays: 50,
  description: 'Manager UberEats. Sermon sur taux d\'acceptation, '
      'possibilité d\'aide si Shen confie, suspension si elle pousse trop.',
);
