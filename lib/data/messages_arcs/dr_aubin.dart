import '../../models/messages_arc.dart';

/// Dr AUBIN — oncologue Maman à Tenon
/// Arc 4-6 jours. Premier SMS = confirmation RDV. Puis résultats à
/// récupérer en personne, possibilité de scénario mauvaise nouvelle.
/// Ton clinique, courtois, distance professionnelle.

const drAubinContact = MessagesArcContact(
  id: 'arc_dr_aubin',
  displayName: 'Dr Aubin (Tenon)',
  emoji: '🩺',
  avatarTint: '#D7DEE5',
  subtitle: 'Oncologue',
  gradient: [0xFF3D5A6C, 0xFF1C2D38],
);

const drAubinBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 6,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Bonjour Madame Marchand. Dr Aubin, Tenon. Confirmation RDV de '
          'Madame Marchand-mère vendredi 8h30, niveau 2, couloir K. '
          'Merci de venir accompagnée.',
      'Bonjour. Dr Aubin. Je confirme la séance de chimio mardi matin. '
          'Apportez sa carte vitale et l\'ordonnance précédente.',
      'Bonjour Madame Marchand. Suite à l\'examen sanguin de votre mère, '
          'je souhaite vous voir avec elle vendredi 11h. Cabinet 214.',
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
        label: 'Confirmer',
        reply: 'Bonjour Docteur. Confirmé. Je serai là.',
        setBranch: 'shen_confirme_a',
      ),
      MessagesArcChoice(
        label: 'Demander pourquoi',
        reply: 'Bonjour Docteur. Pourquoi me demandez-vous d\'être présente '
            'à ce rendez-vous précisément ?',
        moodDelta: -1,
        setBranch: 'shen_inquiet_a',
      ),
      MessagesArcChoice(
        label: 'Reporter',
        reply: 'Je ne peux pas vendredi. Lundi possible ?',
        setBranch: 'shen_reporte_a',
      ),
    ],
  ),
  // ── J+0 — Réponse à la question
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_inquiet_a',
    textVariants: [
      'Rien d\'urgent au sens où il faudrait paniquer. Mais le résultat '
          'mérite que nous nous parlions à trois. Bonne soirée.',
      'Examen de routine + un point que je souhaite discuter avec vous '
          'présente. Cela aide votre mère. À vendredi.',
      'C\'est un rendez-vous de protocole. Mais votre présence simplifie '
          'la conversation. Je vous expliquerai sur place.',
    ],
  ),
  // ── J+0 reporté
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 22,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_reporte_a',
    textVariants: [
      'Lundi 11h alors. Cabinet 214. Apportez la carte vitale.',
      'D\'accord pour lundi mais je dois préciser que les nouveaux '
          'résultats ne s\'attendent pas. Lundi 14h.',
    ],
  ),
  // ── J+2 ou J+3 : Rappel avant RDV
  MessagesArcBeat(
    dayOffset: 2,
    atHour: 17,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Rappel pour le rendez-vous demain matin. Pensez à arriver 15 min '
          'avant pour les formalités.',
      'Petit rappel : RDV demain. Faites-la déjeuner légèrement la veille.',
      'À demain. Si elle prend du Tramadol, ne pas en prendre 4h avant.',
    ],
  ),
  // ── J+3 : Le jour du RDV - on s'arrête là, le RDV se fait IRL
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 15,
    atMinute: 38,
    type: MessagesArcBeatType.text,
    textVariants: [
      'Suite à votre passage ce matin : votre mère a très bien réagi à '
          'la nouvelle. Comme toujours. Tenez bon.',
      'Je vous rappelle le seuil important : nous avons jusqu\'à J45. '
          'Au-delà la décision médicale change.',
      'Je vous joins par mail le devis et la lettre pour votre mutuelle. '
          'Si quelque chose ne va pas, écrivez-moi.',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 3,
    atHour: 15,
    atMinute: 42,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Merci pro',
        reply: 'Merci Docteur. Je vous tiens informé.',
        moodDelta: 1,
        setBranch: 'shen_pro_a',
      ),
      MessagesArcChoice(
        label: 'Honnête',
        reply: 'Docteur, je vais devoir trouver 18 000 € en 6 semaines. '
            'Est-ce qu\'il existe des aides que je n\'ai pas explorées ?',
        moodDelta: 1,
        setBranch: 'shen_honnete_a',
      ),
      MessagesArcChoice(
        label: 'Silence',
        reply: '',
        setBranch: 'shen_silence_a',
      ),
    ],
  ),
  // ── J+4 : Si Shen honnête, Dr Aubin oriente
  MessagesArcBeat(
    dayOffset: 4,
    atHour: 9,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_honnete_a',
    textVariants: [
      'L\'assistante sociale de l\'hôpital, Mme Lemaitre, est disponible '
          'le mardi. Je vous écris son numéro : 01 56 01 70 32. Dites '
          'que vous venez de ma part.',
      'Il existe un fond d\'urgence pour les cancers rares, dossier à '
          'monter sous 10 jours. Je vous envoie le formulaire par mail.',
      'Je peux orienter votre dossier vers une bourse caritative qui '
          'finance jusqu\'à 8 000 € en 4 semaines. Je vous joins demain.',
    ],
    endsArc: 'aubin_aide_pratique',
  ),
  MessagesArcBeat(
    dayOffset: 5,
    atHour: 18,
    atMinute: 8,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_pro_a',
    textVariants: [
      'Bonne continuation. À votre disposition si besoin.',
    ],
    endsArc: 'aubin_distance_pro',
  ),
  MessagesArcBeat(
    dayOffset: 6,
    atHour: 11,
    atMinute: 32,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_silence_a',
    textVariants: [
      'Pas de nouvelles. J\'espère que votre mère va bien. Je reste '
          'joignable.',
    ],
    endsArc: 'aubin_silence',
  ),
];

const drAubinTemplate = MessagesArcTemplate(
  id: 'dr_aubin',
  label: 'Dr Aubin — oncologue Maman',
  category: MessagesArcCategory.medical,
  contact: drAubinContact,
  beats: drAubinBeats,
  minStartDay: 2,
  spawnWeight: 0.9,
  cooldownDays: 30,
  description: 'Oncologue Tenon. Confirmation RDV, résultats, possibilité '
      'd\'aide sociale si Shen ose demander. 3 fins.',
);
