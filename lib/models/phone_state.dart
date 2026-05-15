/// État global du téléphone — heure du jeu, batterie, signal, lock,
/// app ouverte, badges par app. Tout ce qui rend le téléphone vivant
/// passe par là.
///
/// La narration n'est plus calée sur 112 jours linéaires : on suit
/// les 6 épisodes (`currentEpisodeId`, `currentBeatIdx`). Le champ
/// `currentDay` reste exposé — il est dérivé du beat courant et sert
/// uniquement à filtrer le contenu déjà visible dans les apps.
class PhoneState {
  /// Jour gameworld atteint (= jour du beat courant). Utilisé par les
  /// apps pour ne montrer que ce qui s'est déjà passé.
  final int currentDay;
  final int hour;                // 0-23
  final int minute;              // 0-59
  final int battery;             // 0-100, descend selon les actions
  final SignalType signal;       // wifi / 5g / lte / none
  final bool isLocked;           // true = écran verrouillé
  final bool dndEnabled;         // mode Ne Pas Déranger (auto la nuit)
  final String? openAppId;       // id de l'app ouverte, null = home
  final Map<String, int> badges; // notif unread par app
  final Set<String> unlockedApps; // apps visibles sur le home

  // ─── Progression épisodique ─────────────────────────────────────
  /// Identifiant de l'épisode courant (`collision`, `contrat`, …).
  final String currentEpisodeId;
  /// Position du beat dans l'épisode courant (0-indexed).
  final int currentBeatIdx;

  // ─── Économie / vie ─────────────────────────────────────────────
  /// Mood 0-10. Démarre à 5.
  final int mood;
  /// Réputation 0-∞. Démarre à 0.
  final int reputation;
  /// IDs d'items déjà achetés (référence kShopCatalog).
  final Set<String> ownedItems;
  /// Mouvements bancaires dynamiques (achats / virements en cours de jeu).
  /// Format : (label, amount, day, time, emoji).
  final List<DynamicMovement> dynamicMovements;

  const PhoneState({
    this.currentDay = 1,
    this.hour = 7,
    this.minute = 30,
    this.battery = 87,
    this.signal = SignalType.wifi,
    this.isLocked = true,
    this.dndEnabled = false,
    this.openAppId,
    this.badges = const {},
    this.unlockedApps = const {
      'messages', 'telephone', 'whatsapp', 'instagram', 'banque',
      'ubereats', 'photos', 'notes', 'calendrier', 'tinder', 'cloud',
    },
    this.currentEpisodeId = 'collision',
    this.currentBeatIdx = 0,
    this.mood = 5,
    this.reputation = 0,
    this.ownedItems = const {},
    this.dynamicMovements = const [],
  });

  /// Période visuelle pour le skin (palette qui réchauffe ou refroidit).
  TimeOfDayBand get band {
    if (hour < 6) return TimeOfDayBand.nuit;
    if (hour < 9) return TimeOfDayBand.matin;
    if (hour < 12) return TimeOfDayBand.jour;
    if (hour < 17) return TimeOfDayBand.midi;
    if (hour < 20) return TimeOfDayBand.couchant;
    if (hour < 23) return TimeOfDayBand.soir;
    return TimeOfDayBand.nuit;
  }

  /// Heure formatée pour la status bar (HH:MM).
  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  PhoneState copyWith({
    int? currentDay,
    int? hour,
    int? minute,
    int? battery,
    SignalType? signal,
    bool? isLocked,
    bool? dndEnabled,
    String? openAppId,
    bool clearOpenApp = false,
    Map<String, int>? badges,
    Set<String>? unlockedApps,
    String? currentEpisodeId,
    int? currentBeatIdx,
    int? mood,
    int? reputation,
    Set<String>? ownedItems,
    List<DynamicMovement>? dynamicMovements,
  }) =>
      PhoneState(
        currentDay: currentDay ?? this.currentDay,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        battery: battery ?? this.battery,
        signal: signal ?? this.signal,
        isLocked: isLocked ?? this.isLocked,
        dndEnabled: dndEnabled ?? this.dndEnabled,
        openAppId: clearOpenApp ? null : (openAppId ?? this.openAppId),
        badges: badges ?? this.badges,
        unlockedApps: unlockedApps ?? this.unlockedApps,
        currentEpisodeId: currentEpisodeId ?? this.currentEpisodeId,
        currentBeatIdx: currentBeatIdx ?? this.currentBeatIdx,
        mood: (mood ?? this.mood).clamp(0, 10),
        reputation: (reputation ?? this.reputation).clamp(0, 9999),
        ownedItems: ownedItems ?? this.ownedItems,
        dynamicMovements: dynamicMovements ?? this.dynamicMovements,
      );
}

/// Mouvement bancaire ajouté en cours de jeu (achat, virement…).
class DynamicMovement {
  final String label;
  final int amount; // négatif = sortie
  final int day;
  final String time;
  final String emoji;

  const DynamicMovement({
    required this.label,
    required this.amount,
    required this.day,
    required this.time,
    required this.emoji,
  });
}

enum SignalType { wifi, fiveG, lte, none }

enum TimeOfDayBand { matin, jour, midi, couchant, soir, nuit }
