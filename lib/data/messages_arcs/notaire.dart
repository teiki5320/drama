import '../../models/messages_arc.dart';

/// MAÎTRE VIDAL — notaire qui a rédigé le contrat Heng
/// Suivi post-signature, rappels, possibilités d'annulation. Arc 3-5
/// jours. Ton sec, précis, juridique.

const notaireContact = MessagesArcContact(
  id: 'arc_notaire_vidal',
  displayName: 'Maître Vidal',
  emoji: '📜',
  avatarTint: '#E0DBC9',
  subtitle: 'Notaire',
  gradient: [0xFF8C7A5E, 0xFF3D352A],
);

const notaireBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 10,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Mlle Marchand, Mtre Vidal. Confirmation : contrat signé hier '
          'sous référence 2026/AVN/0847. Original 14 pages dans votre '
          'dossier client. Cordialement.',
      'Mlle Marchand. Suite à la signature : votre premier acompte de '
          '10 000 € sera versé sous 48 h ouvrées. Le solde à mi-période.',
      'Bonjour. Petit rappel : clause 11 — vous êtes tenue à la '
          'discrétion absolue. Aucun tiers ne doit être informé.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 10,
    atMinute: 14,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Accuser réception',
        reply: 'Bonjour Maître. Bien reçu. Merci.',
        setBranch: 'shen_recu_v',
      ),
      MessagesArcChoice(
        label: 'Demander une copie',
        reply: 'Bonjour. Pourriez-vous me renvoyer une copie PDF ? J\'ai '
            'égaré l\'original.',
        setBranch: 'shen_pdf_v',
      ),
      MessagesArcChoice(
        label: 'Question annulation',
        reply: 'Bonjour Maître. Quelle est exactement la procédure '
            'd\'annulation unilatérale ?',
        moodDelta: -1,
        setBranch: 'shen_annul_v',
      ),
    ],
  ),
  // ── J+1 — Si Shen veut PDF
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_pdf_v',
    textVariants: [
      'PDF envoyé sur votre adresse marchand.shen@gmail.com. Si vous ne '
          'le voyez pas, vérifiez les spams.',
      'Document numérique envoyé. Veuillez le stocker dans un lieu sûr. '
          'L\'original physique doit rester chez vous.',
    ],
  ),
  // ── J+1 — Si question annulation
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_annul_v',
    textVariants: [
      'Clause 14 : en cas de rupture unilatérale de votre part, '
          'indemnité de 30 000 € à verser sous 30 jours. Les fonds déjà '
          'versés ne sont pas restitués.',
      'Annulation unilatérale = pénalité 30 000 € + obligation de '
          'discrétion maintenue 10 ans. Je vous le rappelle pour mémoire.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 36,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_annul_v',
    choices: [
      MessagesArcChoice(
        label: 'Demander suite',
        reply: 'Est-ce qu\'il y a une marge de négociation pour réduire '
            'cette pénalité ?',
        moodDelta: 0,
        setBranch: 'shen_negocie_v',
      ),
      MessagesArcChoice(
        label: 'Comprendre',
        reply: 'Compris Maître. Merci de la précision.',
        moodDelta: -1,
        setBranch: 'shen_compris_v',
      ),
    ],
  ),
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 16,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_negocie_v',
    textVariants: [
      'Aucune. Le contrat est signé en l\'état. Je vous suggère de relire '
          'l\'article 14 avant toute action.',
      'La marge dépend de votre contrepartie. Vous voulez en discuter en '
          'rendez-vous ? 250 € l\'heure.',
    ],
    endsArc: 'notaire_dur',
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 11,
    atMinute: 4,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_compris_v',
    textVariants: [
      'À votre disposition pour toute question. Cordialement.',
    ],
    endsArc: 'notaire_pro_distant',
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 16,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_recu_v',
    textVariants: [
      'Confirmation : premier acompte de 10 000 € versé ce matin sur le '
          'compte indiqué. Bonne suite.',
    ],
    endsArc: 'notaire_pro_distant',
  ),
];

const notaireTemplate = MessagesArcTemplate(
  id: 'notaire_vidal',
  label: 'Maître Vidal (notaire)',
  category: MessagesArcCategory.admin,
  contact: notaireContact,
  beats: notaireBeats,
  minStartDay: 9,  // après signature J8
  spawnWeight: 0.8,
  cooldownDays: 90,
  description: 'Notaire post-signature. Rappels clauses, possibilité '
      'd\'explorer annulation (30 000 € pénalité).',
);
