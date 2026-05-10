// Smoke test : monter ContreJourApp et vérifier qu'il s'affiche sans
// crash. Au premier lancement on tombe sur l'onboarding (Bienvenue). Si
// le flag hasSeenOnboarding est posé, on tombe direct sur la sidebar.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:contre_jour/main.dart';

void main() {
  testWidgets('First launch shows the onboarding welcome page',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await tester.pumpWidget(const ProviderScope(child: ContreJourApp()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Bienvenue'), findsOneWidget);
    expect(find.text('Commencer le drama'), findsOneWidget);
  });

  testWidgets('Returning launch shows the sidebar nav',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'hasSeenOnboarding_v1': true,
    });
    await tester.pumpWidget(const ProviderScope(child: ContreJourApp()));
    await tester.pumpAndSettle();
    expect(find.text('CARNET'), findsOneWidget);
    expect(find.text('BANQUE'), findsOneWidget);
    expect(find.text('INSTA'), findsOneWidget);
    expect(find.text('INVIT.'), findsOneWidget);
  });
}
