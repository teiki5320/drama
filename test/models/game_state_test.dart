import 'package:contre_jour/models/game_state.dart';
import 'package:contre_jour/models/insta_post.dart';
import 'package:contre_jour/models/ledger_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameState JSON round-trip', () {
    test('default state round-trips losslessly', () {
      const original = GameState();
      final json = original.encode();
      final decoded = GameState.decode(json);
      expect(decoded.currentDay, original.currentDay);
      expect(decoded.argent, original.argent);
      expect(decoded.mood, original.mood);
      expect(decoded.reputation, original.reputation);
      expect(decoded.followers, original.followers);
      expect(decoded.unlockedConversations, original.unlockedConversations);
    });

    test('full state round-trips losslessly', () {
      final original = GameState(
        currentDay: 14,
        argent: 12345,
        mood: 7,
        reputation: 3,
        followers: 3712,
        stockHoldings: const {'LSTR': 4, 'HENG': 2},
        stockAvgCost: const {'LSTR': 180.5, 'HENG': 225.0},
        stockCurrentPrices: const {'LSTR': 195.0, 'HENG': 218.0},
        stockPriceHistory: const {
          'LSTR': [180, 182, 195],
          'HENG': [225, 220, 218],
        },
        wealthHistory: const [2384, 2389, 2400, 12345],
        ownedItems: const ['tesla', 'sac_chanel'],
        choicesMade: const {1: 0, 2: 1, 7: 0},
        isMomTreatmentPaid: true,
        unlockedConversations: const ['maman', 'camille', 'tristan'],
        seenMessageThreads: const ['maman', 'camille'],
        generatedInstaPosts: const [
          InstaPost(
            id: 'shen_tesla_j8',
            author: '@shen_y',
            day: 8,
            emoji: '⚡',
            caption: 'Silent ride',
            likes: 123,
            commentsCount: 4,
          ),
        ],
        ledger: const [
          LedgerEntry(
            day: 7,
            kind: LedgerEntryKind.choiceIncome,
            label: 'Contrat Heng (3 mois)',
            amount: 30000,
          ),
          LedgerEntry(
            day: 8,
            kind: LedgerEntryKind.momTreatment,
            label: 'Traitement maman (Tenon)',
            amount: -18000,
          ),
        ],
        ending: null,
      );

      final decoded = GameState.decode(original.encode());

      expect(decoded.currentDay, 14);
      expect(decoded.argent, 12345);
      expect(decoded.mood, 7);
      expect(decoded.reputation, 3);
      expect(decoded.followers, 3712);
      expect(decoded.stockHoldings, {'LSTR': 4, 'HENG': 2});
      expect(decoded.stockAvgCost['LSTR'], 180.5);
      expect(decoded.stockPriceHistory['HENG'], [225.0, 220.0, 218.0]);
      expect(decoded.wealthHistory, [2384, 2389, 2400, 12345]);
      expect(decoded.ownedItems, ['tesla', 'sac_chanel']);
      expect(decoded.choicesMade, {1: 0, 2: 1, 7: 0});
      expect(decoded.isMomTreatmentPaid, isTrue);
      expect(decoded.unlockedConversations,
          containsAll(['maman', 'camille', 'tristan']));
      expect(decoded.seenMessageThreads, ['maman', 'camille']);
      expect(decoded.generatedInstaPosts, hasLength(1));
      expect(decoded.generatedInstaPosts.first.caption, 'Silent ride');
      expect(decoded.ledger, hasLength(2));
      expect(decoded.ledger.first.label, 'Contrat Heng (3 mois)');
      expect(decoded.ledger.first.amount, 30000);
      expect(decoded.ending, isNull);
    });

    test('fromJson tolerates missing optional fields (forward compat)', () {
      // Simulated old save without the new wealthHistory / ledger fields.
      const minimal =
          '{"currentDay":5,"argent":1500,"mood":4,"reputation":1}';
      final decoded = GameState.decode(minimal);
      expect(decoded.currentDay, 5);
      expect(decoded.argent, 1500);
      expect(decoded.wealthHistory, isEmpty);
      expect(decoded.ledger, isEmpty);
      expect(decoded.stockPriceHistory, isEmpty);
    });
  });
}
