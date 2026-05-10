// Smoke test : monter ContreJourApp et vérifier que la sidebar se charge.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:contre_jour/main.dart';

void main() {
  testWidgets('App boots and shows sidebar nav', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ContreJourApp()));
    // Un pump pour déclencher les providers async, sans attendre les
    // futures (pas de I/O réel en test — les FutureProvider de scenario
    // resteront en loading state).
    await tester.pump();

    // La sidebar gauche contient les 4 labels en uppercase.
    expect(find.text('CARNET'), findsOneWidget);
    expect(find.text('BANQUE'), findsOneWidget);
    expect(find.text('INSTA'), findsOneWidget);
    expect(find.text('INVIT.'), findsOneWidget);
  });
}
