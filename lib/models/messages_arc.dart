/// Moteur d'arcs de conversations Messages — inspiré du moteur romance
/// Tinder mais adapté à iMessage : contacts secondaires (voisine, médecin,
/// ami d'enfance, ex-collègue) qui apparaissent et tissent des arcs de
/// 3 à 15 jours avec branches, variantes et fins multiples.
///
/// Différences avec romance.dart :
///  - Pas de notion de "ton" amoureux : c'est un MessagesArcCategory
///    (utility/spam/medical/friendly/admin/family/work/...)
///  - Pas de pool de profils interchangeables : un contact unique par arc
///    (un médecin = Dr Aubin, pas "Dr A / Dr B / Dr C").
///  - Bulles iMessage classiques (bleu Shen, gris l'autre).
library;

/// Catégorie de l'arc — pondère la diversité (pas 3 arcs medical
/// simultanés) et le rendu visuel (icône, couleur).
enum MessagesArcCategory {
  voisinage,   // voisine, voisin, gardien
  medical,     // médecin, infirmière, hôpital
  famille,     // tante, cousine, ancien proche
  ancien,      // ex-collègue, ami d'enfance, ex-coloc
  spam,        // BNP, opérateur, voyance, livraisons
  arnaque,     // faux SAV, faux livreur, OTP fantômes
  admin,       // notaire, médecin du travail, URSSAF
  work,        // plateforme livraison, employeur
  ex,          // ancien.ne amoureux.se
  wrongNumber, // numéro erroné qui devient autre chose
}

/// Type de beat — identique au moteur romance, mais avec bulles iMessage.
enum MessagesArcBeatType {
  text,
  voiceNote,
  photoShared,
  callRing,
  typingThenNothing,
  unmatch,         // ici = "le contact arrête d'écrire / bloque"
  choice,
  mapLocation,
  seenNoReply,
}

/// Contact unique pour un arc. Différent de MsgContact (canonique) :
/// les arcs créent leurs propres contacts dynamiques.
class MessagesArcContact {
  final String id;
  final String displayName;
  final String emoji;
  final String avatarTint;  // hex
  final String? subtitle;   // optionnel sous le nom dans la liste
  final List<int> gradient; // pour l'avatar bokeh
  /// Évite que les arcs aient un avatar identique à un contact canonique.
  /// Si true → tag visuel "+ contact" pour signaler que c'est un inconnu.
  final bool isUnknown;

  const MessagesArcContact({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.avatarTint,
    this.subtitle,
    this.gradient = const [0xFFE7E1D2, 0xFFB8A88E],
    this.isUnknown = false,
  });
}

/// Beat dans un arc Messages.
class MessagesArcBeat {
  final int dayOffset;
  final int atHour;
  final int atMinute;
  final MessagesArcBeatType type;
  final bool fromThem;
  final List<String> textVariants;
  final List<String> photoLabels;
  final int? voiceDurationS;
  final int? callDurationS;
  final List<MessagesArcChoice> choices;
  final String? requireBranch;
  final String? forbidBranch;
  final String? setBranch;
  final String? endsArc;

  const MessagesArcBeat({
    required this.dayOffset,
    required this.atHour,
    this.atMinute = 0,
    required this.type,
    this.fromThem = true,
    this.textVariants = const [],
    this.photoLabels = const [],
    this.voiceDurationS,
    this.callDurationS,
    this.choices = const [],
    this.requireBranch,
    this.forbidBranch,
    this.setBranch,
    this.endsArc,
  });
}

class MessagesArcChoice {
  final String label;
  final String reply;
  final int moodDelta;
  final String? setBranch;
  final String? endsArc;

  const MessagesArcChoice({
    required this.label,
    required this.reply,
    this.moodDelta = 0,
    this.setBranch,
    this.endsArc,
  });
}

class MessagesArcTemplate {
  final String id;
  final String label;
  final MessagesArcCategory category;
  final MessagesArcContact contact;
  final List<MessagesArcBeat> beats;
  final int minStartDay;
  final int? maxStartDay;
  final double spawnWeight;
  final int cooldownDays;
  final String description;

  const MessagesArcTemplate({
    required this.id,
    required this.label,
    required this.category,
    required this.contact,
    required this.beats,
    this.minStartDay = 1,
    this.maxStartDay,
    this.spawnWeight = 1.0,
    this.cooldownDays = 60,
    this.description = '',
  });
}

class MessagesArcPlayedMsg {
  final bool fromThem;
  final int day;
  final String time;
  final MessagesArcBeatType type;
  final String? text;
  final String? photoLabel;
  final int? voiceDurationS;
  final int? callDurationS;
  final bool callMissed;
  final int? chosenIndex;

  const MessagesArcPlayedMsg({
    required this.fromThem,
    required this.day,
    required this.time,
    required this.type,
    this.text,
    this.photoLabel,
    this.voiceDurationS,
    this.callDurationS,
    this.callMissed = false,
    this.chosenIndex,
  });
}

class MessagesArcInstance {
  final String id;
  final String templateId;
  final int startDay;
  final int startHour;
  final int startMinute;
  final List<MessagesArcPlayedMsg> playedMessages;
  final Set<String> branches;
  final int nextBeatIdx;
  final bool ended;
  final String? endingId;
  final int? pendingChoiceBeatIdx;

  const MessagesArcInstance({
    required this.id,
    required this.templateId,
    required this.startDay,
    required this.startHour,
    required this.startMinute,
    this.playedMessages = const [],
    this.branches = const {},
    this.nextBeatIdx = 0,
    this.ended = false,
    this.endingId,
    this.pendingChoiceBeatIdx,
  });

  MessagesArcInstance copyWith({
    List<MessagesArcPlayedMsg>? playedMessages,
    Set<String>? branches,
    int? nextBeatIdx,
    bool? ended,
    String? endingId,
    int? pendingChoiceBeatIdx,
    bool clearPendingChoice = false,
  }) =>
      MessagesArcInstance(
        id: id,
        templateId: templateId,
        startDay: startDay,
        startHour: startHour,
        startMinute: startMinute,
        playedMessages: playedMessages ?? this.playedMessages,
        branches: branches ?? this.branches,
        nextBeatIdx: nextBeatIdx ?? this.nextBeatIdx,
        ended: ended ?? this.ended,
        endingId: endingId ?? this.endingId,
        pendingChoiceBeatIdx: clearPendingChoice
            ? null
            : (pendingChoiceBeatIdx ?? this.pendingChoiceBeatIdx),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'templateId': templateId,
        'startDay': startDay,
        'startHour': startHour,
        'startMinute': startMinute,
        'playedMessages': playedMessages
            .map((m) => {
                  'fromThem': m.fromThem,
                  'day': m.day,
                  'time': m.time,
                  'type': m.type.name,
                  'text': m.text,
                  'photoLabel': m.photoLabel,
                  'voiceDurationS': m.voiceDurationS,
                  'callDurationS': m.callDurationS,
                  'callMissed': m.callMissed,
                  'chosenIndex': m.chosenIndex,
                })
            .toList(),
        'branches': branches.toList(),
        'nextBeatIdx': nextBeatIdx,
        'ended': ended,
        'endingId': endingId,
        'pendingChoiceBeatIdx': pendingChoiceBeatIdx,
      };

  static MessagesArcInstance fromJson(Map<String, dynamic> j) =>
      MessagesArcInstance(
        id: j['id'] as String,
        templateId: j['templateId'] as String,
        startDay: j['startDay'] as int,
        startHour: j['startHour'] as int,
        startMinute: j['startMinute'] as int,
        playedMessages: ((j['playedMessages'] as List?) ?? [])
            .map((m) => MessagesArcPlayedMsg(
                  fromThem: m['fromThem'] as bool,
                  day: m['day'] as int,
                  time: m['time'] as String,
                  type: MessagesArcBeatType.values
                      .firstWhere((t) => t.name == m['type']),
                  text: m['text'] as String?,
                  photoLabel: m['photoLabel'] as String?,
                  voiceDurationS: m['voiceDurationS'] as int?,
                  callDurationS: m['callDurationS'] as int?,
                  callMissed: (m['callMissed'] as bool?) ?? false,
                  chosenIndex: m['chosenIndex'] as int?,
                ))
            .toList(),
        branches: ((j['branches'] as List?) ?? [])
            .map((e) => e as String)
            .toSet(),
        nextBeatIdx: j['nextBeatIdx'] as int? ?? 0,
        ended: j['ended'] as bool? ?? false,
        endingId: j['endingId'] as String?,
        pendingChoiceBeatIdx: j['pendingChoiceBeatIdx'] as int?,
      );
}
