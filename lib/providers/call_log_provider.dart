import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entrée dynamique du journal Téléphone — les appels VÉCUS (acceptés,
/// refusés, manqués en jeu) laissent désormais une trace, avec leur
/// transcript relisible. Persisté (`call_log_v1`).
@immutable
class DynamicCall {
  final int day;
  final String time;
  final String label;
  /// 'accepted' | 'refused' | 'missed'
  final String kind;
  final String durationLabel;
  /// Transcript relisible (ce que l'appelant a dit si Shen a décroché).
  final String? transcript;

  const DynamicCall({
    required this.day,
    required this.time,
    required this.label,
    required this.kind,
    this.durationLabel = '0:00',
    this.transcript,
  });

  Map<String, dynamic> toJson() => {
        'day': day,
        'time': time,
        'label': label,
        'kind': kind,
        'duration': durationLabel,
        'transcript': transcript,
      };

  static DynamicCall fromJson(Map<String, dynamic> j) => DynamicCall(
        day: j['day'] as int,
        time: j['time'] as String,
        label: j['label'] as String,
        kind: j['kind'] as String,
        durationLabel: j['duration'] as String? ?? '0:00',
        transcript: j['transcript'] as String?,
      );
}

final callLogProvider =
    StateNotifierProvider<CallLogNotifier, List<DynamicCall>>(
  (ref) => CallLogNotifier(),
);

class CallLogNotifier extends StateNotifier<List<DynamicCall>> {
  static const _kKey = 'call_log_v1';

  CallLogNotifier() : super(const []) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null) return;
      state = ((jsonDecode(raw) as List))
          .map((e) => DynamicCall.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs
          .setString(_kKey, jsonEncode(state.map((c) => c.toJson()).toList()));
    } catch (_) {}
  }

  void log(DynamicCall call) {
    state = [...state, call];
    _save();
  }

  Future<void> reset() async {
    state = const [];
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kKey);
    } catch (_) {}
  }
}
