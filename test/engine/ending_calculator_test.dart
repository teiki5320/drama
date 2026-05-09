import 'package:contre_jour/engine/ending_calculator.dart';
import 'package:contre_jour/models/game_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeEnding', () {
    test('mom not paid -> deuil', () {
      const s = GameState(isMomTreatmentPaid: false);
      expect(computeEnding(s), 'le_deuil_et_la_route');
    });

    test('canonical "à parts égales"', () {
      const s = GameState(
        argent: 30000,
        mood: 7,
        reputation: 10,
        isMomTreatmentPaid: true,
      );
      expect(computeEnding(s), 'a_parts_egales');
    });

    test('"cage dorée" : argent + rep haute, mood bas', () {
      const s = GameState(
        argent: 40000,
        mood: 4,
        reputation: 16,
        isMomTreatmentPaid: true,
      );
      expect(computeEnding(s), 'la_cage_doree');
    });

    test('"belleville" : mood haut, peu de réputation', () {
      const s = GameState(
        argent: 4000,
        mood: 9,
        reputation: 3,
        isMomTreatmentPaid: true,
      );
      expect(computeEnding(s), 'belleville');
    });

    test('default fallback -> entre-deux', () {
      const s = GameState(
        argent: 10000,
        mood: 6,
        reputation: 4,
        isMomTreatmentPaid: true,
      );
      expect(computeEnding(s), 'lentre_deux');
    });
  });
}
