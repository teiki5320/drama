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
        'Le médecin a dit que tout irait bien. Je t\'aime ma fille.',
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
  // Voicemail Maman J14 18:42 — avant le dîner Madame Heng
  CallEntry(
    day: 14,
    time: '18:42',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.voicemail,
    duration: '00:38',
    avatarPath: 'assets/photos/avatars/maman.webp',
    voicemailNote:
        'Ma fille, je sais que tu dînes ce soir chez ces gens. '
        'Je ne te demande pas où tu vas. Je ne te demande pas qui '
        'tu vois. Je te demande juste de manger. Couvre-toi.',
  ),
  // Voicemail Madame Heng J13 — sentencieuse, installe la cadence
  CallEntry(
    day: 13,
    time: '12:08',
    contactLabel: 'Madame Heng',
    contactEmoji: '🍵',
    type: CallType.voicemail,
    duration: '00:38',
    avatarPath: 'assets/photos/avatars/madame_heng.webp',
    voicemailNote:
        'Mademoiselle Marchand. J\'aurais pu écrire. Mais une voix '
        'tient mieux qu\'un message. Un proverbe de chez nous dit : '
        'ce qui n\'est pas dit reste vrai. Jeudi 20h30. À demain.',
  ),
  // Idée 7 — Voicemail Tristan J3 23:58, 3 minutes après l'appel raté.
  // Avatar volontairement non rendu (juste emoji ❓) pour ne pas
  // spoiler l'identité avant que Shen n'identifie la voix.
  CallEntry(
    day: 3,
    time: '23:58',
    contactLabel: 'Numéro masqué',
    contactEmoji: '❓',
    type: CallType.voicemail,
    duration: '00:14',
    voicemailNote:
        'Mlle Marchand. Vous avez gardé ma carte. Rappelez quand vous '
        'voudrez parler chiffres. Du temps, j\'en ai.',
  ),
  // ─── Spam commercial récurrent (J1-J14) ─────────────────────
  CallEntry(
    day: 1,
    time: '17:14',
    contactLabel: 'Linky / EDF',
    contactEmoji: '⚡',
    type: CallType.missed,
  ),
  CallEntry(
    day: 2,
    time: '11:18',
    contactLabel: 'Mutuelle Direct',
    contactEmoji: '📞',
    type: CallType.missed,
  ),
  CallEntry(
    day: 2,
    time: '14:42',
    contactLabel: 'Isolation 1 €',
    contactEmoji: '🏗️',
    type: CallType.missed,
  ),
  CallEntry(
    day: 4,
    time: '10:08',
    contactLabel: 'Linky / EDF',
    contactEmoji: '⚡',
    type: CallType.outgoing,
    duration: '00:42',
    voicemailNote: 'STOP. Bonjour, vous appelez à propos de mon compteur. Je n\'ai pas de compteur. Au revoir.',
  ),
  CallEntry(
    day: 5,
    time: '18:32',
    contactLabel: 'Voyance Maitre Sandra',
    contactEmoji: '🔮',
    type: CallType.missed,
  ),
  CallEntry(
    day: 7,
    time: '13:18',
    contactLabel: 'Numéro masqué',
    contactEmoji: '❓',
    type: CallType.missed,
  ),
  CallEntry(
    day: 9,
    time: '15:42',
    contactLabel: 'Faux SAV Apple',
    contactEmoji: '⚠️',
    type: CallType.incoming,
    duration: '01:14',
    voicemailNote: '« Bonjour, c\'est Apple SAV, votre iCloud est compromis. » Tu as raccroché à 1 min 14.',
  ),
  // ─── Maman vocals plus longs ────────────────────────────────
  CallEntry(
    day: 7,
    time: '19:42',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.voicemail,
    duration: '01:08',
    avatarPath: 'assets/photos/avatars/maman.webp',
    voicemailNote:
        'Shen, je ne sais pas si tu rentres ce soir. J\'ai mis le riz au chaud. '
        'Camille m\'a dit que tu avais un rendez-vous important demain matin. '
        'Je ne te demande rien. Repose-toi, ma fille.',
  ),
  CallEntry(
    day: 9,
    time: '08:18',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.outgoing,
    duration: '06:48',
    avatarPath: 'assets/photos/avatars/maman.webp',
  ),
  CallEntry(
    day: 11,
    time: '21:14',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.voicemail,
    duration: '00:54',
    avatarPath: 'assets/photos/avatars/maman.webp',
    voicemailNote:
        '« Premier jour de stage. » Tu écris « bien » depuis trois jours. '
        'Donne-moi un détail. Un seul. Bonne nuit ma fille.',
  ),
  CallEntry(
    day: 12,
    time: '14:32',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.missed,
    avatarPath: 'assets/photos/avatars/maman.webp',
  ),
  CallEntry(
    day: 39,
    time: '04:14',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.missed,
    avatarPath: 'assets/photos/avatars/maman.webp',
  ),
  CallEntry(
    day: 39,
    time: '04:18',
    contactLabel: 'Maman',
    contactEmoji: '👩',
    type: CallType.voicemail,
    duration: '00:14',
    avatarPath: 'assets/photos/avatars/maman.webp',
    voicemailNote: 'Réponds.',
  ),
  // ─── Dr Aubin résultats ─────────────────────────────────────
  CallEntry(
    day: 9,
    time: '17:08',
    contactLabel: 'Dr Aubin',
    contactEmoji: '🩺',
    type: CallType.incoming,
    duration: '12:48',
    voicemailNote: 'Conversation 12 min sur le protocole. Coût restant 18 000 €.',
  ),
  CallEntry(
    day: 28,
    time: '16:14',
    contactLabel: 'Dr Aubin',
    contactEmoji: '🩺',
    type: CallType.voicemail,
    duration: '00:42',
    voicemailNote:
        'Mlle Marchand. Bonne nouvelle au bilan d\'aujourd\'hui. Votre mère réagit. '
        'Rappelez-moi quand vous avez 5 min, je vous expliquerai.',
  ),
  CallEntry(
    day: 45,
    time: '10:12',
    contactLabel: 'Dr Aubin',
    contactEmoji: '🩺',
    type: CallType.incoming,
    duration: '08:42',
  ),
  // ─── Tristan appels — rares, brefs
  CallEntry(
    day: 7,
    time: '17:18',
    contactLabel: 'Tristan H.',
    contactEmoji: '🧊',
    type: CallType.incoming,
    duration: '02:14',
    avatarPath: 'assets/photos/avatars/tristan.webp',
  ),
  CallEntry(
    day: 9,
    time: '17:22',
    contactLabel: 'Tristan H.',
    contactEmoji: '🧊',
    type: CallType.outgoing,
    duration: '00:38',
    avatarPath: 'assets/photos/avatars/tristan.webp',
  ),
  CallEntry(
    day: 52,
    time: '18:48',
    contactLabel: 'Tristan H.',
    contactEmoji: '🧊',
    type: CallType.voicemail,
    duration: '00:22',
    avatarPath: 'assets/photos/avatars/tristan.webp',
    voicemailNote: 'Le contrat se termine demain. Je n\'ai rien à ajouter.',
  ),
  // ─── Camille — appels et vocaux
  CallEntry(
    day: 3,
    time: '22:42',
    contactLabel: 'Camille',
    contactEmoji: '🥐',
    type: CallType.incoming,
    duration: '23:18',
    avatarPath: 'assets/photos/avatars/camille.webp',
  ),
  CallEntry(
    day: 6,
    time: '22:48',
    contactLabel: 'Camille',
    contactEmoji: '🥐',
    type: CallType.voicemail,
    duration: '00:58',
    avatarPath: 'assets/photos/avatars/camille.webp',
    voicemailNote:
        'Ma poule. Demain c\'est jour J. Tu lui tiens tête. Tu ne signes RIEN. '
        'Promesse de poulette. Promets-moi. Bonne nuit.',
  ),
  CallEntry(
    day: 26,
    time: '23:14',
    contactLabel: 'Camille',
    contactEmoji: '🥐',
    type: CallType.missed,
    avatarPath: 'assets/photos/avatars/camille.webp',
  ),
  // ─── Vincent — un seul appel pro
  CallEntry(
    day: 30,
    time: '22:42',
    contactLabel: 'Vincent Heng',
    contactEmoji: '💼',
    type: CallType.voicemail,
    duration: '00:18',
    avatarPath: 'assets/photos/avatars/vincent.webp',
    voicemailNote: 'Tu étais magnifique. Ma mère est en colère contre tout le monde sauf toi.',
  ),
  // ─── Papa — sonne dans le vide
  CallEntry(
    day: 14,
    time: '02:14',
    contactLabel: 'Papa',
    contactEmoji: '🕊️',
    type: CallType.outgoing,
    duration: '00:00',
    voicemailNote: 'Tu as composé son numéro. Pas de tonalité. Pas de répondeur. 12 sonneries. Rien.',
  ),
  // ─── Bot SVI
  CallEntry(
    day: 8,
    time: '11:18',
    contactLabel: 'Bot Service Client',
    contactEmoji: '🤖',
    type: CallType.outgoing,
    duration: '04:32',
    voicemailNote: '« Pour confirmer, pressez 1. Pour parler à un conseiller, pressez 2. Pour... » 4 minutes 32 d\'attente.',
  ),
  // ─── Tante Mei
  CallEntry(
    day: 35,
    time: '11:48',
    contactLabel: 'Tante Mei (Fujian)',
    contactEmoji: '🍵',
    type: CallType.missed,
    avatarPath: 'assets/photos/avatars/tante_mei.webp',
  ),
];
