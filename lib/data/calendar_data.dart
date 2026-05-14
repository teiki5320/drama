/// Évènements calendrier de Shen — rendez-vous médicaux Maman, dîners
/// Heng, deadlines, voyages.

class CalendarEvent {
  final int day;
  final String startTime;
  final String endTime;
  final String title;
  final String? location;
  final String emoji;
  final int colorHex;
  final bool urgent;

  const CalendarEvent({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.title,
    this.location,
    required this.emoji,
    required this.colorHex,
    this.urgent = false,
  });
}

const kEvents = <CalendarEvent>[
  CalendarEvent(
    day: 2,
    startTime: '06:30',
    endTime: '07:30',
    title: 'Dr Aubin — bureau privé',
    location: 'Hôpital Tenon',
    emoji: '🏥',
    colorHex: 0xFFE53935,
    urgent: true,
  ),
  CalendarEvent(
    day: 4,
    startTime: '09:30',
    endTime: '11:30',
    title: 'Dialyse Maman',
    location: 'Hôpital Tenon',
    emoji: '💉',
    colorHex: 0xFFE53935,
  ),
  CalendarEvent(
    day: 4,
    startTime: '14:00',
    endTime: '15:30',
    title: 'Café Hanami — Camille',
    location: 'Près du campus',
    emoji: '☕',
    colorHex: 0xFF6B5B95,
  ),
  CalendarEvent(
    day: 7,
    startTime: '10:30',
    endTime: '12:00',
    title: 'Tour Heng — 47ᵉ',
    location: 'Avenue Montaigne',
    emoji: '🏢',
    colorHex: 0xFFD97757,
    urgent: true,
  ),
  CalendarEvent(
    day: 8,
    startTime: '11:30',
    endTime: '13:00',
    title: 'Cabinet notarial',
    location: 'Contrat 14 pages',
    emoji: '📋',
    colorHex: 0xFF1F2937,
    urgent: true,
  ),
  CalendarEvent(
    day: 11,
    startTime: '09:30',
    endTime: '11:30',
    title: 'Dialyse Maman',
    location: 'Hôpital Tenon',
    emoji: '💉',
    colorHex: 0xFFE53935,
  ),
  CalendarEvent(
    day: 14,
    startTime: '20:30',
    endTime: '23:00',
    title: 'Dîner Madame Heng',
    location: 'Appartement Heng',
    emoji: '🍵',
    colorHex: 0xFFD97757,
    urgent: true,
  ),
  CalendarEvent(
    day: 45,
    startTime: '00:00',
    endTime: '23:59',
    title: 'DEADLINE — Traitement de Maman',
    location: '18 000 € requis',
    emoji: '⏳',
    colorHex: 0xFFC62828,
    urgent: true,
  ),
];
