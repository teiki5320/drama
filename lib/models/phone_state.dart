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
  /// Photos prises par le joueur via la Caméra.
  final List<UserPhoto> userPhotos;
  /// Posts Instagram publiés par Shen (générés par les achats boutique
  /// marqués `generatesInstaPost`). Affichés en tête du feed + profil.
  final List<UserInstaPost> instaPosts;

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
    // Au démarrage seules ces apps sont accessibles. Les autres
    // apparaissent grisées sur le home et lèvent un snack
    // « Pas encore disponible ». Elles se débloquent au fil du
    // scénario via `unlockApp(id)`, ou via l'App Store (qui est
    // accessible dès le départ pour permettre les installations).
    this.unlockedApps = const {
      'messages', 'calendrier', 'reglages', 'instagram', 'camera',
      'appstore', 'regie',
    },
    this.currentEpisodeId = 'avant_la_lumiere',
    this.currentBeatIdx = 0,
    this.mood = 5,
    this.reputation = 0,
    this.ownedItems = const {},
    this.dynamicMovements = const [],
    this.userPhotos = const [],
    this.instaPosts = const [],
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
    List<UserPhoto>? userPhotos,
    List<UserInstaPost>? instaPosts,
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
        userPhotos: userPhotos ?? this.userPhotos,
        instaPosts: instaPosts ?? this.instaPosts,
      );
}

/// Post Instagram publié par Shen elle-même — généré quand un achat
/// boutique porte `generatesInstaPost` (légende + emoji fournis par le
/// catalogue). Les likes sont seedés de façon déterministe à l'achat.
class UserInstaPost {
  final String id;      // 'user_<itemId>'
  final int day;
  final String time;    // "14:32"
  final String caption;
  final String emoji;
  final int likes;

  const UserInstaPost({
    required this.id,
    required this.day,
    required this.time,
    required this.caption,
    required this.emoji,
    required this.likes,
  });
}

/// Photo prise par le joueur via l'app Caméra (au lieu d'apparaître
/// canoniquement). On stocke uniquement les métadonnées + un gradient
/// auto-généré et un emoji selon le contexte (heure, mood, lieu).
class UserPhoto {
  final int day;
  final int hour;
  final int minute;
  final String emoji;
  /// Deux couleurs hex pour le gradient de placeholder.
  final List<int> gradient;
  /// Notes courtes auto-générées (souvenir).
  final String caption;
  /// Image asset path : si non-null, on rend la vraie image au lieu
  /// du gradient + emoji. Set par takePhoto() depuis un pool d'images.
  final String? imagePath;

  const UserPhoto({
    required this.day,
    required this.hour,
    required this.minute,
    required this.emoji,
    required this.gradient,
    required this.caption,
    this.imagePath,
  });

  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
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
