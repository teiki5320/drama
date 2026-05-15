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
  /// Chemin asset de l'avatar (ex: `assets/photos/avatars/shen.webp`).
  /// Si null, on retombe sur l'emoji + cercle teinté.
  final String? avatarPath;

  const MsgContact({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.avatarTint,
    this.isFavorite = false,
    this.avatarPath,
  });
}

const kContacts = <MsgContact>[
  MsgContact(
    id: 'maman',
    displayName: 'Maman ❤️',
    emoji: '👩',
    avatarTint: '#FCE6D8',
    isFavorite: true,
    avatarPath: 'assets/photos/avatars/maman.webp',
  ),
  MsgContact(
    id: 'camille',
    displayName: 'Camille',
    emoji: '🥐',
    avatarTint: '#FCE6D8',
    isFavorite: true,
    avatarPath: 'assets/photos/avatars/camille.webp',
  ),
  MsgContact(
    id: 'tristan',
    displayName: 'Tristan H.',
    emoji: '🧊',
    avatarTint: '#D7DEE5',
    avatarPath: 'assets/photos/avatars/tristan.webp',
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

  /// Si ce message attend une réponse de Shen avec choix (3 options),
  /// indique l'ID du beat. Quand le joueur répond, son message s'ajoute
  /// au thread et les jauges relation sont mises à jour.
  final String? beatId;

  /// Si non-null, ce message n'apparaît que si la suspicion du contact
  /// est >= ce seuil. Permet d'avoir des SMS « paranos » de Maman quand
  /// elle commence à douter, sans casser le canon principal.
  final int? requiresSuspicionAtLeast;

  const Msg({
    required this.sender,
    required this.text,
    required this.time,
    required this.day,
    this.status = MsgStatus.read,
    this.beatId,
    this.requiresSuspicionAtLeast,
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
      beatId: 'maman_petit_dej_j1',
    ),
    Msg(
      sender: 'maman',
      text: 'Merci ma fille. Couvre-toi, il pleut.',
      time: '08:18',
      day: 1,
      beatId: 'maman_couvre_toi_j1',
    ),
    // J11 — Premier mensonge sur le « stage paysagiste »
    Msg(
      sender: 'maman',
      text: 'Premier jour de stage. Comment ça s\'est passé ?',
      time: '21:08',
      day: 11,
    ),
    Msg(
      sender: 'maman',
      text:
          '« Bien ». Tu écris « bien » depuis trois jours. Donne-moi un détail.',
      time: '21:10',
      day: 11,
      beatId: 'maman_stage_j11',
    ),
    // J12+ — Variantes paranoïaques (apparaissent si suspicion >= 30)
    Msg(
      sender: 'maman',
      text:
          'J\'ai cherché Lao Chen sur les pages jaunes. Aucun résultat. '
          'C\'est un petit cabinet ?',
      time: '14:24',
      day: 12,
      requiresSuspicionAtLeast: 30,
    ),
    Msg(
      sender: 'maman',
      text:
          'Tu portes un parfum différent quand tu passes. Je ne te juge pas. '
          'Je te le dis.',
      time: '18:42',
      day: 13,
      requiresSuspicionAtLeast: 30,
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
    Msg(
      sender: 'camille',
      text: 'Tu as gardé sa carte, hein.',
      time: '14:05',
      day: 4,
      beatId: 'camille_carte_j4',
    ),
    // J6 — Préparation Tour Heng le lendemain
    Msg(
      sender: 'camille',
      text: 'Je passe ce soir avec le tailleur de ma mère. Noir. 38.',
      time: '17:42',
      day: 6,
    ),
    Msg(
      sender: 'camille',
      text:
          'Tu vas plaider ta propre affaire. Habille-toi comme telle.',
      time: '17:43',
      day: 6,
    ),
    Msg(
      sender: 'camille',
      text: 'Et révise ton mandarin. Au cas où il glisse dedans.',
      time: '17:44',
      day: 6,
      beatId: 'camille_tailleur_j6',
    ),
    // J13 — Préparation dîner Madame Heng
    Msg(
      sender: 'camille',
      text: 'Dîner Madame Heng samedi ? Tu y vas comment ?',
      time: '15:08',
      day: 13,
    ),
    Msg(
      sender: 'camille',
      text:
          'Mauvaise question. La vraie c\'est : QUEL THÉ ?',
      time: '15:09',
      day: 13,
      beatId: 'camille_quel_the_j13',
    ),
  ],
  'tristan': [
    // J7 — premier contact via la secrétaire
    Msg(
      sender: 'tristan',
      text:
          'Heng International. Mlle Marchand, j\'ai votre demande. Jeudi 11h, 47ᵉ étage, Tour Heng. Confirmation ?',
      time: '14:12',
      day: 6,
      beatId: 'tristan_rdv_j6',
    ),
    // J9 — premier SMS après emménagement
    Msg(
      sender: 'tristan',
      text:
          'J\'ai laissé la moitié de la penderie et la salle de bain attenante. Bureau pour moi. Vous êtes libre de réorganiser.',
      time: '17:22',
      day: 9,
    ),
  ],
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
    // Idée 11 — Spam ironique 9h après le refus
    Msg(
      sender: 'banque',
      text:
          'BNP Paribas Jeunes — découvrez le PEA Avenir, à partir de 50 €/mois. '
          'Préparez votre avenir dès aujourd\'hui ! STOP au 36173.',
      time: '23:12',
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
