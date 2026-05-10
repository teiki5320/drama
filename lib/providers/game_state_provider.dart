import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/game_state_repository.dart';
import '../engine/economy_engine.dart';
import '../models/choice.dart';
import '../models/game_state.dart';
import '../models/investment.dart';
import '../models/shop_item.dart';
import 'catalogs_provider.dart';

final gameStateRepositoryProvider =
    Provider<GameStateRepository>((ref) => GameStateRepository());

final economyEngineProvider =
    Provider<EconomyEngine>((ref) => const EconomyEngine());

class GameStateController extends StateNotifier<GameState> {
  GameStateController(this._repo, this._engine, this._ref)
      : super(const GameState()) {
    _restore();
  }

  final GameStateRepository _repo;
  final EconomyEngine _engine;
  final Ref _ref;

  Future<void> _restore() async {
    final loaded = await _repo.load();
    if (loaded != null) state = loaded;
  }

  Future<void> _persist() => _repo.save(state);

  /// Whether the current day's choice has already been made.
  bool hasChosenForDay(int dayId) => state.choicesMade.containsKey(dayId);

  Future<void> chooseOption({
    required int dayId,
    required int optionIndex,
    required ChoiceOption option,
  }) async {
    state = _engine.applyChoice(
      state: state,
      dayId: dayId,
      optionIndex: optionIndex,
      option: option,
    );
    await _persist();
  }

  Future<void> nextDay() async {
    final List<Investment> invs =
        await _ref.read(investmentsProvider.future);
    state = _engine.advanceDay(state, investments: invs);
    await _persist();
  }

  Future<void> buyItem(ShopItem item) async {
    final check = _engine.canBuy(state, item);
    if (!check.ok) return;
    state = _engine.buy(state, item);
    await _persist();
  }

  Future<void> buyStock(Investment inv, int qty) async {
    final check = _engine.canBuyStock(state, inv, qty);
    if (!check.ok) return;
    state = _engine.buyStock(state, inv, qty);
    await _persist();
  }

  Future<void> sellStock(Investment inv, int qty) async {
    final check = _engine.canSellStock(state, inv.ticker, qty);
    if (!check.ok) return;
    state = _engine.sellStock(state, inv, qty);
    await _persist();
  }

  Future<void> markMessagesSeen() async {
    if (state.unlockedConversations.every(
        (c) => state.seenMessageThreads.contains(c))) {
      return;
    }
    state = state.copyWith(
      seenMessageThreads: List<String>.from(state.unlockedConversations),
    );
    await _persist();
  }

  Future<void> reset() async {
    state = const GameState();
    await _repo.reset();
  }
}

final gameStateProvider =
    StateNotifierProvider<GameStateController, GameState>((ref) {
  return GameStateController(
    ref.watch(gameStateRepositoryProvider),
    ref.watch(economyEngineProvider),
    ref,
  );
});
