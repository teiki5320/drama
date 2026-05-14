import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/day_events.dart';
import '../models/phone_state.dart';

/// Singleton Riverpod du PhoneState.
final phoneStateProvider =
    StateNotifierProvider<PhoneStateNotifier, PhoneState>(
  PhoneStateNotifier.new,
);

/// Provider qui expose le dernier événement déclenché — l'UI peut
/// l'observer pour afficher un banner notification quand il change.
final lastTriggeredEventProvider = StateProvider<DayEvent?>((ref) => null);

class PhoneStateNotifier extends StateNotifier<PhoneState> {
  PhoneStateNotifier(this._ref) : super(const PhoneState());

  /// Ref injectable pour permettre de déclencher des side-effects
  /// (notifs, badges).
  final Ref _ref;

  /// Avance l'heure de `minutes`. Roule sur 24h. Déclenche les
  /// événements DayEvent qui tombent dans l'intervalle franchi.
  void advanceTime(int minutes) {
    final from = state;
    var total = from.hour * 60 + from.minute + minutes;
    final newDay = from.currentDay + (total ~/ (24 * 60));
    total %= 24 * 60;
    final h = total ~/ 60;
    final m = total % 60;
    state = state.copyWith(
      currentDay: newDay,
      hour: h,
      minute: m,
      dndEnabled: h >= 23 || h < 7,
    );
    // Déclenche les events traversés
    final events = eventsBetween(
      fromDay: from.currentDay,
      fromHour: from.hour,
      fromMinute: from.minute,
      toDay: newDay,
      toHour: h,
      toMinute: m,
    );
    for (final e in events) {
      _fireEvent(e);
    }
  }

  void _fireEvent(DayEvent e) {
    // Pousse les badges
    final newBadges = Map<String, int>.from(state.badges);
    for (final appId in e.apps) {
      newBadges[appId] = (newBadges[appId] ?? 0) + 1;
    }
    state = state.copyWith(badges: newBadges);
    // Expose l'event pour que l'UI affiche un banner
    _ref.read(lastTriggeredEventProvider.notifier).state = e;
  }

  /// Passe au lendemain matin (réveil à 6h30 par défaut), reverrouille
  /// l'écran (= chaque jour commence sur le lock screen).
  void advanceDay() {
    state = state.copyWith(
      currentDay: state.currentDay + 1,
      hour: 6,
      minute: 30,
      isLocked: true,
      dndEnabled: false,
      clearOpenApp: true,
      battery: (state.battery - 15).clamp(20, 100),
    );
  }

  /// Déverrouille l'écran (swipe up depuis le lock screen).
  void unlock() => state = state.copyWith(isLocked: false);

  /// Reverrouille (bouton power, ou auto-lock après inactivité).
  void lock() => state = state.copyWith(isLocked: true, clearOpenApp: true);

  /// Ouvre une app (depuis le home screen).
  void openApp(String id) => state = state.copyWith(openAppId: id);

  /// Ferme l'app courante (retour home).
  void closeApp() => state = state.copyWith(clearOpenApp: true);

  /// Modifie le signal (Wi-Fi chez Heng, 5G livraison, none dans le métro).
  void setSignal(SignalType s) => state = state.copyWith(signal: s);

  /// Petite consommation batterie sur action (1-3% par action significative).
  void consumeBattery(int amount) =>
      state = state.copyWith(battery: (state.battery - amount).clamp(0, 100));

  /// Augmente le badge d'une app (nouvelle notif).
  void addBadge(String appId, [int n = 1]) {
    final badges = Map<String, int>.from(state.badges);
    badges[appId] = (badges[appId] ?? 0) + n;
    state = state.copyWith(badges: badges);
  }

  /// Vide le badge d'une app (l'utilisateur a vu).
  void clearBadge(String appId) {
    final badges = Map<String, int>.from(state.badges)..remove(appId);
    state = state.copyWith(badges: badges);
  }

  /// Débloque une app jusqu'ici cachée.
  void unlockApp(String appId) {
    final apps = {...state.unlockedApps, appId};
    state = state.copyWith(unlockedApps: apps);
  }

  /// Achat d'un item du catalogue. Vérifie solde et seuils mood/réputation.
  /// Renvoie true si l'achat est passé.
  bool buyItem({
    required String id,
    required String name,
    required String emoji,
    required int price,
    required int moodGain,
    required int reputationGain,
  }) {
    final mvt = DynamicMovement(
      label: name,
      amount: -price,
      day: state.currentDay,
      time: state.timeLabel,
      emoji: emoji,
    );
    state = state.copyWith(
      ownedItems: {...state.ownedItems, id},
      dynamicMovements: [...state.dynamicMovements, mvt],
      mood: state.mood + moodGain,
      reputation: state.reputation + reputationGain,
      battery: (state.battery - 1).clamp(0, 100),
    );
    return true;
  }
}
