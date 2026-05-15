import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/day_events.dart';

/// Une notif persistante affichée sur le lock screen — empilées par
/// ordre antéchronologique. Quand l'utilisateur déverrouille, on les
/// garde ; quand il reverrouille, elles restent visibles jusqu'à un
/// reset ou une nouvelle journée.
class LockNotif {
  final String appId;
  final String title;
  final String body;
  final int day;
  final int hour;
  final int minute;

  const LockNotif({
    required this.appId,
    required this.title,
    required this.body,
    required this.day,
    required this.hour,
    required this.minute,
  });

  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  factory LockNotif.fromEvent(DayEvent e) => LockNotif(
        appId: e.notifAppId,
        title: e.notifTitle,
        body: e.notifBody,
        day: e.day,
        hour: e.hour,
        minute: e.minute,
      );
}

/// Pile des notifs affichables sur le lock screen.
final lockNotificationsProvider =
    StateNotifierProvider<LockNotificationsNotifier, List<LockNotif>>(
  (ref) => LockNotificationsNotifier(),
);

class LockNotificationsNotifier extends StateNotifier<List<LockNotif>> {
  LockNotificationsNotifier() : super(const []);

  void push(LockNotif n) {
    // On insère en tête (antéchronologique).
    state = [n, ...state];
  }

  void clear() => state = const [];
}
