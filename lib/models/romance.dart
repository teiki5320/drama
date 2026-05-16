/// Moteur de romances Tinder — chaque archétype est un template avec
/// pools de variantes (openers, photos, RDV, situations, fins). Quand
/// le scheduler spawn une instance, il pioche un profil et un set de
/// variantes. Deux runs du même archétype ne sont jamais identiques.
///
/// Architecture :
///   RomanceTemplate (catalogue, immuable)
///     ├── profilePool        — 4-5 identités interchangeables
///     ├── beats              — ordonnés par dayOffset ; chaque beat a
///     │                        des variantes texte et des choix Shen
///     └── tone / weight      — méta pour la pondération de spawn
///
///   RomanceInstance (état, sérialisable)
///     ├── templateId + profileIdx
///     ├── startDay/Hour/Min  — moment du match
///     ├── playedMessages     — messages déjà visibles dans le thread
///     ├── branches           — tags posés par les choix Shen
///     ├── nextBeatIdx        — prochain beat à jouer
///     └── ended / endingId   — terminée + raison
library;

/// Catégorie de ton/genre — pondère la diversité (pas 2 lovebombs en
/// même temps) et la trace mood.
enum RomanceTone {
  sincere,        // slow burn sain
  lovebomb,       // submerge → s'écroule
  breadcrumb,     // miettes méthodiques
  predator,       // transactionnel agressif
  refuge,         // sain, ouvert, pose pas
  catfish,        // identité fausse
  ambiguous,      // poly non-dit, double jeu
  intense,        // courte et brûlante
  pedant,         // mansplainer
  passionate,     // chef/artiste qui disparaît dans son art
  fragile,        // père divorcé, vulnérable
  immature,       // tendre mais pas prêt
  imminent,       // départ rapproché, romance compressée
  narcissist,     // closing, anglicismes
  classDivide,    // tension classe sociale
  queer,          // ouverture inattendue
  manipulative,   // soft, douce, retire
  tooYoung,       // lumineux, malaise âge
  sporty,         // dispo physique, Shen ne suit pas
  adult,          // décisions abruptes
  escort,         // révélation
  reunion,        // ancien expat HK
}

/// Profil affichable — utilisé pour la fiche dans la pile + le header
/// du thread DM. Plusieurs profils possibles par archétype, on en
/// pioche un au spawn.
class RomanceProfile {
  final String id;
  final String name;
  final int age;
  final String profession;
  final String quartier;
  /// Détail unique qui personnalise l'identité (« sketches à l'encre »,
  /// « a un chat », « vélo cargo »).
  final String detail;
  final String bio;
  final List<int> gradient;
  final String emoji;
  /// Nombre de photos disponibles (4 par défaut). Le rendu est procédural
  /// pour l'instant ; on branchera de vrais assets plus tard.
  final int photoCount;
  final List<String> photoEmojis;

  const RomanceProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.profession,
    required this.quartier,
    required this.detail,
    required this.bio,
    required this.gradient,
    required this.emoji,
    this.photoCount = 4,
    this.photoEmojis = const [],
  });

  /// Genre : on infère le pronom à partir du dernier caractère du
  /// prénom (heuristique simple, suffit pour les openers).
  bool get isFemale {
    final n = name.toLowerCase();
    return n.endsWith('e') ||
        n.endsWith('a') ||
        n.endsWith('ie') ||
        ['jade', 'inès', 'olivia', 'sophie', 'lucie', 'romane', 'estelle',
            'anaïs', 'mathilde', 'élise', 'camille']
            .any((p) => n.startsWith(p));
  }
}

/// Type de beat — façon dont le message arrive dans le thread.
enum RomanceBeatType {
  /// Message texte normal.
  text,
  /// Mémo vocal avec waveform mock + durée.
  voiceNote,
  /// Photo partagée (label descriptif rendu en placeholder).
  photoShared,
  /// Appel sonnant — Shen peut décrocher ou ignorer.
  callRing,
  /// Typing visible 4s puis disparaît sans envoi (angoisse).
  typingThenNothing,
  /// L'autre unmatch — fin abrupte.
  unmatch,
  /// Beat de choix pour Shen — 2-4 options.
  choice,
  /// Carte plans Apple Plans simulée (RDV lieu).
  mapLocation,
  /// Statut "vu sans répondre" — pas de message mais l'indicateur change.
  seenNoReply,
  /// Annulation last minute du RDV.
  cancelRdv,
}

/// Un beat dans le template — variantes texte, requireBranch optionnel,
/// setBranch optionnel.
class RomanceBeat {
  /// Offset par rapport au jour du match. 0 = même jour, 1 = lendemain.
  final int dayOffset;
  /// Heure du jour où ce beat se déclenche (0-23). 24 = "indéterminée".
  final int atHour;
  /// Minute facultative (pour timings précis).
  final int atMinute;
  /// Type de beat (texte / voix / photo / call / choice).
  final RomanceBeatType type;
  /// Sender : true = l'autre, false = Shen (cas rare, généralement les
  /// répliques Shen viennent des choix).
  final bool fromThem;
  /// Pool de textes à piocher (1 picked au fire).
  final List<String> textVariants;
  /// Pool de labels photo (pour photoShared) ou nom de lieu (mapLocation).
  final List<String> photoLabels;
  /// Durée vocal en secondes (voiceNote).
  final int? voiceDurationS;
  /// Durée appel en secondes (callRing).
  final int? callDurationS;
  /// Pool de choix Shen si type=choice.
  final List<RomanceChoice> choices;
  /// Si non-null, le beat n'est joué que si cette branche est active.
  final String? requireBranch;
  /// Si non-null, le beat n'est joué que si cette branche N'EST PAS active.
  final String? forbidBranch;
  /// Si non-null, jouer ce beat pose ce tag de branche (auto, sans choix).
  final String? setBranch;
  /// Si non-null, jouer ce beat termine l'arc avec cette raison.
  final String? endsArc;

  const RomanceBeat({
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

/// Une option de réponse de Shen — label court, réplique réelle, delta
/// mood, branche qu'elle pose, ou fin d'arc déclenchée.
class RomanceChoice {
  final String label;
  final String reply;
  final int moodDelta;
  final String? setBranch;
  final String? endsArc;

  const RomanceChoice({
    required this.label,
    required this.reply,
    this.moodDelta = 0,
    this.setBranch,
    this.endsArc,
  });
}

/// Template d'archétype — squelette immuable lu par le scheduler.
class RomanceTemplate {
  final String id;
  final String archetypeLabel;
  final RomanceTone tone;
  final List<RomanceProfile> profilePool;
  final List<RomanceBeat> beats;
  /// Jour minimum à partir duquel l'archétype peut spawn.
  final int minStartDay;
  /// Jour maximum (optionnel, pour archétypes contextuels comme HK).
  final int? maxStartDay;
  /// Poids relatif dans le tirage (1.0 = normal, 0.3 = rare, 3 = très fréquent).
  final double spawnWeight;
  /// Délai minimum (jours) entre 2 spawns du même archétype.
  final int cooldownDays;
  /// Description courte affichée nulle part (debug + doc).
  final String description;

  const RomanceTemplate({
    required this.id,
    required this.archetypeLabel,
    required this.tone,
    required this.profilePool,
    required this.beats,
    this.minStartDay = 1,
    this.maxStartDay,
    this.spawnWeight = 1.0,
    this.cooldownDays = 30,
    this.description = '',
  });
}

/// Un message joué dans le thread — sérialisable (sera persisté).
class PlayedMessage {
  final bool fromThem;
  final int day;
  final String time;
  final RomanceBeatType type;
  final String? text;
  final String? photoLabel;
  final int? voiceDurationS;
  final int? callDurationS;
  final bool callMissed;
  /// Si le beat venait d'un choix Shen, on garde l'index du choix
  /// pour l'analytique narrative.
  final int? chosenIndex;

  const PlayedMessage({
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

/// Instance d'arc romance — état actif, persisté.
class RomanceInstance {
  final String id;
  final String templateId;
  final int profileIdx;        // index dans templatePool
  final int startDay;
  final int startHour;
  final int startMinute;
  final List<PlayedMessage> playedMessages;
  final Set<String> branches;
  final int nextBeatIdx;
  final bool ended;
  final String? endingId;
  /// Indique qu'un beat choice attend une réponse Shen (index du beat
  /// dans template.beats). Null = pas de choix en attente.
  final int? pendingChoiceBeatIdx;

  const RomanceInstance({
    required this.id,
    required this.templateId,
    required this.profileIdx,
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

  RomanceInstance copyWith({
    List<PlayedMessage>? playedMessages,
    Set<String>? branches,
    int? nextBeatIdx,
    bool? ended,
    String? endingId,
    int? pendingChoiceBeatIdx,
    bool clearPendingChoice = false,
  }) =>
      RomanceInstance(
        id: id,
        templateId: templateId,
        profileIdx: profileIdx,
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

  /// Sérialisation JSON pour shared_preferences.
  Map<String, dynamic> toJson() => {
        'id': id,
        'templateId': templateId,
        'profileIdx': profileIdx,
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

  static RomanceInstance fromJson(Map<String, dynamic> j) => RomanceInstance(
        id: j['id'] as String,
        templateId: j['templateId'] as String,
        profileIdx: j['profileIdx'] as int,
        startDay: j['startDay'] as int,
        startHour: j['startHour'] as int,
        startMinute: j['startMinute'] as int,
        playedMessages: ((j['playedMessages'] as List?) ?? [])
            .map((m) => PlayedMessage(
                  fromThem: m['fromThem'] as bool,
                  day: m['day'] as int,
                  time: m['time'] as String,
                  type: RomanceBeatType.values
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
