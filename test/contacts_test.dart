import 'package:flutter_test/flutter_test.dart';

import 'package:drama/src/contacts.dart';
import 'package:drama/src/engine.dart';

void main() {
  test('chaque contact du jeu a une fiche', () {
    for (final def in kThreadDefs) {
      expect(kContacts.containsKey(def.id), isTrue,
          reason: 'fiche manquante pour ${def.id}');
    }
  });

  test('le numéro inconnu reste sans visage ni infos', () {
    final inconnu = kContacts['inconnu']!;
    expect(inconnu.fields, isEmpty);
    expect(inconnu.canBlock, isTrue);
    final def = kThreadDefs.firstWhere((d) => d.id == 'inconnu');
    expect(def.avatarAsset, isNull,
        reason: 'pas de photo : ce serait révéler Tristan');
  });

  test('Maman et Camille ont leur photo', () {
    for (final id in ['maman', 'camille']) {
      final def = kThreadDefs.firstWhere((d) => d.id == id);
      expect(def.avatarAsset, isNotNull);
    }
  });
}
