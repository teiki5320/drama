import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/phone_state.dart';
import '../models/relationship.dart';
import '../providers/sent_replies_provider.dart';

/// Persiste les 3 sources de vérité du jeu dans shared_preferences :
/// PhoneState, relationships, sentReplies. On rejoue exactement où le
/// joueur s'est arrêté.
class PersistenceService {
  static const _kPhoneState = 'phone_state_v1';
  static const _kRelationships = 'relationships_v1';
  static const _kSentReplies = 'sent_replies_v1';

  static Future<SharedPreferences> _prefs() async =>
      SharedPreferences.getInstance();

  // ── PhoneState ──────────────────────────────────────────────────
  static Future<void> savePhoneState(PhoneState s) async {
    final p = await _prefs();
    await p.setString(_kPhoneState, jsonEncode(_phoneStateToMap(s)));
  }

  static Future<PhoneState?> loadPhoneState() async {
    final p = await _prefs();
    final raw = p.getString(_kPhoneState);
    if (raw == null) return null;
    try {
      return _phoneStateFromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ── Relationships ───────────────────────────────────────────────
  static Future<void> saveRelationships(
      Map<String, Relationship> rels) async {
    final p = await _prefs();
    final map = rels.map((k, v) => MapEntry(k, _relToMap(v)));
    await p.setString(_kRelationships, jsonEncode(map));
  }

  static Future<Map<String, Relationship>?> loadRelationships() async {
    final p = await _prefs();
    final raw = p.getString(_kRelationships);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return m.map(
        (k, v) => MapEntry(k, _relFromMap(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return null;
    }
  }

  // ── SentReplies ─────────────────────────────────────────────────
  static Future<void> saveSentReplies(Map<String, SentReply> replies) async {
    final p = await _prefs();
    final map = replies.map((k, v) => MapEntry(k, _replyToMap(v)));
    await p.setString(_kSentReplies, jsonEncode(map));
  }

  static Future<Map<String, SentReply>?> loadSentReplies() async {
    final p = await _prefs();
    final raw = p.getString(_kSentReplies);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return m.map(
        (k, v) => MapEntry(k, _replyFromMap(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return null;
    }
  }

  /// Vide tout — utilisé par Réglages > Reset partie.
  static Future<void> reset() async {
    final p = await _prefs();
    await p.remove(_kPhoneState);
    await p.remove(_kRelationships);
    await p.remove(_kSentReplies);
  }

  // ─── Mappers ────────────────────────────────────────────────────
  static Map<String, dynamic> _phoneStateToMap(PhoneState s) => {
        'currentDay': s.currentDay,
        'hour': s.hour,
        'minute': s.minute,
        'battery': s.battery,
        'signal': s.signal.index,
        'isLocked': s.isLocked,
        'dndEnabled': s.dndEnabled,
        'openAppId': s.openAppId,
        'badges': s.badges,
        'unlockedApps': s.unlockedApps.toList(),
        'currentEpisodeId': s.currentEpisodeId,
        'currentBeatIdx': s.currentBeatIdx,
        'mood': s.mood,
        'reputation': s.reputation,
        'ownedItems': s.ownedItems.toList(),
        'dynamicMovements': s.dynamicMovements
            .map((m) => {
                  'label': m.label,
                  'amount': m.amount,
                  'day': m.day,
                  'time': m.time,
                  'emoji': m.emoji,
                })
            .toList(),
      };

  static PhoneState _phoneStateFromMap(Map<String, dynamic> j) => PhoneState(
        currentDay: j['currentDay'] as int? ?? 1,
        hour: j['hour'] as int? ?? 7,
        minute: j['minute'] as int? ?? 30,
        battery: j['battery'] as int? ?? 87,
        signal: SignalType.values[(j['signal'] as int?) ?? 0],
        isLocked: j['isLocked'] as bool? ?? true,
        dndEnabled: j['dndEnabled'] as bool? ?? false,
        openAppId: j['openAppId'] as String?,
        badges: (j['badges'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, v as int)),
        unlockedApps: ((j['unlockedApps'] as List<dynamic>?) ?? [])
            .map((e) => e as String)
            .toSet(),
        currentEpisodeId: j['currentEpisodeId'] as String? ?? 'collision',
        currentBeatIdx: j['currentBeatIdx'] as int? ?? 0,
        mood: j['mood'] as int? ?? 5,
        reputation: j['reputation'] as int? ?? 0,
        ownedItems: ((j['ownedItems'] as List<dynamic>?) ?? [])
            .map((e) => e as String)
            .toSet(),
        dynamicMovements: ((j['dynamicMovements'] as List<dynamic>?) ?? [])
            .map((e) => e as Map<String, dynamic>)
            .map((m) => DynamicMovement(
                  label: m['label'] as String,
                  amount: m['amount'] as int,
                  day: m['day'] as int,
                  time: m['time'] as String,
                  emoji: m['emoji'] as String,
                ))
            .toList(),
      );

  static Map<String, dynamic> _relToMap(Relationship r) => {
        'trust': r.trust,
        'attraction': r.attraction,
        'jealousy': r.jealousy,
        'dependency': r.dependency,
        'suspicion': r.suspicion,
        'loyalty': r.loyalty,
      };

  static Relationship _relFromMap(Map<String, dynamic> j) => Relationship(
        trust: j['trust'] as int? ?? 0,
        attraction: j['attraction'] as int? ?? 0,
        jealousy: j['jealousy'] as int? ?? 0,
        dependency: j['dependency'] as int? ?? 0,
        suspicion: j['suspicion'] as int? ?? 0,
        loyalty: j['loyalty'] as int? ?? 0,
      );

  static Map<String, dynamic> _replyToMap(SentReply r) => {
        'contactId': r.contactId,
        'beatId': r.beatId,
        'text': r.text,
        'time': r.time,
        'day': r.day,
      };

  static SentReply _replyFromMap(Map<String, dynamic> j) => SentReply(
        contactId: j['contactId'] as String,
        beatId: j['beatId'] as String,
        text: j['text'] as String,
        time: j['time'] as String,
        day: j['day'] as int,
      );
}
