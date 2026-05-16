import '../../models/messages_arc.dart';

/// SARAH — ancienne collègue d'archi à Lyon
/// 28 ans, ex-collègue de Shen pendant son stage Lyon il y a 2 ans.
/// Propose un job freelance, négociation 7-10 jours, finit en mission
/// (refus / accept / mission ratée).

const sarahContact = MessagesArcContact(
  id: 'arc_sarah_collegue',
  displayName: 'Sarah Vincent',
  emoji: '📐',
  avatarTint: '#D8E5DC',
  subtitle: 'Ancienne collègue Lyon',
  gradient: [0xFF8CA09A, 0xFF3E4A45],
);

const sarahBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Shen ! C\'est Sarah V. de l\'agence Bouchère à Lyon. Je suis à '
          'Paris pour 6 mois, t\'as 5 min ?',
      'Hello Shen. Ça fait 2 ans. Si je te dis "le projet du tram", tu te '
          'rappelles ?',
      'Salut Shen. Tu cherches du freelance ? J\'ai un truc qui pourrait '
          't\'intéresser.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 16,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Heureuse',
        reply: 'Sarah ! Ouf que ça fait du bien d\'avoir de tes nouvelles. '
            'Dis-moi tout.',
        moodDelta: 1,
        setBranch: 'shen_heureuse_s',
      ),
      MessagesArcChoice(
        label: 'Mesurée',
        reply: 'Sarah ! Oui je me rappelle. Dis-moi.',
        setBranch: 'shen_mesuree_s',
      ),
      MessagesArcChoice(
        label: 'Sceptique',
        reply: 'Sarah. Salut. Tu me proposes quoi exactement ?',
        moodDelta: -1,
        setBranch: 'shen_sceptique_s',
      ),
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Voilà : une amie monte une boîte de design d\'espace, basée 11e. '
          'Elle cherche un.e archi freelance pour modéliser 3 lofts en '
          '6 semaines. 4 800 € net.',
      'Mission Paris 11e : 3 lofts à modéliser et plans d\'aménagement. '
          'Budget 4 800 €. Délai 6 semaines. Tu serais dispo ?',
      'On a besoin de quelqu\'un qui sait dessiner vite et bien. T\'es '
          'la première à qui je pense.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 28,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Accepter',
        reply: 'OK. Tu m\'envoies les specs ce soir ?',
        moodDelta: 2,
        setBranch: 'shen_accept_s',
      ),
      MessagesArcChoice(
        label: 'Négocier',
        reply: '4800 c\'est court. Tu peux remonter à 6500 ?',
        setBranch: 'shen_negocie_s',
      ),
      MessagesArcChoice(
        label: 'Hésiter',
        reply: 'Laisse-moi y réfléchir 24h.',
        setBranch: 'shen_hesite_s',
      ),
      MessagesArcChoice(
        label: 'Refuser',
        reply: 'Pas dispo en ce moment. Une autre fois.',
        endsArc: 'shen_refuse_s',
      ),
    ],
  ),
  // ── J+0 : Négociation
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 36,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_negocie_s',
    textVariants: [
      'Je peux pousser à 5400. Pas plus. Elle est jeune, elle gère son '
          'cash.',
      'Honnêtement non. Mais je peux te garantir 4800 + recommandation '
          'pour 2 autres missions plus tard.',
      'Si tu me lâches pas en route, je peux monter à 5500.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 40,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_negocie_s',
    choices: [
      MessagesArcChoice(
        label: 'OK',
        reply: 'OK pour 5400. On commence quand ?',
        moodDelta: 1,
        setBranch: 'shen_accept_s',
      ),
      MessagesArcChoice(
        label: 'Refuser',
        reply: 'Non c\'est trop court pour moi. Désolée.',
        endsArc: 'shen_refuse_negocie_s',
      ),
    ],
  ),
  // ── J+2 — Specs envoyées
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 9,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_accept_s',
    textVariants: [
      'Je t\'envoie les specs par mail. RDV chez elle samedi 14h pour '
          'kick-off. 22 rue Saint-Maur.',
      'Specs envoyées. Premier livrable : esquisses des 3 lofts pour le '
          '10 du mois.',
      'Tu reçois le brief. La cliente s\'appelle Anaïs Becker, '
          'sympa mais perfectionniste.',
    ],
  ),
  // ── J+5 : Sarah suit
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_accept_s',
    textVariants: [
      'Anaïs m\'a dit que tu lui as envoyé une première esquisse. Elle '
          'a aimé. Continue.',
      'Petit point : tu cours dans 8 directions ? Anaïs m\'a dit que tu '
          'as l\'air débordée.',
      'Tu tiens le délai ? Pas de pression mais elle est stricte.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 26,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_accept_s',
    choices: [
      MessagesArcChoice(
        label: 'Confier',
        reply: 'Sarah franchement c\'est compliqué. Ma mère est malade, '
            'je dois jongler.',
        moodDelta: 1,
        setBranch: 'shen_confie_s',
      ),
      MessagesArcChoice(
        label: 'Rassurer',
        reply: 'Tout va bien. Je tiens le délai.',
        setBranch: 'shen_rassure_s',
      ),
      MessagesArcChoice(
        label: 'Abandonner',
        reply: 'Sarah je crois que je vais devoir lâcher la mission.',
        moodDelta: -2,
        endsArc: 'shen_lache_mission',
      ),
    ],
  ),
  // ── J+7 — Conclusion selon branche
  MessagesArcBeat(
    dayOffset: 7,
    atHour: 11,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_confie_s',
    textVariants: [
      'Je suis désolée Shen. Si tu veux je peux te trouver un binôme.\n'
          'Reste sur la mission. On t\'aide.',
      'Putain Shen pardon. Je savais pas. On va trouver une solution. '
          'Tiens bon.',
      'Si tu veux que je redirige Anaïs pour qu\'elle paie en avance, '
          'je peux essayer.',
    ],
    endsArc: 'sarah_alliee_pro',
  ),
  MessagesArcBeat(
    dayOffset: 8,
    atHour: 21,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_rassure_s',
    textVariants: [
      'OK. Anaïs attend tes plans le 10. Tu gères.',
    ],
    endsArc: 'sarah_pro_distance',
  ),
];

const sarahTemplate = MessagesArcTemplate(
  id: 'sarah_collegue',
  label: 'Sarah — ex-collègue archi',
  category: MessagesArcCategory.ancien,
  contact: sarahContact,
  beats: sarahBeats,
  minStartDay: 4,
  spawnWeight: 0.8,
  cooldownDays: 60,
  description: 'Ex-collègue Lyon, propose mission archi freelance 4800 €. '
      'Négociation, suivi, possibilité aide.',
);
