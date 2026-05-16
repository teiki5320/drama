import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/ubereats/courses.dart';
import '../data/ubereats/customers.dart';
import '../models/ubereats.dart';

/// État des stats UberEats Shen — courses acceptées / refusées / livrées,
/// gains, pourboires, ratings clients.
@immutable
class UberStatsState {
  /// IDs des courses acceptées et terminées.
  final Set<String> completedCourseIds;
  /// IDs des courses refusées (compte pour acceptance rate).
  final Set<String> refusedCourseIds;
  /// Gains totaux cumulés (€).
  final double totalEarnings;
  /// Pourboires totaux cumulés (€).
  final double totalTips;
  /// Notes des clients laissées (id course → note 1-5).
  final Map<String, int> ratings;
  /// Notes textuelles laissées par clients (id course → texte).
  final Map<String, String> customerNotes;
  /// Acceptance rate calculé.
  double get acceptanceRate {
    final total = completedCourseIds.length + refusedCourseIds.length;
    if (total == 0) return 1.0;
    return completedCourseIds.length / total;
  }
  /// Note moyenne client (4.5 par défaut).
  double get avgRating {
    if (ratings.isEmpty) return 4.5;
    final sum = ratings.values.fold(0, (a, b) => a + b);
    return sum / ratings.length;
  }

  const UberStatsState({
    this.completedCourseIds = const {},
    this.refusedCourseIds = const {},
    this.totalEarnings = 0.0,
    this.totalTips = 0.0,
    this.ratings = const {},
    this.customerNotes = const {},
  });

  UberStatsState copyWith({
    Set<String>? completedCourseIds,
    Set<String>? refusedCourseIds,
    double? totalEarnings,
    double? totalTips,
    Map<String, int>? ratings,
    Map<String, String>? customerNotes,
  }) =>
      UberStatsState(
        completedCourseIds: completedCourseIds ?? this.completedCourseIds,
        refusedCourseIds: refusedCourseIds ?? this.refusedCourseIds,
        totalEarnings: totalEarnings ?? this.totalEarnings,
        totalTips: totalTips ?? this.totalTips,
        ratings: ratings ?? this.ratings,
        customerNotes: customerNotes ?? this.customerNotes,
      );

  Map<String, dynamic> toJson() => {
        'completed': completedCourseIds.toList(),
        'refused': refusedCourseIds.toList(),
        'earnings': totalEarnings,
        'tips': totalTips,
        'ratings': ratings,
        'notes': customerNotes,
      };

  static UberStatsState fromJson(Map<String, dynamic> j) => UberStatsState(
        completedCourseIds:
            ((j['completed'] as List?) ?? []).map((e) => e as String).toSet(),
        refusedCourseIds:
            ((j['refused'] as List?) ?? []).map((e) => e as String).toSet(),
        totalEarnings: (j['earnings'] as num?)?.toDouble() ?? 0.0,
        totalTips: (j['tips'] as num?)?.toDouble() ?? 0.0,
        ratings: ((j['ratings'] as Map?) ?? {})
            .map((k, v) => MapEntry(k as String, v as int)),
        customerNotes: ((j['notes'] as Map?) ?? {})
            .map((k, v) => MapEntry(k as String, v as String)),
      );
}

const _kPrefsKey = 'ubereats_stats_v1';

class UberStatsNotifier extends StateNotifier<UberStatsState> {
  UberStatsNotifier() : super(const UberStatsState()) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPrefsKey);
    if (raw == null) return;
    try {
      state = UberStatsState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, jsonEncode(state.toJson()));
  }

  /// Accepter une course → calculer earnings + tip + rating.
  void acceptCourse(UberCourse course) {
    final customer = kCustomers.firstWhere(
      (c) => c.id == course.customerId,
      orElse: () => kCustomers.first,
    );
    // Tip aléatoire autour de avgTip (±30 %)
    final tipBase = customer.avgTip;
    final tipJitter = (course.id.hashCode % 60 - 30) / 100.0; // ±30 %
    final tip = (tipBase * (1.0 + tipJitter)).clamp(0.0, 30.0);
    final earnings = course.totalPayout + tip;
    // Rating aléatoire 4-5 (3-5 pour picky, 2-4 pour gymGirl no-tip)
    var rating = 5;
    switch (customer.kind) {
      case CustomerKind.picky:
        rating = 2 + (course.id.hashCode % 3); // 2-4
        break;
      case CustomerKind.gymGirl:
        rating = 4;
        break;
      default:
        rating = 4 + (course.id.hashCode % 2); // 4-5
    }
    // Note client piochée
    final noteIdx = course.id.hashCode.abs() % (customer.notesPool.isEmpty
        ? 1
        : customer.notesPool.length);
    final note = customer.notesPool.isNotEmpty
        ? customer.notesPool[noteIdx]
        : '';
    state = state.copyWith(
      completedCourseIds: {...state.completedCourseIds, course.id},
      totalEarnings: state.totalEarnings + earnings,
      totalTips: state.totalTips + tip,
      ratings: {...state.ratings, course.id: rating},
      customerNotes:
          note.isNotEmpty ? {...state.customerNotes, course.id: note} : state.customerNotes,
    );
    _persist();
  }

  /// Refuser une course.
  void refuseCourse(UberCourse course) {
    state = state.copyWith(
      refusedCourseIds: {...state.refusedCourseIds, course.id},
    );
    _persist();
  }

  /// Reset (debug).
  void reset() {
    state = const UberStatsState();
    _persist();
  }
}

final uberStatsProvider =
    StateNotifierProvider<UberStatsNotifier, UberStatsState>(
        (ref) => UberStatsNotifier());

/// Provider dérivé : courses dispos pour un jour donné, filtrées
/// (pas celles déjà acceptées/refusées).
final availableCoursesProvider =
    Provider.family<List<UberCourse>, int>((ref, day) {
  final stats = ref.watch(uberStatsProvider);
  return coursesForDay(day)
      .where((c) =>
          !stats.completedCourseIds.contains(c.id) &&
          !stats.refusedCourseIds.contains(c.id))
      .toList();
});

/// Provider dérivé : stats jour courant (livraisons / gains / tips).
class DailyStats {
  final int livraisons;
  final double earnings;
  final double tips;
  const DailyStats({
    required this.livraisons,
    required this.earnings,
    required this.tips,
  });
}

final dailyStatsProvider = Provider.family<DailyStats, int>((ref, day) {
  final stats = ref.watch(uberStatsProvider);
  // On compte les courses livrées dont l'ID commence par "c_jX_" pour ce jour.
  final completed = stats.completedCourseIds.where((id) {
    final m = RegExp(r'^c_j(\d+)_').firstMatch(id);
    if (m == null) return true; // loops sans préfixe jour, ignore
    final cd = int.tryParse(m.group(1)!) ?? 0;
    return cd == day;
  }).toList();
  var earnings = 0.0;
  var tips = 0.0;
  for (final cid in completed) {
    final c = kCourses.firstWhere(
      (cc) => cc.id == cid,
      orElse: () => kCourses.first,
    );
    final customer = kCustomers.firstWhere(
      (cc) => cc.id == c.customerId,
      orElse: () => kCustomers.first,
    );
    earnings += c.totalPayout;
    tips += customer.avgTip;
  }
  return DailyStats(
    livraisons: completed.length,
    earnings: earnings,
    tips: tips,
  );
});
