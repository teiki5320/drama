import 'package:contre_jour/engine/economy_engine.dart';
import 'package:contre_jour/models/choice.dart';
import 'package:contre_jour/models/game_state.dart';
import 'package:contre_jour/models/investment.dart';
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

    test('setsFlags can flip isMomTreatmentPaid (J8 option A)', () {
      const initial = GameState(argent: 30000, mood: 5);
      const opt = ChoiceOption(
        text: 'Premier versement direct à l\'hôpital.',
        argent: -18000,
        mood: 3,
        reputation: 1,
        setsFlags: ['isMomTreatmentPaid'],
      );
      final next = engine.applyChoice(
          state: initial, dayId: 8, optionIndex: 0, option: opt);
      expect(next.argent, 12000);
      expect(next.mood, 8);
      expect(next.isMomTreatmentPaid, isTrue);
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

    test('shop buy appends a ledger entry', () {
      const s = GameState(argent: 500, currentDay: 6);
      final after = engine.buy(s, item);
      expect(after.ledger, hasLength(1));
      expect(after.ledger.first.amount, -200);
      expect(after.ledger.first.day, 6);
      expect(after.ledger.first.label, contains('Foo'));
    });

    test('generates an Insta post when generatesInstaPost is true', () {
      const item = ShopItem(
        id: 'tesla',
        category: 'vehicule',
        emoji: '⚡',
        name: 'Tesla',
        description: '...',
        price: 100,
        moodGain: 0,
        reputationGain: 0,
        requiredReputation: 0,
        requiredMood: 0,
        generatesInstaPost: true,
        instaPostCaption: 'Silent ride ⚡',
        instaPostEmoji: '⚡',
      );
      const s = GameState(argent: 1000, currentDay: 12);
      final after = engine.buy(s, item);
      expect(after.generatedInstaPosts, hasLength(1));
      expect(after.generatedInstaPosts.first.author, '@shen_y');
      expect(after.generatedInstaPosts.first.day, 12);
      expect(after.generatedInstaPosts.first.caption, 'Silent ride ⚡');
    });
  });

  group('investments', () {
    const lug = Investment(
      ticker: 'LUG',
      name: 'Lu Group',
      sector: 'Immo',
      price: 100,
      description: '...',
    );

    test('buyStock: deducts cash, sets qty + avg cost', () {
      const s = GameState(argent: 1000);
      final after = engine.buyStock(s, lug, 5);
      expect(after.argent, 500);
      expect(after.stockHoldings['LUG'], 5);
      expect(after.stockAvgCost['LUG'], 100);
    });

    test('buyStock: weighted avg cost when adding to position', () {
      // First buy 5 @ 100
      var s = engine.buyStock(const GameState(argent: 1000), lug, 5);
      // Override price to 200, then buy 5 more
      s = s.copyWith(stockCurrentPrices: {'LUG': 200});
      s = engine.buyStock(s.copyWith(argent: 2000), lug, 5);
      expect(s.stockHoldings['LUG'], 10);
      expect(s.stockAvgCost['LUG'], 150); // (100*5 + 200*5) / 10
    });

    test('sellStock: full sell removes position', () {
      var s = engine.buyStock(const GameState(argent: 1000), lug, 5);
      s = engine.sellStock(s, lug, 5);
      expect(s.stockHoldings.containsKey('LUG'), isFalse);
      expect(s.stockAvgCost.containsKey('LUG'), isFalse);
    });

    test('sellStock: partial sell keeps avg cost', () {
      var s = engine.buyStock(const GameState(argent: 1000), lug, 5);
      s = engine.sellStock(s, lug, 2);
      expect(s.stockHoldings['LUG'], 3);
      expect(s.stockAvgCost['LUG'], 100);
    });

    test('canBuyStock: locked before unlockedAtDay', () {
      const heng = Investment(
        ticker: 'HENG',
        name: 'Heng',
        sector: 'Hotel',
        price: 200,
        description: '',
        unlockedAtDay: 10,
      );
      const s = GameState(currentDay: 5, argent: 10000);
      final c = engine.canBuyStock(s, heng, 1);
      expect(c.ok, isFalse);
    });

    test('scriptedDelta returns ROADMAP §4.8 triggers', () {
      expect(EconomyEngine.scriptedDelta(35, 'HENG'), 0.12);
      expect(EconomyEngine.scriptedDelta(52, 'HENG'), -0.18);
      expect(EconomyEngine.scriptedDelta(76, 'HAN'), 0.35);
      expect(EconomyEngine.scriptedDelta(98, 'BDE'), -0.22);
      expect(EconomyEngine.scriptedDelta(50, 'LSTR'), isNull);
    });

    test('advanceDay tracks price history capped at kMaxPriceHistory', () {
      const lug = Investment(
        ticker: 'LUG', name: 'Lu', sector: 's', price: 100, description: '',
      );
      var s = const GameState(currentDay: 1, argent: 1000);
      for (var i = 0; i < EconomyEngine.kMaxPriceHistory + 5; i++) {
        s = engine.advanceDay(s, investments: [lug]);
      }
      expect(s.stockPriceHistory['LUG']!.length,
          EconomyEngine.kMaxPriceHistory);
      expect(s.stockPriceHistory['LUG']!.last,
          s.stockCurrentPrices['LUG']);
    });

    test('tickPrices applies trigger on the right day', () {
      const heng = Investment(
        ticker: 'HENG',
        name: 'Heng',
        sector: 'Hotel',
        price: 200,
        description: '',
      );
      final ticked = engine.tickPrices(
        previousPrices: const {'HENG': 200},
        investments: [heng],
        day: 35,
      );
      // 200 * (1 + ±2%) * 1.12 → between ~219 and ~228
      expect(ticked['HENG']!, greaterThan(218));
      expect(ticked['HENG']!, lessThan(229));
    });

    test('tickPrices is deterministic per (day, ticker)', () {
      const heng = Investment(
        ticker: 'HENG',
        name: 'Heng',
        sector: 'Hotel',
        price: 200,
        description: '',
      );
      final a = engine.tickPrices(
        previousPrices: const {'HENG': 200},
        investments: [heng],
        day: 7,
      );
      final b = engine.tickPrices(
        previousPrices: const {'HENG': 200},
        investments: [heng],
        day: 7,
      );
      expect(a['HENG'], b['HENG']);
    });

    test('advanceDay applies tick when investments are passed', () {
      const lug = Investment(
        ticker: 'LUG',
        name: 'Lu',
        sector: 's',
        price: 100,
        description: '',
      );
      const s = GameState(currentDay: 5, argent: 1000);
      final next = engine.advanceDay(s, investments: [lug]);
      expect(next.stockCurrentPrices.containsKey('LUG'), isTrue);
    });
  });
}
