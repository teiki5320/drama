/// Journal d'appels et messagerie vocale de Shen.

enum CallType { incoming, outgoing, missed, voicemail }

class CallEntry {
  final int day;
  final String time;
  final String contactLabel;
  final String? contactEmoji;
  final CallType type;
  final String duration; // "12:34" ou "0:00" si raté
  final String? voicemailNote;

  const CallEntry({
    required this.day,
    required this.time,
    required this.contactLabel,
    this.contactEmoji,
    required this.type,
    this.duration = '0:00',
    this.voicemailNote,
  });
}

const kCalls = <CallEntry>[
  CallEntry(
    day: 1,
    time: '08:23',
    contactLabel: 'Camille',
    contactEmoji: '🥐',
    type: CallType.missed,
  ),
  CallEntry(
    day: 1,
    time: '11:42',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.outgoing,
    duration: '04:12',
  ),
  CallEntry(
    day: 2,
    time: '06:10',
    contactLabel: 'Hôpital Tenon',
    contactEmoji: '🏥',
    type: CallType.incoming,
    duration: '02:48',
  ),
  CallEntry(
    day: 3,
    time: '20:08',
    contactLabel: 'Aide sociale',
    contactEmoji: '📞',
    type: CallType.outgoing,
    duration: '14:32',
    voicemailNote:
        'Six mois minimum pour instruire un dossier, mademoiselle. Vous pouvez prendre rendez-vous.',
  ),
  CallEntry(
    day: 3,
    time: '23:55',
    contactLabel: 'Numéro masqué',
    contactEmoji: '❓',
    type: CallType.missed,
  ),
];
