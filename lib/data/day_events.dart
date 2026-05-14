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

  const DayEvent({
    required this.day,
    required this.hour,
    required this.minute,
    required this.apps,
    required this.notifTitle,
    required this.notifBody,
    required this.notifAppId,
    required this.summary,
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
    notifBody: 'Tu pars livrer dans combien ?',
    summary: 'SMS Maman avant départ',
  ),
  DayEvent(
    day: 1,
    hour: 7,
    minute: 52,
    apps: ['messages', 'ubereats'],
    notifAppId: 'ubereats',
    notifTitle: 'Course #14872',
    notifBody: 'Bowl Açaí — Avenue Montaigne. 8,40 €.',
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
    notifBody: 'Course #14872 non livrée. − 38,00 €.',
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
    notifBody: 'BNP : demande n°7842 refusée. Pas de garant.',
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
    notifTitle: 'Appel manqué',
    notifBody: 'Numéro masqué · 23:55',
    summary: 'T. appelle (numéro masqué)',
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
