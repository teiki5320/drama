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
  /// Avatar du contact (asset path). Fallback emoji si null.
  final String? avatarPath;

  const CallEntry({
    required this.day,
    required this.time,
    required this.contactLabel,
    this.contactEmoji,
    required this.type,
    this.duration = '0:00',
    this.voicemailNote,
    this.avatarPath,
  });
}

const kCalls = <CallEntry>[
  CallEntry(
    day: 1,
    time: '08:23',
    contactLabel: 'Camille',
    contactEmoji: '🥐',
    type: CallType.missed,
    avatarPath: 'assets/photos/avatars/camille.webp',
  ),
  CallEntry(
    day: 1,
    time: '11:42',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.outgoing,
    duration: '04:12',
    avatarPath: 'assets/photos/avatars/maman.webp',
  ),
  // Idée 3 — Appel masqué J1 14:00 (Tristan testait le numéro recollé)
  CallEntry(
    day: 1,
    time: '14:02',
    contactLabel: 'Numéro masqué',
    contactEmoji: '❓',
    type: CallType.missed,
  ),
  CallEntry(
    day: 2,
    time: '06:10',
    contactLabel: 'Hôpital Tenon',
    contactEmoji: '🏥',
    type: CallType.incoming,
    duration: '02:48',
  ),
  // Idée 5 — Voicemail Maman J2 (premier mensonge officiel)
  CallEntry(
    day: 2,
    time: '20:42',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.voicemail,
    duration: '00:42',
    avatarPath: 'assets/photos/avatars/maman.webp',
    voicemailNote:
        'Shen ? Reviens vite, ne t\'inquiète pas pour moi. '
        'Le médecin a dit que tout allait bien aller. Je t\'aime ma fille.',
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
    avatarPath: 'assets/photos/avatars/tristan.webp',
  ),
  // Idée 7 — Voicemail Tristan J3 23:58, 3 minutes après l'appel raté
  CallEntry(
    day: 3,
    time: '23:58',
    contactLabel: 'Numéro masqué',
    contactEmoji: '❓',
    type: CallType.voicemail,
    duration: '00:14',
    avatarPath: 'assets/photos/avatars/tristan.webp',
    voicemailNote:
        'Mlle Marchand. Vous avez gardé ma carte. Rappelez quand vous '
        'voudrez parler chiffres. C\'est moi qui ai du temps.',
  ),
];
