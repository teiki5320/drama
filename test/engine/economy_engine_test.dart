import 'package:contre_jour/engine/economy_engine.dart';
import 'package:contre_jour/models/choice.dart';
import 'package:contre_jour/models/game_state.dart';
import 'package:contre_jour/models/shop_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = EconomyEngine();

  group('passiveIncome', () {
    test('brackets', () {
      expect(engine.passiveIncome(500), 0);
      expect(engine.passiveIncome(1000), 5);
      expect(engine.passiveIncome(9999), 5);
      expect(engine.passiveIncome(10000), 25);
      expect(engine.passiveIncome(25000), 80);
      expect(engine.passiveIncome(50000), 200);
    });
  });

  group('applyChoice', () {
    test('applies deltas, clamps mood, records the choice', () {
      const initial = GameState(argent: 100, mood: 9, reputation: 0);
      const opt = ChoiceOption(
        text: 'A',
        argent: -50,
        mood: 4, // would push to 13, clamps to 10
        reputation: 2,
      );

      final next = engine.applyChoice(
        state: initial,
        dayId: 1,
        optionIndex: 0,
        option: opt,
      );

      expect(next.argent, 50);
      expect(next.mood, 10);
      expect(next.reputation, 2);
      expect(next.choicesMade[1], 0);
      expect(next.lowMoodStreak, 0);
    });

    test('low-mood streak increments when mood <= 2', () {
      const initial = GameState(mood: 4, lowMoodStreak: 0);
      const opt = ChoiceOption(
        text: 'A', argent: 0, mood: -3, reputation: 0); // 4 - 3 = 1
      final next = engine.applyChoice(
        state: initial, dayId: 1, optionIndex: 0, option: opt);
      expect(next.mood, 1);
      expect(next.lowMoodStreak, 1);
    });

    test('unlocks merge into unlockedConversations', () {
      const initial = GameState();
      const opt = ChoiceOption(
        text: 'A',
        argent: 0,
        mood: 0,
        reputation: 0,
        unlocks: ['tristan'],
      );
      final next = engine.applyChoice(
          state: initial, dayId: 1, optionIndex: 0, option: opt);
      expect(next.unlockedConversations, contains('tristan'));
      expect(next.unlockedConversations, contains('maman'));
      expect(next.unlockedConversations, contains('camille'));
    });
  });

  group('advanceDay', () {
    test('pays mom treatment when threshold reached before deadline', () {
      const s = GameState(
        currentDay: 10,
        argent: 19000,
        mood: 5,
        isMomTreatmentPaid: false,
      );
      final next = engine.advanceDay(s);
      expect(next.currentDay, 11);
      expect(next.isMomTreatmentPaid, isTrue);
      expect(
        next.argent,
        19000 + engine.passiveIncome(s.followers) - EconomyEngine.kMomTreatmentCost,
      );
      expect(next.mood, 7); // +2 boost
    });

    test('does not pay if argent below threshold', () {
      const s = GameState(currentDay: 10, argent: 5000);
      final next = engine.advanceDay(s);
      expect(next.isMomTreatmentPaid, isFalse);
    });
  });

  group('canBuy / buy', () {
    const item = ShopItem(
      id: 'foo',
      category: 'mode',
      emoji: '👗',
      name: 'Foo',
      description: '...',
      price: 200,
      moodGain: 1,
      reputationGain: 1,
      requiredReputation: 0,
      requiredMood: 0,
      generatesInstaPost: false,
    );

    test('rejects when argent < price', () {
      const s = GameState(argent: 100);
      final c = engine.canBuy(s, item);
      expect(c.ok, isFalse);
    });

    test('buys: deducts argent, applies gains, records ownership', () {
      const s = GameState(argent: 500, mood: 5, reputation: 0);
      final after = engine.buy(s, item);
      expect(after.argent, 300);
      expect(after.mood, 6);
      expect(after.reputation, 1);
      expect(after.ownedItems, contains('foo'));
    });
  });
}
