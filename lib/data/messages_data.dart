/// Données initiales des conversations Messages pour J1-J3.
///
/// Les threads sont indexés par contactId. Chaque message a un sender
/// ("moi" = Shen, sinon le contact), un texte, une heure, un statut
/// (sent/delivered/read), et un jour de déclenchement.
///
/// Les threads spam (banque, numericable) ajoutent du bruit, comme dans
/// la vraie vie : ils ne portent pas la narration mais rendent l'app
/// crédible.

class MsgContact {
  final String id;
  final String displayName;
  final String emoji;
  final String avatarTint; // couleur hex
  final bool isFavorite;

  const MsgContact({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.avatarTint,
    this.isFavorite = false,
  });
}

const kContacts = <MsgContact>[
  MsgContact(
    id: 'maman',
    displayName: 'Maman ❤️',
    emoji: '👩',
    avatarTint: '#FCE6D8',
    isFavorite: true,
  ),
  MsgContact(
    id: 'camille',
    displayName: 'Camille',
    emoji: '🥐',
    avatarTint: '#FCE6D8',
    isFavorite: true,
  ),
  MsgContact(
    id: 'tristan',
    displayName: 'Tristan H.',
    emoji: '🧊',
    avatarTint: '#D7DEE5',
  ),
  MsgContact(
    id: 'banque',
    displayName: 'BANQUE INFO',
    emoji: '🏦',
    avatarTint: '#E7E1D2',
  ),
  MsgContact(
    id: 'numericable',
    displayName: 'NUMERICABLE',
    emoji: '📡',
    avatarTint: '#E7E1D2',
  ),
  MsgContact(
    id: 'plateforme',
    displayName: 'Livraisons Pro',
    emoji: '🛵',
    avatarTint: '#E0E7D7',
  ),
];

MsgContact contactById(String id) =>
    kContacts.firstWhere((c) => c.id == id);

class Msg {
  final String sender; // 'moi' ou un id de contact
  final String text;
  final String time; // "07:42"
  final int day; // J1, J2...
  final MsgStatus status;

  const Msg({
    required this.sender,
    required this.text,
    required this.time,
    required this.day,
    this.status = MsgStatus.read,
  });
}

enum MsgStatus { sent, delivered, read }

/// Conversations indexées par contactId. Pour chaque contact, on a la
/// liste complète des messages (Shen et l'autre) ordonnée chronologiquement.
const Map<String, List<Msg>> kThreads = {
  'maman': [
    Msg(
      sender: 'maman',
      text: 'Tu pars livrer dans combien ?',
      time: '07:48',
      day: 1,
    ),
    Msg(
      sender: 'moi',
      text: 'Dix minutes. Vélo, pluie, le 8ᵉ.',
      time: '07:49',
      day: 1,
    ),
    Msg(
      sender: 'maman',
      text:
          'Tes vingt-quatre ans ne tiendront pas la pluie aussi longtemps que tu le crois.',
      time: '07:49',
      day: 1,
    ),
    Msg(
      sender: 'maman',
      text: 'Couvre-toi. Et mange un truc avant de monter sur ce vélo.',
      time: '07:50',
      day: 1,
    ),
    Msg(sender: 'moi', text: 'Oui Maman.', time: '07:50', day: 1),
    Msg(sender: 'maman', text: 'Tu as mangé ?', time: '08:14', day: 1),
    Msg(sender: 'moi', text: 'Oui.', time: '08:14', day: 1),
    Msg(
      sender: 'maman',
      text:
          '« Oui ». Tu réponds « oui » depuis trois jours. Donne-moi un détail.',
      time: '08:15',
      day: 1,
    ),
    Msg(
      sender: 'moi',
      text: 'Pain au chocolat de la veille trempé dans du thé. Ça m\'a tenu.',
      time: '08:16',
      day: 1,
    ),
    Msg(
      sender: 'maman',
      text: 'Merci ma fille. Couvre-toi, il pleut.',
      time: '08:16',
      day: 1,
    ),
    Msg(
      sender: 'moi',
      text: 'Toi couvre-toi surtout.',
      time: '08:17',
      day: 1,
      status: MsgStatus.delivered,
    ),
  ],
  'camille': [
    Msg(
      sender: 'camille',
      text: 'Alors la livraison du matin ?',
      time: '11:42',
      day: 1,
    ),
    Msg(
      sender: 'moi',
      text: 'Je te raconte ce soir.',
      time: '11:55',
      day: 1,
    ),
    Msg(
      sender: 'camille',
      text: 'Ça veut dire que ça s\'est mal passé.',
      time: '11:55',
      day: 1,
    ),
    Msg(
      sender: 'camille',
      text: '😤',
      time: '11:55',
      day: 1,
    ),
    Msg(
      sender: 'camille',
      text: 'Tu vas le rappeler.',
      time: '14:02',
      day: 4,
    ),
    Msg(sender: 'moi', text: 'Non.', time: '14:02', day: 4),
    Msg(sender: 'camille', text: 'Shen. Dix-huit mille. Ta mère.', time: '14:03', day: 4),
    Msg(sender: 'moi', text: 'Je ne mendie pas chez les Heng.', time: '14:03', day: 4),
    Msg(sender: 'camille', text: 'C\'est pas mendier si tu rends. C\'est emprunter.', time: '14:04', day: 4),
    Msg(sender: 'camille', text: 'Tu as gardé sa carte, hein.', time: '14:05', day: 4),
  ],
  'tristan': [],
  'banque': [
    Msg(
      sender: 'banque',
      text:
          'BNP : 50 € sur votre compte mardi grâce à notre offre parrainage. Code PARRAIN-2026. STOP au 36173.',
      time: '06:12',
      day: 1,
    ),
    Msg(
      sender: 'banque',
      text:
          'INFO BNP : votre demande de crédit personnel n°7842 a été REFUSÉE. Motif : pas de garant éligible. Détails sur l\'app.',
      time: '14:23',
      day: 3,
    ),
  ],
  'numericable': [
    Msg(
      sender: 'numericable',
      text:
          'NUMERICABLE : -30% sur la fibre 1Gb pendant 6 mois. Offre valable jusqu\'au 15/06. STOP au 36500.',
      time: '09:08',
      day: 1,
    ),
  ],
  'plateforme': [
    Msg(
      sender: 'plateforme',
      text:
          'Course #14872 — Bowl Açaí — Avenue Montaigne. Acceptez dans 30s. 8,40 €.',
      time: '07:52',
      day: 1,
    ),
    Msg(
      sender: 'plateforme',
      text:
          'INCIDENT — Course #14872 marquée comme non livrée. Pénalité de 38,00 € appliquée sur la prochaine paie. Conseil : reprenez une course tout de suite.',
      time: '08:31',
      day: 1,
    ),
  ],
};
