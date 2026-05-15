import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Timestamp réel (en epoch ms) de la dernière ouverture de l'app par
/// le joueur. Sert au lock screen pour afficher un « Tu reviens. »
/// quand l'app a été fermée plus de 6h.
final lastOpenProvider = StateProvider<DateTime?>((ref) => null);

const _kLastOpen = 'last_open_ts_v1';

Future<DateTime?> loadLastOpen() async {
  final p = await SharedPreferences.getInstance();
  final ms = p.getInt(_kLastOpen);
  if (ms == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(ms);
}

Future<void> saveLastOpen(DateTime t) async {
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kLastOpen, t.millisecondsSinceEpoch);
}
