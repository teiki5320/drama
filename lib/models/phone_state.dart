/// État global du téléphone — heure du jeu, batterie, signal, lock,
/// app ouverte, badges par app. Tout ce qui rend le téléphone vivant
/// passe par là.
class PhoneState {
  final int currentDay;          // J1..J112
  final int hour;                // 0-23
  final int minute;              // 0-59
  final int battery;             // 0-100, descend selon les actions
  final SignalType signal;       // wifi / 5g / lte / none
  final bool isLocked;           // true = écran verrouillé
  final bool dndEnabled;         // mode Ne Pas Déranger (auto la nuit)
  final String? openAppId;       // id de l'app ouverte, null = home
  final Map<String, int> badges; // notif unread par app
  final Set<String> unlockedApps; // apps visibles sur le home

  const PhoneState({
    this.currentDay = 1,
    this.hour = 6,
    this.minute = 30,
    this.battery = 87,
    this.signal = SignalType.wifi,
    this.isLocked = true,
    this.dndEnabled = false,
    this.openAppId,
    this.badges = const {},
    this.unlockedApps = const {
      'messages', 'telephone', 'whatsapp', 'instagram', 'banque',
      'ubereats', 'photos', 'notes', 'calendrier', 'tinder',
    },
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
      );
}

enum SignalType { wifi, fiveG, lte, none }

enum TimeOfDayBand { matin, jour, midi, couchant, soir, nuit }
