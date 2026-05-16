import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/map_places.dart';
import '../data/ubereats/courses.dart';
import '../data/ubereats/customers.dart';
import '../data/ubereats/restaurants.dart';
import '../models/map_place.dart';
import 'ubereats_stats_provider.dart';

/// État des visites de l'app Plans. Stocke les `placeId` que Shen a
/// visités, plus les km parcourus cumulés.
@immutable
class MapVisitsState {
  final Set<String> visitedPlaceIds;
  final double kmTotal;

  const MapVisitsState({
    this.visitedPlaceIds = const {},
    this.kmTotal = 0.0,
  });

  MapVisitsState copyWith({
    Set<String>? visitedPlaceIds,
    double? kmTotal,
  }) =>
      MapVisitsState(
        visitedPlaceIds: visitedPlaceIds ?? this.visitedPlaceIds,
        kmTotal: kmTotal ?? this.kmTotal,
      );

  Map<String, dynamic> toJson() => {
        'visited': visitedPlaceIds.toList(),
        'kmTotal': kmTotal,
      };

  static MapVisitsState fromJson(Map<String, dynamic> j) => MapVisitsState(
        visitedPlaceIds:
            ((j['visited'] as List?) ?? []).map((e) => e as String).toSet(),
        kmTotal: (j['kmTotal'] as num?)?.toDouble() ?? 0.0,
      );
}

const _kPrefsKey = 'map_visits_v1';

class MapVisitsNotifier extends StateNotifier<MapVisitsState> {
  MapVisitsNotifier() : super(const MapVisitsState()) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPrefsKey);
    if (raw == null) return;
    try {
      state = MapVisitsState.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, jsonEncode(state.toJson()));
  }

  /// Marque un lieu comme visité + ajoute des km.
  void visit(String placeId, {double km = 0.0}) {
    if (state.visitedPlaceIds.contains(placeId)) {
      // Déjà visité, on ajoute juste les km
      state = state.copyWith(kmTotal: state.kmTotal + km);
    } else {
      state = state.copyWith(
        visitedPlaceIds: {...state.visitedPlaceIds, placeId},
        kmTotal: state.kmTotal + km,
      );
    }
    _persist();
  }

  /// Reset (debug).
  void reset() {
    state = const MapVisitsState();
    _persist();
  }
}

final mapVisitsProvider =
    StateNotifierProvider<MapVisitsNotifier, MapVisitsState>(
        (ref) => MapVisitsNotifier());

/// Provider dérivé : lieux visibles selon currentDay (révélés ou
/// visités). On exclut les lieux dont `requiresDay` n'est pas atteint
/// ET qui n'ont pas été visités.
final visiblePlacesProvider = Provider.family<List<MapPlace>, int>((ref, day) {
  final visits = ref.watch(mapVisitsProvider);
  return kMapPlaces.where((p) {
    if (p.revealedAtStart) return true;
    if (p.requiresDay != null && day >= p.requiresDay!) return true;
    if (visits.visitedPlaceIds.contains(p.id)) return true;
    return false;
  }).toList();
});

/// Provider dérivé : stats globales calculées.
final mapStatsProvider = Provider<MapStats>((ref) {
  final visits = ref.watch(mapVisitsProvider);
  final visitsPerCat = <PlaceCategory, int>{};
  for (final id in visits.visitedPlaceIds) {
    final p = kMapPlaces.where((pp) => pp.id == id).firstOrNull;
    if (p == null) continue;
    visitsPerCat[p.category] = (visitsPerCat[p.category] ?? 0) + 1;
  }
  return MapStats(
    placesVisited: visits.visitedPlaceIds.length,
    placesTotal: kMapPlaces.length,
    kmTotal: visits.kmTotal,
    visitsPerCategory: visitsPerCat,
  );
});

/// Provider qui propage automatiquement les courses UberEats livrées
/// en visites sur Plans (restaurant + client).
final mapVisitsAutoSyncProvider = Provider<void>((ref) {
  final uberStats = ref.watch(uberStatsProvider);
  // À chaque ajout d'une course livrée, on marque les pins liés.
  for (final cid in uberStats.completedCourseIds) {
    final course = kCourses.where((c) => c.id == cid).firstOrNull;
    if (course == null) continue;
    final r = restaurantById(course.restaurantId);
    final cl = customerById(course.customerId);
    final restoPlaceId = 'p_${r.id}';
    final customerPlaceId = 'p_${cl.id}';
    final visits = ref.read(mapVisitsProvider);
    if (!visits.visitedPlaceIds.contains(restoPlaceId) ||
        !visits.visitedPlaceIds.contains(customerPlaceId)) {
      Future.microtask(() {
        ref.read(mapVisitsProvider.notifier).visit(
              restoPlaceId,
              km: course.distanceKm / 2,
            );
        ref.read(mapVisitsProvider.notifier).visit(
              customerPlaceId,
              km: course.distanceKm / 2,
            );
      });
    }
  }
});
