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
    id: 'vincent_heng',
    displayName: 'Vincent Heng',
    emoji: '💼',
    avatarTint: '#F7E0CA',
    avatarPath: 'assets/photos/avatars/vincent.webp',
  ),
  MsgContact(
    id: 'madame_heng',
    displayName: 'Madame Heng',
    emoji: '🍵',
    avatarTint: '#E7E1D2',
    avatarPath: 'assets/photos/avatars/madame_heng.webp',
  ),
  MsgContact(
    id: 'tante_mei',
    displayName: 'Tante Mei',
    emoji: '🍊',
    avatarTint: '#F2E3C8',
    avatarPath: 'assets/photos/avatars/tante_mei.webp',
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

    // ── J9 — Emménagement rue de Berri ──────────────────────────
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
      text: 'Alors, ce stage ? Comment ça s\'est passé ?',
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
      text: 'Tu as oublié de m\'apporter des fleurs ce matin. '
          'C\'est la première fois en quatre mois.',
      time: '17:48',
      day: 13,
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

    // ── J23 — la boîte de Long Jing (Ep2, beat à choix) ──
    Msg(
      sender: 'maman',
      text: 'Ma fille, j\'ai rangé ton sac qui traînait depuis dimanche.',
      time: '19:12',
      day: 23,
    ),
    Msg(
      sender: 'maman',
      text:
          'Une boîte de thé en est tombée. Long Jing. Première récolte, '
          'dit le couvercle.',
      time: '19:14',
      day: 23,
    ),
    Msg(
      sender: 'maman',
      text:
          'C\'est un thé qui coûte une semaine de tes livraisons. Je le '
          'sais parce que ton grand-père en achetait une fois par an, '
          'pour le nouvel an.',
      time: '19:18',
      day: 23,
    ),
    Msg(
      sender: 'maman',
      text:
          'Je ne fouillais pas, je t\'assure. Excuse-moi. Mais dis-moi '
          'juste : qui t\'offre du thé d\'empereur ?',
      time: '19:32',
      day: 23,
      status: MsgStatus.delivered,
      beatId: 'maman_long_jing_j23',
    ),

    // ── J24 — après la visite : « le visage d'une fille amoureuse » ──
    Msg(
      sender: 'maman',
      text:
          'C\'était bien de t\'avoir ce soir. Tu as laissé ton écharpe, '
          'je te la garde.',
      time: '20:58',
      day: 24,
    ),
    Msg(
      sender: 'maman',
      text:
          'Tu avais le visage d\'une fille amoureuse qui ne veut pas '
          'l\'être.',
      time: '21:06',
      day: 24,
    ),
    Msg(
      sender: 'maman',
      text:
          'Je n\'ai pas dit que tu l\'étais. J\'ai dit que tu ne veux '
          'pas l\'être. Dis-moi si je me trompe.',
      time: '21:12',
      day: 24,
      status: MsgStatus.delivered,
      beatId: 'maman_devine_j24',
    ),

    // ── J39 — l'appel de 4h du matin (Tante Mei a parlé) ──
    Msg(
      sender: 'maman',
      text:
          'Je t\'ai appelée trois fois. Je sais qu\'il est tôt là-bas. '
          'Ou tard. Je ne sais plus.',
      time: '07:02',
      day: 39,
    ),
    Msg(
      sender: 'maman',
      text:
          'Une femme du Fujian m\'a écrit cette nuit. Mei. '
          'La sœur de ton père.',
      time: '07:05',
      day: 39,
    ),
    Msg(
      sender: 'maman',
      text:
          'Elle m\'a envoyé une photo de toi à Hong Kong. À la table de '
          'la famille Heng. Tu m\'avais dit Lyon, ma fille.',
      time: '07:09',
      day: 39,
    ),
    Msg(
      sender: 'maman',
      text:
          'Je ne suis pas en colère. Je suis perdue. Dis-moi où tu es. '
          'Dis-moi avec qui. Dis-moi pourquoi Lyon.',
      time: '07:14',
      day: 39,
      status: MsgStatus.delivered,
      beatId: 'maman_decouvre_j39',
    ),

    // ── J42 — la confrontation silencieuse, à trois mètres ──
    Msg(
      sender: 'maman',
      text: 'Tu es dans ma cuisine et je t\'écris. Nous en sommes là.',
      time: '11:02',
      day: 42,
    ),
    Msg(
      sender: 'maman',
      text:
          'J\'ai lu ce qu\'il y avait dans l\'enveloppe. Quatorze pages. '
          'Ton nom à côté du sien.',
      time: '11:06',
      day: 42,
    ),
    Msg(
      sender: 'maman',
      text:
          'Duras dit qu\'on écrit ce qu\'on ne peut pas dire. Je n\'avais '
          'jamais compris cette phrase avant ce matin.',
      time: '11:10',
      day: 42,
    ),
    Msg(
      sender: 'maman',
      text:
          'Une seule question, ma fille. L\'argent du traitement, c\'est '
          'son argent ? Réponds-moi ici, dans le silence. Après on '
          'parlera à voix haute.',
      time: '11:14',
      day: 42,
      status: MsgStatus.delivered,
      beatId: 'maman_confrontation_j42',
    ),

    // ── J69 — Hélène lit la lettre de Wenbo ──
    Msg(
      sender: 'maman',
      text: 'J\'ai fini de lire. Trois fois.',
      time: '20:40',
      day: 69,
    ),
    Msg(
      sender: 'maman',
      text:
          'Je l\'ai attendu jusqu\'en 2010. Après j\'ai arrêté de '
          'compter.',
      time: '20:48',
      day: 69,
    ),
    Msg(
      sender: 'maman',
      text:
          'Il ne m\'a pas oubliée une seule semaine, ma fille. Personne '
          'ne pourra m\'enlever d\'avoir été aimée comme ça.',
      time: '20:54',
      day: 69,
    ),
    Msg(
      sender: 'maman',
      text:
          'Viens dimanche. On la lira à voix haute, une fois, ensemble. '
          'Tu veux bien ?',
      time: '21:00',
      day: 69,
      status: MsgStatus.delivered,
      beatId: 'maman_lettre_j69',
    ),

    // ── J102 — le brasero de la cour, la 312e lettre ──
    Msg(
      sender: 'maman',
      text:
          'Je t\'ai vue au brasero ce soir. La fumée montait droit. '
          'Tante Mei dit que c\'est bon signe.',
      time: '20:52',
      day: 102,
    ),
    Msg(
      sender: 'maman',
      text: 'Tu lui as dit quoi, dans cette dernière lettre ?',
      time: '21:00',
      day: 102,
      status: MsgStatus.delivered,
      beatId: 'maman_312e_j102',
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
    Msg(sender: 'camille', text: 'TGV. Combien ?', time: '11:56', day: 1),
    Msg(sender: 'moi', text: 'Pénalité 38 €.', time: '11:58', day: 1),
    Msg(sender: 'camille', text: 'Donc tu as cassé un truc.', time: '11:58', day: 1),
    Msg(sender: 'moi', text: 'J\'ai pas cassé un truc, j\'ai vu un truc.', time: '11:59', day: 1),
    Msg(sender: 'camille', text: 'Tu m\'inquiètes.', time: '11:59', day: 1),
    Msg(sender: 'camille', text: 'Mais je vais quand même au boulot, désolée.', time: '12:00', day: 1),
    Msg(sender: 'camille', text: 'Bisous mon canard meurtri.', time: '12:01', day: 1),
    Msg(
      sender: 'camille',
      text: 'OK tu m\'as raconté à 22h, j\'ai cinq minutes pour réagir.',
      time: '22:14',
      day: 1,
    ),
    Msg(
      sender: 'camille',
      text: '« Une carte. Quatre morceaux. Dans la flaque. »\n'
          'Tu as un don pour les premières phrases de roman.',
      time: '22:15',
      day: 1,
    ),
    Msg(sender: 'camille', text: 'T. Heng. Tu sais ce que ça veut dire ?', time: '22:16', day: 1),
    Msg(sender: 'moi', text: 'Que mes économies vont jamais tenir jusqu\'au bout du mois.', time: '22:18', day: 1),
    Msg(sender: 'camille', text: 'Que tu pars au lit. Demain on parle.', time: '22:20', day: 1),
    // ── J2 — Tenon, Camille tape de loin
    Msg(sender: 'camille', text: 'Tu es à Tenon ?', time: '06:48', day: 2),
    Msg(sender: 'moi', text: 'Oui.', time: '06:50', day: 2),
    Msg(sender: 'camille', text: 'Tu rentres après, je passe avec un croissant.', time: '06:50', day: 2),
    Msg(sender: 'moi', text: 'Pas le temps. Plus tard.', time: '06:52', day: 2),
    Msg(sender: 'camille', text: 'Tu m\'envoies les chiffres après le rendez-vous.', time: '06:53', day: 2),
    Msg(
      sender: 'camille',
      text: 'Petit mantra du jour : tu n\'es pas un héros, t\'es une fille avec un téléphone.',
      time: '12:32',
      day: 2,
    ),
    Msg(sender: 'camille', text: 'Tu manges ?', time: '13:14', day: 2),
    Msg(sender: 'moi', text: 'Oui Maman.', time: '13:18', day: 2),
    Msg(sender: 'camille', text: 'Je rapporte. Maman / Camille tag-team.', time: '13:19', day: 2),
    Msg(
      sender: 'camille',
      text: '18 000 c\'est combien de croissants au beurre ?\n'
          'Trois mille. Manger ne te sauve pas mais ça t\'occupe.',
      time: '19:42',
      day: 2,
    ),
    Msg(
      sender: 'camille',
      text: 'Soir : je suis à un vernissage chiant. Tu veux que je vienne ?',
      time: '21:08',
      day: 2,
    ),
    Msg(sender: 'moi', text: 'Non vas-y, c\'est ton métier.', time: '21:14', day: 2),
    Msg(sender: 'camille', text: 'Mon métier c\'est aussi toi, idiote.', time: '21:15', day: 2),
    // ── J3 — Banque + numéro masqué
    Msg(sender: 'camille', text: 'Comment c\'est passé la BNP ?', time: '14:42', day: 3),
    Msg(sender: 'moi', text: 'Refus. Pas de garant.', time: '14:48', day: 3),
    Msg(sender: 'camille', text: 'Évidemment.', time: '14:48', day: 3),
    Msg(sender: 'camille', text: 'Aide sociale ?', time: '14:49', day: 3),
    Msg(sender: 'moi', text: 'Six mois minimum d\'instruction.', time: '14:50', day: 3),
    Msg(sender: 'camille', text: 'Donc.', time: '14:50', day: 3),
    Msg(sender: 'camille', text: 'La carte ?', time: '14:51', day: 3),
    Msg(sender: 'moi', text: 'Recollée. Scotch transparent.', time: '14:55', day: 3),
    Msg(
      sender: 'camille',
      text: 'Tu as gardé la carte d\'un homme que tu détestes. Tu m\'expliqueras.',
      time: '14:56',
      day: 3,
    ),
    Msg(
      sender: 'camille',
      text: 'Bon. Va dormir. Demain tu réfléchis.',
      time: '22:42',
      day: 3,
    ),
    Msg(
      sender: 'camille',
      text: 'Un truc : si jamais. Vraiment jamais. Tu m\'appelles.',
      time: '23:48',
      day: 3,
    ),
    // ── J4 — Camille pousse à rappeler
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
    Msg(
      sender: 'camille',
      text: 'Quoi que tu décides, tu m\'écris.',
      time: '18:42',
      day: 4,
    ),
    Msg(sender: 'camille', text: 'Et si tu te dégonfles, je viens te kidnapper.', time: '18:43', day: 4),
    // ── J5 — Week-end, dimanche dumplings raté
    Msg(sender: 'camille', text: 'T\'es où ce week-end ?', time: '11:14', day: 5),
    Msg(sender: 'moi', text: 'Belleville. Avec Maman.', time: '11:18', day: 5),
    Msg(sender: 'camille', text: 'Bien. Embrasse-la.', time: '11:18', day: 5),
    Msg(
      sender: 'camille',
      text: 'J\'ai croisé Mathieu B. dimanche. Il rentre de Tokyo. Tu te rappelles ?',
      time: '17:08',
      day: 5,
    ),
    Msg(sender: 'moi', text: 'Oui je me rappelle.', time: '17:14', day: 5),
    Msg(sender: 'camille', text: 'Bon. Je dis rien. Mais il est joli, le bougre.', time: '17:14', day: 5),
    Msg(
      sender: 'camille',
      text: 'Tu vas vraiment rester sur "non" pour Heng ? Réfléchis encore 24h.',
      time: '21:42',
      day: 5,
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
    Msg(
      sender: 'camille',
      text: 'Tu lui tiens tête. Tu ne signes rien.\nPromets-moi.',
      time: '22:48',
      day: 6,
    ),
    Msg(sender: 'moi', text: 'Promis.', time: '22:50', day: 6),
    Msg(sender: 'camille', text: 'Menteuse.', time: '22:50', day: 6),
    Msg(sender: 'camille', text: 'Bonne nuit ma poule.', time: '22:51', day: 6),
    // ── J7 — Tour Heng, proposition trois mois
    Msg(sender: 'camille', text: 'Comment tu te sens ?', time: '08:14', day: 7),
    Msg(sender: 'camille', text: 'Mets le rouge de ma mère, ça te tient.', time: '08:32', day: 7),
    Msg(sender: 'camille', text: 'Tu m\'écris dès que tu sors.', time: '09:14', day: 7),
    Msg(sender: 'camille', text: 'Alors ?', time: '12:32', day: 7),
    Msg(sender: 'camille', text: 'Shen.', time: '13:18', day: 7),
    Msg(sender: 'camille', text: 'Tu réponds quand ?', time: '14:48', day: 7),
    Msg(sender: 'moi', text: 'Trois mois. Trente mille.', time: '15:14', day: 7),
    Msg(sender: 'camille', text: 'PUTAIN.', time: '15:14', day: 7),
    Msg(sender: 'camille', text: 'Quoi exactement ?', time: '15:15', day: 7),
    Msg(sender: 'moi', text: 'Fausse fiancée. 14 pages. Signature demain.', time: '15:16', day: 7),
    Msg(sender: 'camille', text: 'Tu lis chaque clause avant. CHAQUE clause.', time: '15:17', day: 7),
    Msg(sender: 'camille', text: 'Je viens avec toi chez le notaire si tu veux.', time: '15:18', day: 7),
    Msg(sender: 'moi', text: 'Il a dit que c\'était discret.', time: '15:19', day: 7),
    Msg(sender: 'camille', text: 'Évidemment.', time: '15:19', day: 7),
    Msg(
      sender: 'camille',
      text: 'Bon. Tu fais ça. Mais tu me promets une chose : tu sors quand tu veux. '
          'Pas dans trois mois. Quand TU veux.',
      time: '20:14',
      day: 7,
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
    Msg(sender: 'moi', text: 'Pas terrible.', time: '13:42', day: 8),
    Msg(sender: 'camille', text: 'Tu veux que je passe ?', time: '13:42', day: 8),
    Msg(sender: 'moi', text: 'Pas ce soir.', time: '13:43', day: 8),
    Msg(sender: 'camille', text: 'OK. Demain je passe sans demander.', time: '13:44', day: 8),
    Msg(
      sender: 'camille',
      text: 'En attendant : mange un truc qui n\'est pas une protéine en barre. '
          'C\'est un ordre.',
      time: '13:45',
      day: 8,
    ),
    // ── J9 — Emménagement rue de Berri
    Msg(sender: 'camille', text: 'Tu emménages aujourd\'hui ?', time: '15:42', day: 9),
    Msg(sender: 'moi', text: 'Oui 17h.', time: '15:48', day: 9),
    Msg(sender: 'camille', text: 'rue de Berri.', time: '15:48', day: 9),
    Msg(sender: 'moi', text: 'Oui.', time: '15:49', day: 9),
    Msg(sender: 'camille', text: 'Putain.', time: '15:49', day: 9),
    Msg(sender: 'camille', text: 'Tu prends quoi avec toi ?', time: '15:50', day: 9),
    Msg(sender: 'moi', text: 'Trois affaires.', time: '15:51', day: 9),
    Msg(sender: 'camille', text: 'Trois ? Tu pars trois mois !', time: '15:51', day: 9),
    Msg(sender: 'moi', text: 'Trois.', time: '15:52', day: 9),
    Msg(sender: 'camille', text: 'OK je vois. Tu gardes la maison de Belleville comme un fantôme.', time: '15:53', day: 9),
    Msg(sender: 'camille', text: 'Ta mère a appelé pour le bail. Tu sais ?', time: '22:14', day: 9),
    Msg(sender: 'moi', text: 'Non. Elle a dit quoi ?', time: '22:18', day: 9),
    Msg(sender: 'camille', text: 'Elle a demandé si tu déménageais. J\'ai dit « temporairement ».', time: '22:19', day: 9),
    Msg(sender: 'moi', text: 'Merci.', time: '22:22', day: 9),
    Msg(
      sender: 'camille',
      text: 'Je vais pas mentir à ta mère longtemps. Tu sais que je sais pas. '
          'Et elle sait que je sais pas.',
      time: '22:23',
      day: 9,
    ),
    // ── J10 — Une journée vide à Berri
    Msg(sender: 'camille', text: 'Comment tu trouves ?', time: '11:14', day: 10),
    Msg(sender: 'moi', text: 'Acheté.', time: '11:18', day: 10),
    Msg(sender: 'camille', text: 'Belle réponse pour un futur livre.', time: '11:19', day: 10),
    Msg(sender: 'camille', text: 'Tu l\'as revu ?', time: '17:42', day: 10),
    Msg(sender: 'moi', text: 'Croisé deux fois dans le couloir.', time: '17:48', day: 10),
    Msg(sender: 'camille', text: 'Qu\'est-ce qu\'il a dit ?', time: '17:48', day: 10),
    Msg(sender: 'moi', text: '« Bonjour Mlle Marchand. »', time: '17:49', day: 10),
    Msg(sender: 'camille', text: 'Charmant.', time: '17:50', day: 10),
    Msg(sender: 'camille', text: 'Je te kidnappe samedi matin. Croissant chez moi.', time: '21:14', day: 10),
    // ── J11 — Mensonge Lao Chen
    Msg(sender: 'camille', text: 'Tu as dit QUOI à ta mère ?', time: '22:14', day: 11),
    Msg(sender: 'moi', text: 'Stage paysagiste. Lao Chen.', time: '22:18', day: 11),
    Msg(sender: 'camille', text: 'LOL.', time: '22:18', day: 11),
    Msg(sender: 'camille', text: 'Lao Chen. Comme dans « vieux Chen ». Tu te fous d\'elle.', time: '22:19', day: 11),
    Msg(sender: 'moi', text: 'J\'avais besoin d\'un nom vite.', time: '22:20', day: 11),
    Msg(sender: 'camille', text: 'Elle va chercher dans l\'annuaire, prépare-toi.', time: '22:21', day: 11),
    // ── J12 — Maman cherche, Camille refuse de mentir
    Msg(sender: 'camille', text: 'Elle a cherché Lao Chen.', time: '15:42', day: 12),
    Msg(sender: 'moi', text: 'Je sais.', time: '15:48', day: 12),
    Msg(sender: 'camille', text: 'Et elle m\'a demandé où tu vivais.', time: '15:48', day: 12),
    Msg(sender: 'moi', text: 'Tu as dit quoi ?', time: '15:49', day: 12),
    Msg(sender: 'camille', text: 'J\'ai dit rien. J\'ai dit que je savais pas.', time: '15:50', day: 12),
    Msg(sender: 'moi', text: 'Merci Camille.', time: '15:51', day: 12),
    Msg(
      sender: 'camille',
      text: 'C\'est pas un service que je te fais. C\'est un service que je me '
          'fais pas à elle. Différence.',
      time: '15:52',
      day: 12,
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
    Msg(sender: 'camille', text: 'Tu as révisé les thés ?', time: '18:42', day: 13),
    Msg(sender: 'moi', text: 'Long Jing première, Tieguanyin, Da Hong Pao, Pu\'er.', time: '18:48', day: 13),
    Msg(sender: 'camille', text: 'Long Jing première récolte vs deuxième ?', time: '18:48', day: 13),
    Msg(sender: 'moi', text: 'Première : pré-Qingming, plus tendres. Deuxième : après, plus charnues.', time: '18:50', day: 13),
    Msg(sender: 'camille', text: 'Bien ma poule. Tu vas la séduire.', time: '18:51', day: 13),
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

    // ── J26 — treize jours de silence (Ep2, beat à choix) ──
    Msg(
      sender: 'camille',
      text: 'T\'es vivante ?',
      time: '21:58',
      day: 26,
    ),
    Msg(
      sender: 'camille',
      text:
          'Je demande parce que ton dernier message date d\'il y a treize '
          'jours. J\'ai compté. Enfin, mon boulanger a compté.',
      time: '22:02',
      day: 26,
    ),
    Msg(
      sender: 'camille',
      text:
          'Il met un croissant de côté tous les matins « pour ton '
          'amie ». Il commence à me regarder avec pitié.',
      time: '22:07',
      day: 26,
    ),
    Msg(
      sender: 'camille',
      text:
          'Sérieux, Shen. Treize jours. Je dis pas ça pour te '
          'culpabiliser. Si. Un peu.',
      time: '22:14',
      day: 26,
      status: MsgStatus.delivered,
      beatId: 'camille_distance_j26',
    ),

    // ── J29 — le passeport introuvable, départ jeudi ──
    Msg(
      sender: 'camille',
      text:
          'Alors comme ça mademoiselle part à Hong Kong. En business. '
          'Avec un homme. Que sa mère adore.',
      time: '10:22',
      day: 29,
    ),
    Msg(
      sender: 'camille',
      text:
          'Question logistique de ta directrice de cabinet : t\'as un '
          'passeport VALIDE au moins ?',
      time: '10:30',
      day: 29,
      status: MsgStatus.delivered,
      beatId: 'camille_passeport_j29',
    ),

    // ── J38 — la robe bleu nuit (essayage à HK) ──
    Msg(
      sender: 'camille',
      text: 'C\'est ce soir l\'essayage de la robe du gala non ?',
      time: '18:54',
      day: 38,
    ),
    Msg(
      sender: 'camille',
      text: 'Photo. MAINTENANT. C\'est non négociable.',
      time: '19:00',
      day: 38,
      status: MsgStatus.delivered,
      beatId: 'camille_robe_j38',
    ),

    // ── J53 — le dossier de Shanghai (SMS de la secrétaire transféré) ──
    Msg(
      sender: 'camille',
      text:
          'Attends. La secrétaire de Tristan t\'a envoyé ÇA par erreur ? '
          '« Le dossier de Shanghai est arrivé au bureau de M. Heng. »',
      time: '09:32',
      day: 53,
    ),
    Msg(
      sender: 'camille',
      text:
          'Shen. C\'est le dossier avec le nom de ta mère dedans. '
          'Tu fais quoi ?',
      time: '09:40',
      day: 53,
      status: MsgStatus.delivered,
      beatId: 'camille_dossier_j53',
    ),

    // ── J112 — le choix final : bus, avion, ou ni l'un ni l'autre ──
    Msg(
      sender: 'camille',
      text:
          'Il paraît que le bus pour Xiamen passe à 11h. Et que l\'avion '
          'pour Paris décolle à 17h.',
      time: '07:02',
      day: 112,
    ),
    Msg(
      sender: 'camille',
      text:
          'Je dis ça, je surveille pas tes horaires. Si. Ton téléphone '
          'me manque. Toi aussi, accessoirement.',
      time: '07:05',
      day: 112,
    ),
    Msg(
      sender: 'camille',
      text:
          'Quoi que tu choisisses, je gère les croissants. À Paris j\'en '
          'ai. À Xiamen j\'en apporte. À Hong Kong j\'en invente.',
      time: '07:09',
      day: 112,
    ),
    Msg(
      sender: 'camille',
      text: 'Alors, ma poule. Tu emportes quoi ?',
      time: '07:14',
      day: 112,
      status: MsgStatus.delivered,
      beatId: 'epilogue_j112',
    ),
  ],
  'tristan': [
    // J6 — Premier contact via la secrétaire (sec, formel)
    Msg(
      sender: 'tristan',
      text:
          'Heng International. Mlle Marchand. Jeudi 11h, 47e étage, Tour Heng. Confirmez ?',
      time: '14:12',
      day: 6,
      beatId: 'tristan_rdv_j6',
    ),
    Msg(
      sender: 'tristan',
      text: 'Badge à mon nom à l\'accueil. Pas de retard.',
      time: '14:14',
      day: 6,
    ),
    // J7 — Le RDV, post-proposition trois mois (très sec)
    Msg(sender: 'tristan', text: 'Vous étiez précise.', time: '13:08', day: 7),
    Msg(sender: 'tristan', text: 'Signature demain 11h30. Étude Vidal, rue de Sèze.', time: '17:14', day: 7),
    Msg(sender: 'moi', text: 'Reçu.', time: '17:32', day: 7),
    Msg(
      sender: 'tristan',
      text: 'Lisez l\'article 14 deux fois.',
      time: '23:08',
      day: 7,
    ),
    // J8 — Jour de la signature
    Msg(sender: 'tristan', text: 'Voiture à 11h00. Discrète.', time: '09:48', day: 8),
    Msg(sender: 'tristan', text: 'Je serai déjà sur place.', time: '11:04', day: 8),
    Msg(
      sender: 'tristan',
      text: 'Vous avez tremblé sur le « M ». Personne n\'a vu.',
      time: '15:42',
      day: 8,
    ),
    Msg(
      sender: 'tristan',
      text: 'Premier virement crédité demain matin. 10 000 €.',
      time: '20:14',
      day: 8,
    ),
    Msg(sender: 'moi', text: 'Compris.', time: '20:18', day: 8),
    // J9 — Emménagement rue de Berri
    Msg(
      sender: 'tristan',
      text:
          'Penderie partagée, salle de bain attenante pour vous. Bureau pour moi. Réaménagez à votre goût.',
      time: '17:22',
      day: 9,
    ),
    Msg(sender: 'tristan', text: 'Code porte 4297. Code parking B12.', time: '17:24', day: 9),
    Msg(sender: 'tristan', text: 'Aucun étage n\'est interdit. Personne ne sera surprise.', time: '17:26', day: 9),
    Msg(sender: 'moi', text: 'Merci.', time: '19:48', day: 9),
    Msg(
      sender: 'tristan',
      text: 'Demain 19h, dîner cabinet avec mon frère Vincent. '
          'Vous n\'êtes pas obligée d\'y être.',
      time: '22:14',
      day: 9,
    ),
    Msg(sender: 'moi', text: 'Je viens.', time: '22:18', day: 9),
    Msg(sender: 'tristan', text: 'Bonne nuit Mlle Marchand.', time: '22:32', day: 9),
    // J10 — Premier vrai jour ensemble
    Msg(
      sender: 'tristan',
      text: 'Robe bleu nuit dans la penderie. 38. Pour ce soir.',
      time: '14:48',
      day: 10,
    ),
    Msg(sender: 'moi', text: 'Je porte ce que je veux.', time: '14:52', day: 10),
    Msg(sender: 'tristan', text: 'Bien.', time: '14:53', day: 10),
    Msg(
      sender: 'tristan',
      text: 'Vincent fait de l\'humour. Ne le prenez pas au sérieux. '
          'Ne le contredisez pas non plus.',
      time: '18:42',
      day: 10,
    ),
    // J11 — Routine froide
    Msg(sender: 'tristan', text: 'Petit déjeuner à 7h30. Si vous voulez.', time: '07:08', day: 11),
    Msg(
      sender: 'tristan',
      text: 'Mes parents passent jeudi. Préparez-vous.',
      time: '19:32',
      day: 11,
    ),
    Msg(sender: 'moi', text: 'OK.', time: '19:48', day: 11),
    // J12 — Madame Heng entre en scène
    Msg(
      sender: 'tristan',
      text: 'Ma mère vous a écrit. Répondez sobrement.',
      time: '09:38',
      day: 12,
    ),
    Msg(
      sender: 'tristan',
      text: 'Elle teste. Toujours.',
      time: '09:39',
      day: 12,
    ),
    Msg(sender: 'moi', text: 'Compris.', time: '10:08', day: 12),
    // J13 — Veille du dîner
    Msg(
      sender: 'tristan',
      text: 'Demain 20h30. Premier dîner officiel. '
          'Vous serez assise à droite de ma mère.',
      time: '18:32',
      day: 13,
    ),
    Msg(sender: 'tristan', text: 'Mon père ne parlera pas. C\'est normal.', time: '18:33', day: 13),
    Msg(sender: 'tristan', text: 'Mon oncle parlera trop. C\'est normal aussi.', time: '18:34', day: 13),
    Msg(sender: 'moi', text: 'Et toi ?', time: '18:48', day: 13),
    Msg(sender: 'tristan', text: 'Je ne dirai rien.', time: '18:49', day: 13),
    // J14 — Dîner Madame Heng, cliffhanger
    Msg(sender: 'tristan', text: 'Vous êtes prête ?', time: '20:08', day: 14),
    Msg(sender: 'moi', text: 'Oui.', time: '20:12', day: 14),
    Msg(
      sender: 'tristan',
      text:
          'Elle ne dit « ma fille » qu\'aux personnes qu\'elle compte '
          'garder. Ou écraser.',
      time: '22:48',
      day: 14,
    ),

    // ── J52 — la fin du contrat, annoncée par écrit (Ep4, beat à choix) ──
    Msg(
      sender: 'tristan',
      text: 'Le conseil a voté ce matin. Vincent a perdu.',
      time: '17:54',
      day: 52,
    ),
    Msg(
      sender: 'tristan',
      text:
          'Le contrat prévoyait une sortie au versement final. '
          'Le virement part demain.',
      time: '17:58',
      day: 52,
    ),
    Msg(
      sender: 'tristan',
      text: 'Vous êtes libre. C\'est la clause 21. Je la respecte.',
      time: '18:03',
      day: 52,
    ),
    Msg(
      sender: 'tristan',
      text: 'Dites-moi ce que vous voulez faire.',
      time: '18:08',
      day: 52,
      status: MsgStatus.delivered,
      beatId: 'tristan_fin_contrat_j52',
    ),

    // ── J95 — depuis le Fujian : la question simple (premier tutoiement) ──
    Msg(
      sender: 'tristan',
      text:
          'Camille me dit que vous allez bien. Je n\'ai rien demandé. '
          'Elle me l\'a dit quand même.',
      time: '10:48',
      day: 95,
    ),
    Msg(
      sender: 'tristan',
      text:
          'Le bureau est calme. Vincent est à Genève. Ma tante demande '
          'de vos nouvelles à chaque thé.',
      time: '10:53',
      day: 95,
    ),
    Msg(
      sender: 'tristan',
      text:
          'Je ne sais pas écrire ces choses. Alors je pose la question '
          'simple.',
      time: '10:57',
      day: 95,
    ),
    Msg(
      sender: 'tristan',
      text: 'Tu reviens ?',
      time: '11:00',
      day: 95,
      status: MsgStatus.delivered,
      beatId: 'tristan_revient_j95',
    ),
  ],
  'vincent_heng': [
    // ── J10 — Premier SMS post-emménagement
    Msg(
      sender: 'vincent_heng',
      text: 'Tristan m\'a parlé de toi. Welcome aux Heng officiel ce soir. '
          'Mets ce qui te plaît — pas ce qui plaît à ma mère.',
      time: '14:48',
      day: 10,
    ),
    Msg(
      sender: 'vincent_heng',
      text: 'Tu sais boire le vin. Bonne soirée.',
      time: '22:48',
      day: 10,
    ),
    // ── J12 — Closing
    Msg(
      sender: 'vincent_heng',
      text: 'Closing demain. Si Tristan dort 4h cette nuit c\'est normal.',
      time: '20:18',
      day: 12,
    ),
    // ── J14 — Post-Long Jing
    Msg(
      sender: 'vincent_heng',
      text: 'Tu as géré le Long Jing. Respect. Ma mère ne dit jamais « ma fille » pour rien.',
      time: '22:42',
      day: 14,
    ),
    // ── J15 — Lendemain
    Msg(
      sender: 'vincent_heng',
      text: 'Ma mère t\'aime déjà plus que moi. C\'est ridicule.',
      time: '09:14',
      day: 15,
    ),
    // ── J18 — Vincent qui flirte légèrement
    Msg(
      sender: 'vincent_heng',
      text: 'Tu fais quoi ce soir, sans Tristan ?',
      time: '21:32',
      day: 18,
    ),
    Msg(sender: 'moi', text: 'Pas grand-chose, Vincent.', time: '21:38', day: 18),
    Msg(
      sender: 'vincent_heng',
      text: 'Si tu changes d\'avis je suis au Park Hyatt jusqu\'à minuit.',
      time: '21:39',
      day: 18,
    ),
    // ── J19 — Excuses
    Msg(
      sender: 'vincent_heng',
      text: 'Pardon pour hier. J\'avais trop bu. Tristan n\'en saura rien.',
      time: '23:48',
      day: 19,
    ),
    // ── J22 — Acompte tombé
    Msg(
      sender: 'vincent_heng',
      text: 'L\'acompte est tombé. Si tu veux investir un peu, je peux te conseiller. '
          'On a un fonds family office qui prend les jeunes.',
      time: '11:08',
      day: 22,
    ),
    // ── J25 — Conseil
    Msg(
      sender: 'vincent_heng',
      text: 'Je t\'avais dit que ce serait dur. Tiens bon.',
      time: '14:32',
      day: 25,
    ),
    // ── J28 — Invitation
    Msg(
      sender: 'vincent_heng',
      text: 'Tristan et moi on dîne ce soir, Saint-Honoré. Tu viens ?',
      time: '19:08',
      day: 28,
    ),
    // ── J30 — Post-gala
    Msg(
      sender: 'vincent_heng',
      text: 'Tu étais magnifique au gala. Ma mère est en colère contre tout le monde sauf toi.',
      time: '23:48',
      day: 30,
    ),
    // ── J32 — Vol HK
    Msg(
      sender: 'vincent_heng',
      text: 'T\'embarque à HK avec Tristan ? OK. Bon voyage.\n'
          'Petit conseil : Repulse Bay au coucher, pas avant.',
      time: '06:14',
      day: 32,
    ),
    // ── J35 — Pendant HK
    Msg(
      sender: 'vincent_heng',
      text: 'À HK. Tu rentres quand ?',
      time: '11:48',
      day: 35,
    ),
    // ── J38 — Tristan ivre Lan Kwai Fong
    Msg(
      sender: 'vincent_heng',
      text: 'Tristan est ivre au Lan Kwai Fong. Notre chauffeur vient le chercher. '
          'Reste à l\'hôtel.',
      time: '03:14',
      day: 38,
    ),
    Msg(sender: 'moi', text: 'Tu es à HK ?', time: '03:18', day: 38),
    Msg(
      sender: 'vincent_heng',
      text: 'Non. Je connais nos chauffeurs. J\'ai géré à distance.',
      time: '03:20',
      day: 38,
    ),
    // ── J40 — Retour
    // ── J39 — le poison au bar de l'hôtel ──
    Msg(
      sender: 'vincent_heng',
      text:
          'Dure journée on dirait. Un verre en bas ? Cinq minutes. '
          'J\'ai une information qui te concerne.',
      time: '21:12',
      day: 39,
    ),
    Msg(
      sender: 'vincent_heng',
      text:
          'Bon, je te le dis ici alors. Mon frère a eu trois fiancées '
          'contractuelles avant toi. Tu es la quatrième.',
      time: '21:34',
      day: 39,
    ),
    Msg(
      sender: 'vincent_heng',
      text: 'Je dis ça, je dis rien. Deal with it comme tu veux.',
      time: '21:40',
      day: 39,
      status: MsgStatus.delivered,
      beatId: 'vincent_quatrieme_j39',
    ),

    Msg(
      sender: 'vincent_heng',
      text: 'Vol retour aujourd\'hui je crois. Vous vous parlez peu, Tristan et toi ?',
      time: '20:48',
      day: 40,
    ),
    // ── J45 — Contrat bientôt fini
    Msg(
      sender: 'vincent_heng',
      text: 'Le contrat se termine bientôt. Tu réfléchis à la suite ? '
          'Ma mère a une idée. Pas la mienne.',
      time: '11:08',
      day: 45,
    ),
    // ── J52 — Fin contrat
    Msg(
      sender: 'vincent_heng',
      text: 'Si tu pars de l\'appart, tu peux le dire à ma mère ? '
          'Tristan ne sait pas comment.',
      time: '18:42',
      day: 52,
    ),
    // ── J60 — Ma mère parle encore
    Msg(
      sender: 'vincent_heng',
      text: 'Ma mère parle encore de toi. Une fois par semaine. Toujours en disant « ma fille ».',
      time: '22:18',
      day: 60,
    ),
    // ── J78 — Tante Mei Fujian
    Msg(
      sender: 'vincent_heng',
      text: 'Tante Mei t\'invite à Fujian. Tu y vas avec ta mère ? '
          'J\'ai un cousin à Xiamen qui peut vous chercher à l\'aéroport. Dis le mot.',
      time: '14:48',
      day: 78,
    ),
    // ── J95 — Tristan a perdu le contrôle
    Msg(
      sender: 'vincent_heng',
      text: 'Tristan a perdu le contrôle. Tu dois savoir. Il t\'a écrit ?',
      time: '21:48',
      day: 95,
    ),
    Msg(sender: 'moi', text: '« Tu reviens ? »', time: '21:54', day: 95),
    Msg(
      sender: 'vincent_heng',
      text: 'C\'est tout ce qu\'il sait dire en français.',
      time: '21:55',
      day: 95,
    ),
    // ── J110 — Avant choix final
    Msg(
      sender: 'vincent_heng',
      text: 'Tu choisis demain. Tu sais ce que je pense — pas de Paris pour toi.\n'
          'Mais je me trompe peut-être.',
      time: '13:08',
      day: 110,
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
    Msg(sender: 'moi', text: 'Bien noté. Merci Madame.', time: '10:08', day: 12),
    Msg(
      sender: 'madame_heng',
      text:
          'On ne dit pas « bien noté » à une mère, mademoiselle. '
          'On dit « entendu ».',
      time: '10:09',
      day: 12,
    ),
    Msg(sender: 'moi', text: 'Entendu.', time: '10:14', day: 12),
    Msg(
      sender: 'madame_heng',
      text: 'Bien. Maintenant un détail : vous mangez le porc ?',
      time: '14:32',
      day: 12,
    ),
    Msg(sender: 'moi', text: 'Oui Madame.', time: '14:48', day: 12),
    Msg(sender: 'madame_heng', text: 'Bien.', time: '14:49', day: 12),
    Msg(
      sender: 'madame_heng',
      text: 'Avez-vous appris la cérémonie du thé ? '
          'Trois infusions au maximum. La quatrième est un manque de respect.',
      time: '19:22',
      day: 12,
    ),
    Msg(
      sender: 'moi',
      text: 'Trois infusions. Reçu.',
      time: '19:38',
      day: 12,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'On dit « entendu », mademoiselle. Vous oubliez vite.',
      time: '19:39',
      day: 12,
    ),
    // J13 — Veille dîner, précisions
    Msg(
      sender: 'madame_heng',
      text: 'Pas de noir intégral. Une touche de pivoine. C\'est la saison.',
      time: '08:42',
      day: 13,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'Mon mari boit du vin. Vous pouvez accepter un verre. Pas deux.',
      time: '11:18',
      day: 13,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'Mon fils Vincent fait des plaisanteries déplacées. '
          'Souriez sans rire. C\'est l\'usage.',
      time: '15:48',
      day: 13,
    ),
    Msg(
      sender: 'madame_heng',
      text:
          'À demain. J\'ouvre la boîte verte. Vous saurez laquelle quand '
          'vous la verrez.',
      time: '21:08',
      day: 13,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'Vous portez la boîte verte dans la main droite, '
          'la cuillère à thé dans la gauche. Pas l\'inverse.',
      time: '21:09',
      day: 13,
    ),
    // J14 — Le matin et l'après-dîner
    Msg(
      sender: 'madame_heng',
      text: 'Bonjour mademoiselle. Pivoines blanches au centre de table. '
          'Souvenez-vous-en.',
      time: '08:18',
      day: 14,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'Tante Lihua arrivera la première. Elle a 81 ans. '
          'Levez-vous quand elle entre dans la pièce.',
      time: '14:32',
      day: 14,
    ),
    Msg(sender: 'moi', text: 'Entendu Madame.', time: '14:48', day: 14),
    Msg(
      sender: 'madame_heng',
      text: 'Vous apprenez vite. C\'est rare. Ça n\'est pas mauvais.',
      time: '14:49',
      day: 14,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'À ce soir. La porte sera entrouverte. Vous saurez.',
      time: '18:48',
      day: 14,
    ),
    // J15 (lendemain matin) — Post-dîner Long Jing deuxième récolte
    Msg(
      sender: 'madame_heng',
      text: 'Vous avez identifié la deuxième récolte. Personne ne le fait '
          'à votre âge. Mon mari l\'a noté.',
      time: '08:18',
      day: 15,
    ),
    Msg(
      sender: 'madame_heng',
      text: 'Je vous reverrai bientôt. Ma fille.',
      time: '08:19',
      day: 15,
    ),

    // ── J19 — après le déjeuner « juste nous deux » ──
    Msg(
      sender: 'madame_heng',
      text:
          'Merci pour ce déjeuner. Vous mangez comme quelqu\'un qui a '
          'connu la faim. Ce n\'est pas un reproche.',
      time: '20:48',
      day: 19,
    ),
    Msg(
      sender: 'madame_heng',
      text:
          'Mon fils m\'a dit que vous lisiez Marguerite Duras. '
          'L\'Amant, ou Hiroshima ?',
      time: '21:04',
      day: 19,
      status: MsgStatus.delivered,
      beatId: 'heng_duras_j19',
    ),

    // ── J46 — après la phrase du couloir ──
    Msg(
      sender: 'madame_heng',
      text:
          'Ce que j\'ai dit dans le couloir n\'était pas une menace. '
          'C\'était une reconnaissance.',
      time: '17:22',
      day: 46,
    ),
    Msg(
      sender: 'madame_heng',
      text:
          '« Tu as les yeux de ta mère, mais tu as la bouche de '
          'quelqu\'un d\'autre. Quelqu\'un que j\'ai connu. » '
          'Vous pouvez me poser une question. Une seule.',
      time: '17:30',
      day: 46,
      status: MsgStatus.delivered,
      beatId: 'heng_phrase_j46',
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
  'tante_mei': [
    // ── J35 — Tante Mei repère Shen sur une photo du groupe Heng ──
    Msg(
      sender: 'tante_mei',
      text: 'Bonjour. Je m\'appelle Mei. Je crois que je connais ton visage.',
      time: '10:41',
      day: 35,
    ),
    Msg(
      sender: 'tante_mei',
      text:
          'Une photo de toi circule dans le groupe de la famille Heng. '
          'Le dîner de Causeway Bay. La jeune femme qui répond en '
          'mandarin.',
      time: '10:46',
      day: 35,
    ),
    Msg(
      sender: 'tante_mei',
      text:
          'Ton visage, c\'est le visage de mon frère. Shen Wenbo. '
          '你是他的女儿吗 ? (Es-tu sa fille ?)',
      time: '10:52',
      day: 35,
    ),
    Msg(
      sender: 'tante_mei',
      text:
          'Si je me trompe, pardonne une vieille femme. Si je ne me '
          'trompe pas, réponds-moi.',
      time: '11:00',
      day: 35,
      status: MsgStatus.delivered,
      beatId: 'mei_decouvre_j35',
    ),

    // ── J78 — l'invitation au Fujian (Ep4, beat à choix) ──
    Msg(
      sender: 'tante_mei',
      text:
          'C\'est encore Mei. Je t\'écris depuis la cour. Le kaki donne '
          'trop de fruits cette année.',
      time: '19:18',
      day: 78,
    ),
    Msg(
      sender: 'tante_mei',
      text:
          'Ta mère et moi nous écrivons chaque semaine maintenant. Elle '
          'corrige mon français. Je lui apprends le nom des plantes.',
      time: '19:22',
      day: 78,
    ),
    Msg(
      sender: 'tante_mei',
      text:
          'Il y a une chose qui ne peut pas s\'écrire. Elle est ici, '
          'dans la maison de ton père. Elle t\'attend depuis 2017.',
      time: '19:27',
      day: 78,
    ),
    Msg(
      sender: 'tante_mei',
      text: 'Venez. Toi et ta mère. Avant l\'hiver. 家里等你们。 (La maison vous attend.)',
      time: '19:32',
      day: 78,
      status: MsgStatus.delivered,
      beatId: 'mei_invitation_j78',
    ),

    // ── J91 — la lettre de 2017, dans la boîte en fer ──
    Msg(
      sender: 'tante_mei',
      text:
          'La lettre est dans la boîte en fer, sous l\'autel. '
          'Il l\'a écrite en 2017, un an avant le chantier.',
      time: '20:22',
      day: 91,
    ),
    Msg(
      sender: 'tante_mei',
      text:
          '« À ma fille que je n\'ai pas connue. » Elle t\'attend '
          'depuis neuf ans. Tu veux la lire seule, ou avec ta mère ?',
      time: '20:30',
      day: 91,
      status: MsgStatus.delivered,
      beatId: 'mei_lettre_j91',
    ),
  ],
};
