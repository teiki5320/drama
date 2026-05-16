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
    id: 'madame_heng',
    displayName: 'Madame Heng',
    emoji: '🍵',
    avatarTint: '#E7E1D2',
    avatarPath: 'assets/photos/avatars/madame_heng.webp',
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
    // ── J1 — La pluie, le vélo, le petit déj ───────────────────
    Msg(
      sender: 'maman',
      text: 'Tu pars livrer dans combien de temps ?',
      time: '07:48',
      day: 1,
    ),
    Msg(
      sender: 'moi',
      text: 'Dix minutes. Vélo, pluie, le 8e.',
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
      text: 'Couvre-toi. Et mange quelque chose avant de prendre ce vélo.',
      time: '07:50',
      day: 1,
    ),
    Msg(sender: 'moi', text: 'Oui Maman.', time: '07:50', day: 1),
    Msg(sender: 'maman', text: 'Tu as mangé ?', time: '08:14', day: 1),
    Msg(sender: 'moi', text: 'Oui.', time: '08:14', day: 1),
    Msg(
      sender: 'maman',
      text:
          '« Oui. » Tu réponds « oui » depuis trois jours. Donne-moi un détail.',
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
    Msg(sender: 'maman', text: 'Tu as déjeuné ?', time: '12:34', day: 1),
    Msg(sender: 'moi', text: 'Oui un bowl.', time: '12:35', day: 1),
    Msg(sender: 'maman', text: 'Bowl. Le café au coin de la rue ?', time: '12:35', day: 1),
    Msg(sender: 'moi', text: 'Oui.', time: '12:36', day: 1),
    Msg(sender: 'maman', text: 'Pas trop de sel.', time: '12:36', day: 1),
    Msg(
      sender: 'maman',
      text: 'J\'ai trouvé l\'écharpe rose dans la commode. '
          'Elle te va mieux que celle que tu portes.',
      time: '15:48',
      day: 1,
    ),
    Msg(sender: 'maman', text: 'Tu rentres ce soir ?', time: '18:22', day: 1),
    Msg(
      sender: 'maman',
      text: 'Le riz est dans le rice cooker, garde-le au chaud.',
      time: '18:42',
      day: 1,
    ),
    Msg(sender: 'maman', text: 'Bonne nuit ma fille.', time: '22:12', day: 1),

    // ── J2 — Tenon, le matin glacé ─────────────────────────────
    Msg(sender: 'maman', text: 'Tu as bien dormi ?', time: '06:32', day: 2),
    Msg(sender: 'maman', text: 'Couvre-toi, il fait 7 degrés.', time: '07:18', day: 2),
    Msg(sender: 'maman', text: 'Tu manges où aujourd\'hui ?', time: '12:14', day: 2),
    Msg(
      sender: 'maman',
      text: 'J\'ai parlé à Tante Mei. Elle dit bonjour. '
          'Elle dit que les pluies se calment à Fujian.',
      time: '14:32',
      day: 2,
    ),
    Msg(
      sender: 'maman',
      text: 'Tu me ramènes du gingembre frais ? J\'en trouve plus à l\'épicerie.',
      time: '18:42',
      day: 2,
    ),
    Msg(sender: 'moi', text: 'Oui demain.', time: '18:45', day: 2),
    Msg(
      sender: 'maman',
      text:
          'Vivaldi à la radio. Ils ont passé le concerto que ton père aimait. '
          'Tu te souviens ?',
      time: '21:14',
      day: 2,
    ),

    // ── J3 — Crédit refusé. Compteur démarre. ──────────────────
    Msg(sender: 'maman', text: 'Bonne journée ma fille.', time: '07:14', day: 3),
    Msg(sender: 'maman', text: 'Pas trop de café.', time: '12:18', day: 3),
    Msg(
      sender: 'maman',
      text: 'J\'ai cherché une recette pour les niangao. Tu en veux ce dimanche ?',
      time: '16:42',
      day: 3,
    ),
    Msg(sender: 'maman', text: 'Tu manges où ?', time: '19:18', day: 3),
    Msg(
      sender: 'maman',
      text: 'Ce silence me dérange. Tu vas bien ?',
      time: '22:08',
      day: 3,
    ),
    Msg(sender: 'moi', text: 'Oui Maman.', time: '22:14', day: 3),
    Msg(sender: 'maman', text: 'D\'accord. Repose-toi.', time: '22:16', day: 3),

    // ── J4 — Le numéro masqué a appelé hier ────────────────────
    Msg(sender: 'maman', text: 'Bonjour ma fille.', time: '08:14', day: 4),
    Msg(sender: 'maman', text: 'Tu as mangé ?', time: '12:42', day: 4),
    Msg(sender: 'moi', text: 'Oui.', time: '12:48', day: 4),
    Msg(sender: 'maman', text: 'Pourquoi tu réponds tard ?', time: '13:18', day: 4),
    Msg(
      sender: 'maman',
      text: 'Je vais à l\'épicerie tout à l\'heure. Tu veux quoi ?',
      time: '17:32',
      day: 4,
    ),
    Msg(sender: 'moi', text: 'Rien Maman merci.', time: '17:48', day: 4),
    Msg(sender: 'maman', text: 'Tu rentres ce soir ?', time: '19:14', day: 4),
    Msg(
      sender: 'maman',
      text: 'Bonne soirée. Mets-toi au chaud.',
      time: '21:42',
      day: 4,
    ),

    // ── J5 — Dimanche dumplings ────────────────────────────────
    Msg(sender: 'maman', text: 'Bonjour. C\'est dimanche.', time: '07:42', day: 5),
    Msg(sender: 'maman', text: 'Je fais les dumplings.', time: '09:14', day: 5),
    Msg(sender: 'maman', text: 'Tu viens à quelle heure ?', time: '11:32', day: 5),
    Msg(sender: 'moi', text: 'Bientôt.', time: '11:33', day: 5),
    Msg(sender: 'maman', text: 'Le four sent bon.', time: '14:42', day: 5),
    Msg(sender: 'maman', text: 'Tu n\'es pas venue. C\'est rien.', time: '16:48', day: 5),
    Msg(sender: 'moi', text: 'Pardon Maman, travail urgent.', time: '18:48', day: 5),
    Msg(sender: 'maman', text: 'Ce n\'est rien. Je t\'ai dit.', time: '18:50', day: 5),
    Msg(
      sender: 'maman',
      text: 'Tu viens dimanche ? J\'ai fait des dumplings.',
      time: '19:08',
      day: 5,
    ),
    Msg(
      sender: 'maman',
      text:
          'Camille m\'a dit que tu travailles sur un dossier important. '
          'Je n\'ai pas demandé lequel.',
      time: '19:14',
      day: 5,
    ),
    Msg(
      sender: 'maman',
      text: 'J\'ai mis ta part au frigo. Avec un mot dessus.',
      time: '21:14',
      day: 5,
    ),

    // ── J6 — Veille Tour Heng ──────────────────────────────────
    Msg(sender: 'maman', text: 'Bonjour ma fille.', time: '09:14', day: 6),
    Msg(sender: 'maman', text: 'Tu déjeunes où ?', time: '12:32', day: 6),
    Msg(
      sender: 'maman',
      text: 'Camille a appelé. Elle dit que tu as un rendez-vous important demain.',
      time: '16:18',
      day: 6,
    ),
    Msg(sender: 'moi', text: 'Oui.', time: '16:19', day: 6),
    Msg(
      sender: 'maman',
      text: 'Pourquoi tu ne me l\'as pas dit toi-même ?',
      time: '16:20',
      day: 6,
    ),
    Msg(sender: 'moi', text: 'Je voulais pas t\'inquiéter.', time: '16:22', day: 6),
    Msg(
      sender: 'maman',
      text: 'Tu peux m\'inquiéter. C\'est mon métier.',
      time: '16:32',
      day: 6,
    ),
    Msg(
      sender: 'maman',
      text: 'Bonne chance demain. Tu sais tout.',
      time: '19:18',
      day: 6,
    ),
    Msg(
      sender: 'maman',
      text: 'J\'ai préparé du thé pour demain matin. Long Jing.',
      time: '21:48',
      day: 6,
    ),

    // ── J7 — Tour Heng + proposition trois mois ────────────────
    Msg(sender: 'maman', text: 'Couvre-toi.', time: '07:18', day: 7),
    Msg(sender: 'maman', text: 'Mange quelque chose avant.', time: '07:42', day: 7),
    Msg(sender: 'maman', text: 'Alors ?', time: '11:48', day: 7),
    Msg(sender: 'moi', text: '...', time: '11:50', day: 7),
    Msg(sender: 'maman', text: 'Tu rentres ce soir ?', time: '12:42', day: 7),
    Msg(
      sender: 'maman',
      text: 'Ne réponds pas tout de suite. Quand tu peux.',
      time: '14:08',
      day: 7,
    ),
    Msg(sender: 'maman', text: 'Tu manges ?', time: '19:18', day: 7),
    Msg(
      sender: 'maman',
      text:
          'Il y a des nuits où je préfère ne pas dormir pour pouvoir t\'écouter respirer. '
          'Tu n\'es pas là ce soir. Je dormirai mal.',
      time: '23:14',
      day: 7,
    ),

    // ── J8 — Signature notariale 14 pages ──────────────────────
    Msg(sender: 'maman', text: 'Bonjour.', time: '08:14', day: 8),
    Msg(sender: 'maman', text: 'Tu manges ?', time: '12:32', day: 8),
    Msg(
      sender: 'maman',
      text: 'Camille a appelé. Elle ne dit rien.',
      time: '16:42',
      day: 8,
    ),
    Msg(sender: 'maman', text: 'Ce silence est trop long.', time: '21:14', day: 8),
    Msg(
      sender: 'maman',
      text: 'Je vais dormir. Réponds quand tu peux.',
      time: '22:48',
      day: 8,
    ),

    // ── J9 — Emménagement Avenue Foch ──────────────────────────
    Msg(
      sender: 'maman',
      text: 'Tu n\'as pas dormi à la maison.',
      time: '08:14',
      day: 9,
    ),
    Msg(sender: 'maman', text: 'Tu vas où ?', time: '12:48', day: 9),
    Msg(
      sender: 'maman',
      text: 'Camille m\'a dit que tu déménages quelque temps.',
      time: '17:32',
      day: 9,
    ),
    Msg(sender: 'moi', text: 'Oui pour un dossier.', time: '17:38', day: 9),
    Msg(
      sender: 'maman',
      text: 'Un dossier qui prend l\'appartement ?',
      time: '17:48',
      day: 9,
    ),
    Msg(
      sender: 'maman',
      text: 'Tes affaires sont là si tu reviens.',
      time: '21:48',
      day: 9,
    ),
    Msg(sender: 'maman', text: 'Dors bien.', time: '22:14', day: 9),

    // ── J10 — Premier jour absente ─────────────────────────────
    Msg(sender: 'maman', text: 'Bonjour.', time: '07:18', day: 10),
    Msg(sender: 'maman', text: 'Tu manges ?', time: '12:42', day: 10),
    Msg(
      sender: 'maman',
      text: 'Le frigo est plein. Personne pour le finir.',
      time: '18:48',
      day: 10,
    ),
    Msg(sender: 'maman', text: 'Tu reviens dimanche ?', time: '21:14', day: 10),
    Msg(sender: 'moi', text: 'Je sais pas encore Maman.', time: '21:22', day: 10),
    Msg(sender: 'maman', text: 'D\'accord.', time: '21:24', day: 10),

    // ── J11 — Premier mensonge « Lao Chen, paysagiste » ────────
    Msg(sender: 'maman', text: 'Bonjour ma fille.', time: '07:42', day: 11),
    Msg(sender: 'maman', text: 'Premier jour de quoi exactement ?', time: '12:14', day: 11),
    Msg(sender: 'moi', text: 'Stage paysagiste. Lao Chen.', time: '12:15', day: 11),
    Msg(
      sender: 'maman',
      text: 'Tu ne m\'as pas dit que tu changeais de métier.',
      time: '12:32',
      day: 11,
    ),
    Msg(sender: 'maman', text: 'Tu as eu une bonne journée ?', time: '17:48', day: 11),
    Msg(
      sender: 'maman',
      text: 'Premier jour de stage. Comment ça s\'est passé ?',
      time: '21:08',
      day: 11,
    ),
    Msg(
      sender: 'maman',
      text:
          '« Bien. » Tu écris « bien » depuis trois jours. Donne-moi un détail.',
      time: '21:10',
      day: 11,
      beatId: 'maman_stage_j11',
    ),

    // ── J12 — Maman cherche dans l'annuaire ────────────────────
    Msg(sender: 'maman', text: 'Bonjour. Mal dormi.', time: '08:14', day: 12),
    Msg(sender: 'maman', text: 'Tu manges où ?', time: '12:48', day: 12),
    Msg(
      sender: 'maman',
      text:
          'J\'ai cherché Lao Chen dans l\'annuaire. Aucun résultat. '
          'C\'est un petit cabinet ?',
      time: '14:24',
      day: 12,
      requiresSuspicionAtLeast: 30,
    ),
    Msg(
      sender: 'maman',
      text: 'Camille a refusé de me dire où tu vis.',
      time: '17:18',
      day: 12,
      requiresSuspicionAtLeast: 30,
    ),
    Msg(
      sender: 'maman',
      text: 'Je crois que je sais. Je préfère me tromper.',
      time: '19:42',
      day: 12,
      requiresSuspicionAtLeast: 30,
    ),

    // ── J13 — Parfum différent ─────────────────────────────────
    Msg(sender: 'maman', text: 'Bonjour.', time: '08:32', day: 13),
    Msg(sender: 'maman', text: 'Tu manges ?', time: '12:18', day: 13),
    Msg(
      sender: 'maman',
      text:
          'Tu portes un parfum différent quand tu passes. Je ne te juge pas. '
          'Je te le dis.',
      time: '18:42',
      day: 13,
      requiresSuspicionAtLeast: 30,
    ),
    Msg(
      sender: 'maman',
      text: 'Tu as oublié de m\'apporter des fleurs ce matin. '
          'C\'est la première fois en quatre mois.',
      time: '17:48',
      day: 13,
      requiresSuspicionAtLeast: 30,
    ),

    // ── J14 — Dîner Madame Heng. Long Jing deuxième récolte. ──
    Msg(sender: 'maman', text: 'Bonjour.', time: '09:32', day: 14),
    Msg(sender: 'maman', text: 'Tu as un dîner important ce soir ?', time: '14:18', day: 14),
    Msg(sender: 'moi', text: 'Pas spécial.', time: '14:19', day: 14),
    Msg(
      sender: 'maman',
      text: 'Je sens quelque chose. Tu peux mentir si tu veux. Je ne te juge pas.',
      time: '14:32',
      day: 14,
    ),
    Msg(
      sender: 'maman',
      text: 'Bon courage pour ton dîner.',
      time: '19:42',
      day: 14,
    ),
    Msg(
      sender: 'maman',
      text: 'J\'ai mis ta part au frigo si tu rentres.',
      time: '22:48',
      day: 14,
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
    Msg(sender: 'camille', text: 'Shen. 18 000. Ta mère.', time: '14:03', day: 4),
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
          'Tu vas plaider ta propre cause. Habille-toi comme telle.',
      time: '17:43',
      day: 6,
    ),
    Msg(
      sender: 'camille',
      text: 'Et révise ton mandarin. Au cas où il y bascule.',
      time: '17:44',
      day: 6,
      beatId: 'camille_tailleur_j6',
    ),
    // J8 — Après la signature, Camille devine
    Msg(
      sender: 'camille',
      text: 'Tu as signé. Je le sens.',
      time: '13:15',
      day: 8,
    ),
    Msg(
      sender: 'camille',
      text: 'Je ne te demande pas combien. Je te demande comment tu vas.',
      time: '13:16',
      day: 8,
    ),
    // J13 — Préparation dîner Madame Heng
    Msg(
      sender: 'camille',
      text: 'Dîner Madame Heng jeudi ? Tu y vas comment ?',
      time: '15:08',
      day: 13,
    ),
    Msg(
      sender: 'camille',
      text:
          'Mauvaise question. La vraie c\'est : QUEL THÉ ?',
      time: '15:09',
      day: 13,
      beatId: 'camille_quel_the_j13',
    ),
    // J14 — Après le dîner, Camille n'attend pas le matin.
    Msg(
      sender: 'camille',
      text: 'Alors ?',
      time: '23:14',
      day: 14,
    ),
    Msg(
      sender: 'camille',
      text:
          'Tu m\'écris pas. C\'est jamais bon signe.',
      time: '23:38',
      day: 14,
    ),
  ],
  'tristan': [
    // J7 — premier contact via la secrétaire
    Msg(
      sender: 'tristan',
      text:
          'Heng International. Mlle Marchand. Jeudi 11h, 47e étage, Tour Heng. Confirmez ?',
      time: '14:12',
      day: 6,
      beatId: 'tristan_rdv_j6',
    ),
    // J9 — premier SMS après emménagement
    Msg(
      sender: 'tristan',
      text:
          'Penderie partagée, salle de bain attenante pour vous. Bureau pour moi. Réaménagez à votre goût.',
      time: '17:22',
      day: 9,
    ),
    // J14 — après le dîner Madame Heng, cliffhanger Ep 1
    Msg(
      sender: 'tristan',
      text:
          'Elle ne dit « ma fille » qu\'aux personnes qu\'elle compte '
          'garder. Ou écraser.',
      time: '22:48',
      day: 14,
    ),
  ],
  'madame_heng': [
    // J12 — Première parole directe : sentencieuse, formelle, références
    Msg(
      sender: 'madame_heng',
      text:
          'Mademoiselle Marchand. Mon fils m\'a transmis votre numéro. '
          'Jeudi, le couvert sera mis à 20h30. Le thé sera servi au salon.',
      time: '09:42',
      day: 12,
    ),
    Msg(
      sender: 'madame_heng',
      text:
          'Mon fils n\'apporte rien. Vous non plus. C\'est la tradition.',
      time: '09:43',
      day: 12,
    ),
    Msg(
      sender: 'moi',
      text: 'Bien noté. Merci Madame.',
      time: '10:08',
      day: 12,
    ),
    Msg(
      sender: 'madame_heng',
      text:
          'On ne dit pas « bien noté » à une mère, mademoiselle. '
          'On dit « entendu ».',
      time: '10:09',
      day: 12,
    ),
    // J13 — relance sur le thé (donne du sens au choix Camille B13)
    Msg(
      sender: 'madame_heng',
      text:
          'À demain. J\'ouvre la boîte verte. Vous saurez laquelle quand '
          'vous la verrez.',
      time: '21:08',
      day: 13,
    ),
  ],
  'banque': [
    Msg(
      sender: 'banque',
      text:
          'BNP : 50 € sur votre compte mardi grâce à notre offre parrainage. Code PARRAIN-2026. STOP au 36173.',
      time: '06:12',
      day: 1,
    ),
    Msg(
      sender: 'banque',
      text:
          'INFO BNP : votre demande de crédit personnel n°7842 a été REFUSÉE. Motif : pas de garant éligible. Détails sur l\'app.',
      time: '14:23',
      day: 3,
    ),
    // Idée 11 — Spam ironique 9h après le refus
    Msg(
      sender: 'banque',
      text:
          'BNP Paribas Jeunes — découvrez le PEA Avenir, à partir de 50 €/mois. '
          'Préparez votre avenir dès aujourd\'hui ! STOP au 36173.',
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
          'Course #14872 — Bowl Açaí — Avenue Montaigne. Acceptez dans 30 s. 8,40 €.',
      time: '07:52',
      day: 1,
    ),
    Msg(
      sender: 'plateforme',
      text:
          'INCIDENT — Course #14872 marquée comme non livrée. Pénalité de 38,00 € appliquée sur la prochaine paie. Conseil : reprenez une course tout de suite.',
      time: '08:31',
      day: 1,
    ),
  ],
};
