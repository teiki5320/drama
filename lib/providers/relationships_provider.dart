import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/relationship.dart';

/// Carte contactId → Relationship. Mutable via le notifier.
final relationshipsProvider =
    StateNotifierProvider<RelationshipsNotifier, Map<String, Relationship>>(
  (ref) => RelationshipsNotifier(),
);

class RelationshipsNotifier
    extends StateNotifier<Map<String, Relationship>> {
  RelationshipsNotifier() : super(Map.from(kInitialRelationships));

  /// Applique un delta sur la relation d'un contact.
  void apply(String contactId, RelationshipDelta delta) {
    final current =
        state[contactId] ?? const Relationship(trust: 50, loyalty: 50);
    state = {...state, contactId: current.apply(delta)};
  }

  /// Lookup pratique (lecture).
  Relationship of(String contactId) =>
      state[contactId] ??
      const Relationship(trust: 50, loyalty: 50);
}
