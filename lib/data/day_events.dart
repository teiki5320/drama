/// Moteur événements — quand le joueur avance dans la journée, des
/// événements précis se déclenchent à des heures précises et poussent
/// du contenu dans plusieurs apps simultanément (un SMS dans Messages,
/// une photo dans Photos, un badge sur Banque, etc.).
///
/// Chaque événement définit :
/// - `day` : J du déclenchement
/// - `hour/minute` : heure du déclenchement
/// - `apps` : liste d'apps qui reçoivent un badge
/// - `notification` : (title, body) du banner qui apparaît
/// - `note` : texte court qui décrit l'événement (debug / lock screen)

class DayEvent {
  final int day;
  final int hour;
  final int minute;
  final List<String> apps; // app IDs qui reçoivent un badge
  final String notifTitle;
  final String notifBody;
  final String notifAppId; // app qui apparaît dans le banner
  final String summary;

  /// Si true, l'événement déclenche l'écran d'appel entrant plein écran
  /// (au lieu d'un banner). `callTranscript` = ce que dit l'appelant si
  /// Shen décroche, ligne à ligne. Le nom affiché est la partie de
  /// `notifBody` avant « · ».
  final bool isIncomingCall;
  final List<String> callTranscript;

  const DayEvent({
    required this.day,
    required this.hour,
    required this.minute,
    required this.apps,
    required this.notifTitle,
    required this.notifBody,
    required this.notifAppId,
    required this.summary,
    this.isIncomingCall = false,
    this.callTranscript = const [],
  });

  int get totalMinutes => day * 24 * 60 + hour * 60 + minute;
}

const kDayEvents = <DayEvent>[
  // ─── J1 ────────────────────────────────────────────────────────
  DayEvent(
    day: 1,
    hour: 7,
    minute: 48,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Maman ❤️',
    notifBody: 'Tu pars livrer dans combien de temps ?',
    summary: 'SMS Maman avant départ',
  ),
  DayEvent(
    day: 1,
    hour: 7,
    minute: 52,
    apps: ['messages', 'ubereats'],
    notifAppId: 'ubereats',
    notifTitle: 'Course #14872',
    notifBody: 'Bowl Açaí — Avenue Montaigne. 8,40 €.',
    summary: 'Course Uber Eats acceptée',
  ),
  DayEvent(
    day: 1,
    hour: 8,
    minute: 17,
    apps: ['photos'],
    notifAppId: 'photos',
    notifTitle: 'Nouveau souvenir',
    notifBody: 'Avenue Montaigne · 08:17',
    summary: 'Collision — photo auto du vélo cassé',
  ),
  DayEvent(
    day: 1,
    hour: 8,
    minute: 31,
    apps: ['messages', 'banque', 'ubereats'],
    notifAppId: 'ubereats',
    notifTitle: 'Incident · pénalité',
    notifBody: 'Course #14872 non livrée. − 38,00 €.',
    summary: 'Pénalité plateforme + alerte banque',
  ),
  DayEvent(
    day: 1,
    hour: 23,
    minute: 42,
    apps: ['notes', 'photos'],
    notifAppId: 'notes',
    notifTitle: 'Nouvelle note',
    notifBody: 'Première erreur.',
    summary: 'Carte recollée — note + photo',
  ),
  // ─── J2 ────────────────────────────────────────────────────────
  DayEvent(
    day: 2,
    hour: 6,
    minute: 30,
    apps: ['calendrier', 'telephone'],
    notifAppId: 'calendrier',
    notifTitle: 'Rendez-vous',
    notifBody: 'Dr Aubin — bureau privé · Tenon',
    summary: 'Bureau Dr Aubin',
  ),
  DayEvent(
    day: 2,
    hour: 7,
    minute: 24,
    apps: ['notes'],
    notifAppId: 'notes',
    notifTitle: 'Nouvelle note',
    notifBody: 'Compteur J42. Maman a six semaines.',
    summary: 'Compteur démarre',
  ),
  // ─── J3 ────────────────────────────────────────────────────────
  DayEvent(
    day: 3,
    hour: 14,
    minute: 23,
    apps: ['messages', 'banque'],
    notifAppId: 'banque',
    notifTitle: 'Crédit refusé',
    notifBody: 'BNP : demande n°7842 refusée. Pas de garant.',
    summary: 'Une porte. Fermée.',
  ),
  DayEvent(
    day: 3,
    hour: 20,
    minute: 8,
    apps: ['telephone', 'notes'],
    notifAppId: 'telephone',
    notifTitle: 'Aide sociale',
    notifBody: 'Six mois minimum pour instruire.',
    summary: 'Deux portes. Fermées.',
  ),
  DayEvent(
    day: 3,
    hour: 23,
    minute: 55,
    apps: ['telephone'],
    notifAppId: 'telephone',
    notifTitle: 'Appel entrant',
    notifBody: 'Numéro masqué · 23:55',
    summary: 'T. appelle (numéro masqué)',
    isIncomingCall: true,
    // Il ne dit rien. Il écoute. Puis il raccroche.
    callTranscript: ['…'],
  ),
  // ─── J14 ────────────────────────────────────────────────────────
  DayEvent(
    day: 14,
    hour: 18,
    minute: 42,
    apps: ['telephone'],
    notifAppId: 'telephone',
    notifTitle: 'Maman ❤️',
    notifBody: 'Messagerie · 38 s',
    summary: 'Voicemail Maman avant le dîner',
  ),
  DayEvent(
    day: 14,
    hour: 22,
    minute: 5,
    apps: ['instagram'],
    notifAppId: 'instagram',
    notifTitle: 'heng_lihua',
    notifBody: 'Vous a identifiée dans une story.',
    summary: 'Madame Heng tag Shen publiquement',
  ),
  DayEvent(
    day: 14,
    hour: 22,
    minute: 48,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Tristan H.',
    notifBody: '« Elle ne dit "ma fille" qu\'aux personnes... »',
    summary: 'Tristan commente le dîner',
  ),

  // ─── Ep2-5 — un signal par scène à choix, pour guider le joueur ────
  DayEvent(
    day: 19,
    hour: 21,
    minute: 4,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Madame Heng',
    notifBody: 'L\'Amant, ou Hiroshima ?',
    summary: 'Madame Heng écrit après le déjeuner',
  ),
  DayEvent(
    day: 23,
    hour: 19,
    minute: 32,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Maman ❤️',
    notifBody: 'Qui t\'offre du thé d\'empereur ?',
    summary: 'Maman a trouvé la boîte de Long Jing',
  ),
  DayEvent(
    day: 24,
    hour: 21,
    minute: 12,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Maman ❤️',
    notifBody: 'Dis-moi si je me trompe.',
    summary: 'Maman a deviné',
  ),
  DayEvent(
    day: 26,
    hour: 22,
    minute: 14,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Camille',
    notifBody: 'Sérieux, Shen. Huit jours.',
    summary: 'Camille compte les jours de silence',
  ),
  DayEvent(
    day: 29,
    hour: 10,
    minute: 30,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Camille',
    notifBody: 'T\'as un passeport VALIDE au moins ?',
    summary: 'Le passeport, départ jeudi',
  ),
  DayEvent(
    day: 35,
    hour: 11,
    minute: 0,
    apps: ['messages', 'whatsapp'],
    notifAppId: 'messages',
    notifTitle: 'Numéro inconnu',
    notifBody: 'Mei · « Je crois que je connais ton visage. »',
    summary: 'Tante Mei repère Shen',
  ),
  DayEvent(
    day: 38,
    hour: 19,
    minute: 0,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Camille',
    notifBody: 'Photo. MAINTENANT.',
    summary: 'La robe bleu nuit',
  ),
  DayEvent(
    day: 39,
    hour: 7,
    minute: 12,
    apps: ['telephone', 'messages'],
    notifAppId: 'telephone',
    notifTitle: 'Appel entrant',
    notifBody: 'Maman ❤️ · 4h à Paris',
    summary: 'Maman appelle en pleine nuit — Tante Mei a parlé',
    isIncomingCall: true,
    callTranscript: [
      'Shen ? C\'est Maman.',
      'Il est quatre heures ici. Je n\'arrive pas à dormir.',
      'Une dame du Fujian m\'a écrit. Mei. Elle dit des choses sur toi.',
      'Je t\'ai envoyé des messages. Lis-les. Réponds-moi.',
    ],
  ),
  DayEvent(
    day: 39,
    hour: 21,
    minute: 40,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Vincent Heng',
    notifBody: 'J\'ai une information qui te concerne.',
    summary: 'Le poison de Vincent au bar',
  ),
  DayEvent(
    day: 42,
    hour: 11,
    minute: 14,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Maman ❤️',
    notifBody: 'Tu es dans ma cuisine et je t\'écris.',
    summary: 'La confrontation silencieuse',
  ),
  DayEvent(
    day: 46,
    hour: 17,
    minute: 30,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Madame Heng',
    notifBody: 'Vous pouvez me poser une question. Une seule.',
    summary: 'La phrase du couloir',
  ),
  DayEvent(
    day: 52,
    hour: 18,
    minute: 8,
    apps: ['messages', 'banque'],
    notifAppId: 'messages',
    notifTitle: 'Tristan H.',
    notifBody: 'Vous êtes libre. C\'est la clause 21.',
    summary: 'Tristan annonce la fin du contrat',
  ),
  DayEvent(
    day: 53,
    hour: 9,
    minute: 40,
    apps: ['messages', 'banque'],
    notifAppId: 'messages',
    notifTitle: 'Camille',
    notifBody: 'C\'est le dossier avec le nom de ta mère dedans.',
    summary: 'Le dossier de Shanghai',
  ),
  DayEvent(
    day: 69,
    hour: 21,
    minute: 0,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Maman ❤️',
    notifBody: 'On la lira à voix haute, une fois, ensemble.',
    summary: 'Hélène a lu la lettre',
  ),
  DayEvent(
    day: 78,
    hour: 19,
    minute: 32,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Tante Mei',
    notifBody: 'Venez. Toi et ta mère. Avant l\'hiver.',
    summary: 'L\'invitation au Fujian',
  ),
  DayEvent(
    day: 91,
    hour: 20,
    minute: 30,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Tante Mei',
    notifBody: 'Elle t\'attend depuis neuf ans.',
    summary: 'La lettre de 2017',
  ),
  DayEvent(
    day: 95,
    hour: 11,
    minute: 0,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Tristan H.',
    notifBody: 'Tu reviens ?',
    summary: 'La question simple, depuis Paris',
  ),
  DayEvent(
    day: 102,
    hour: 21,
    minute: 0,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Maman ❤️',
    notifBody: 'Tu lui as dit quoi, dans cette dernière lettre ?',
    summary: 'Le brasero de la cour',
  ),
  DayEvent(
    day: 112,
    hour: 7,
    minute: 14,
    apps: ['messages'],
    notifAppId: 'messages',
    notifTitle: 'Camille',
    notifBody: 'Alors, ma poule. Tu emportes quoi ?',
    summary: 'Le dernier choix',
  ),
];

/// Renvoie les événements de la journée demandée, triés chronologiquement.
List<DayEvent> eventsForDay(int day) =>
    kDayEvents.where((e) => e.day == day).toList()
      ..sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));

/// Renvoie les événements déclenchés entre deux moments (utilisé par
/// le moteur quand le joueur fait avancer le temps).
List<DayEvent> eventsBetween({
  required int fromDay,
  required int fromHour,
  required int fromMinute,
  required int toDay,
  required int toHour,
  required int toMinute,
}) {
  final fromTotal = fromDay * 24 * 60 + fromHour * 60 + fromMinute;
  final toTotal = toDay * 24 * 60 + toHour * 60 + toMinute;
  return kDayEvents
      .where((e) => e.totalMinutes > fromTotal && e.totalMinutes <= toTotal)
      .toList()
    ..sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));
}
