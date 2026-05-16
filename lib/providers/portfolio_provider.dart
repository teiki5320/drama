import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/banque_data.dart';
import 'phone_state_provider.dart';

/// Une position détenue dans le portefeuille (PEA) de Shen.
@immutable
class PortfolioPosition {
  final String ticker;
  /// Nombre d'actions détenues (entier — pas de fractions).
  final int qty;
  /// Prix de revient unitaire moyen (€).
  final double pru;

  const PortfolioPosition({
    required this.ticker,
    required this.qty,
    required this.pru,
  });

  PortfolioPosition copyWith({int? qty, double? pru}) =>
      PortfolioPosition(
        ticker: ticker,
        qty: qty ?? this.qty,
        pru: pru ?? this.pru,
      );

  /// Valeur d'achat de la position (qty × PRU).
  double get costBasis => qty * pru;

  Map<String, dynamic> toJson() =>
      {'ticker': ticker, 'qty': qty, 'pru': pru};

  static PortfolioPosition fromJson(Map<String, dynamic> j) =>
      PortfolioPosition(
        ticker: j['ticker'] as String,
        qty: j['qty'] as int,
        pru: (j['pru'] as num).toDouble(),
      );
}

/// État du portefeuille : positions + historique des opérations.
@immutable
class PortfolioState {
  final List<PortfolioPosition> positions;
  /// Historique simple : ticker, qty, price, action ('buy'/'sell'), day, time.
  final List<PortfolioTrade> trades;

  const PortfolioState({
    this.positions = const [],
    this.trades = const [],
  });

  PortfolioState copyWith({
    List<PortfolioPosition>? positions,
    List<PortfolioTrade>? trades,
  }) =>
      PortfolioState(
        positions: positions ?? this.positions,
        trades: trades ?? this.trades,
      );

  PortfolioPosition? positionOf(String ticker) {
    for (final p in positions) {
      if (p.ticker == ticker) return p;
    }
    return null;
  }

  /// Valeur totale au PRU.
  double get totalCostBasis =>
      positions.fold(0.0, (a, p) => a + p.costBasis);

  Map<String, dynamic> toJson() => {
        'positions': positions.map((p) => p.toJson()).toList(),
        'trades': trades.map((t) => t.toJson()).toList(),
      };

  static PortfolioState fromJson(Map<String, dynamic> j) => PortfolioState(
        positions: ((j['positions'] as List?) ?? [])
            .map((e) => PortfolioPosition.fromJson(e as Map<String, dynamic>))
            .toList(),
        trades: ((j['trades'] as List?) ?? [])
            .map((e) => PortfolioTrade.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

@immutable
class PortfolioTrade {
  final String ticker;
  final int qty;
  final double price;
  /// 'buy' ou 'sell'.
  final String action;
  final int day;
  final String time;

  const PortfolioTrade({
    required this.ticker,
    required this.qty,
    required this.price,
    required this.action,
    required this.day,
    required this.time,
  });

  double get totalValue => qty * price;

  Map<String, dynamic> toJson() => {
        'ticker': ticker,
        'qty': qty,
        'price': price,
        'action': action,
        'day': day,
        'time': time,
      };

  static PortfolioTrade fromJson(Map<String, dynamic> j) => PortfolioTrade(
        ticker: j['ticker'] as String,
        qty: j['qty'] as int,
        price: (j['price'] as num).toDouble(),
        action: j['action'] as String,
        day: j['day'] as int,
        time: j['time'] as String,
      );
}

const _kPrefsKey = 'portfolio_v1';

class PortfolioNotifier extends StateNotifier<PortfolioState> {
  PortfolioNotifier(this._ref) : super(const PortfolioState()) {
    _hydrate();
  }

  final Ref _ref;

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPrefsKey);
    if (raw == null) return;
    try {
      state = PortfolioState.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, jsonEncode(state.toJson()));
  }

  /// Tente un achat. Retourne null si succès, sinon un message d'erreur.
  String? buy({required String ticker, required int qty, required double price}) {
    if (qty <= 0) return 'Quantité invalide';
    final cost = qty * price;
    // Vérif solde — calcul depuis les mouvements Banque + dynamiques
    final balance = _currentBalance();
    if (cost > balance) {
      return 'Solde insuffisant (${balance.toStringAsFixed(0)} €)';
    }
    // Calcule le nouveau PRU
    final existing = state.positionOf(ticker);
    final newQty = (existing?.qty ?? 0) + qty;
    final totalCost = (existing?.costBasis ?? 0) + cost;
    final newPru = totalCost / newQty;

    final newPositions = List<PortfolioPosition>.from(state.positions);
    final idx = newPositions.indexWhere((p) => p.ticker == ticker);
    if (idx >= 0) {
      newPositions[idx] = PortfolioPosition(
          ticker: ticker, qty: newQty, pru: newPru);
    } else {
      newPositions.add(PortfolioPosition(
          ticker: ticker, qty: newQty, pru: newPru));
    }
    // Trade
    final p = _ref.read(phoneStateProvider);
    final trade = PortfolioTrade(
      ticker: ticker,
      qty: qty,
      price: price,
      action: 'buy',
      day: p.currentDay,
      time: p.timeLabel,
    );
    state = state.copyWith(
      positions: newPositions,
      trades: [...state.trades, trade],
    );
    // Débit Banque
    _ref.read(phoneStateProvider.notifier).addBankMovement(
          label: 'Bourse · achat $qty $ticker',
          amount: -cost.round(),
          emoji: '📈',
        );
    _persist();
    return null;
  }

  /// Tente une vente. Retourne null si succès, sinon un message d'erreur.
  String? sell({required String ticker, required int qty, required double price}) {
    if (qty <= 0) return 'Quantité invalide';
    final existing = state.positionOf(ticker);
    if (existing == null || existing.qty < qty) {
      return 'Position insuffisante';
    }
    final newQty = existing.qty - qty;
    final newPositions = List<PortfolioPosition>.from(state.positions);
    final idx = newPositions.indexWhere((p) => p.ticker == ticker);
    if (newQty == 0) {
      newPositions.removeAt(idx);
    } else {
      newPositions[idx] = existing.copyWith(qty: newQty);
    }
    final p = _ref.read(phoneStateProvider);
    final proceeds = qty * price;
    final trade = PortfolioTrade(
      ticker: ticker,
      qty: qty,
      price: price,
      action: 'sell',
      day: p.currentDay,
      time: p.timeLabel,
    );
    state = state.copyWith(
      positions: newPositions,
      trades: [...state.trades, trade],
    );
    _ref.read(phoneStateProvider.notifier).addBankMovement(
          label: 'Bourse · vente $qty $ticker',
          amount: proceeds.round(),
          emoji: '📉',
        );
    _persist();
    return null;
  }

  /// Solde courant (cash). Recalcul depuis le starting balance +
  /// canonical movements + dynamic movements.
  double _currentBalance() {
    final p = _ref.read(phoneStateProvider);
    final day = p.currentDay;
    var balance = kStartingBalance.toDouble();
    for (final m in kMovements) {
      if (m.day <= day) balance += m.amount;
    }
    for (final m in p.dynamicMovements) {
      if (m.day <= day) balance += m.amount;
    }
    return balance;
  }

  /// Reset (debug).
  void reset() {
    state = const PortfolioState();
    _persist();
  }
}

final portfolioProvider =
    StateNotifierProvider<PortfolioNotifier, PortfolioState>(
        (ref) => PortfolioNotifier(ref));

/// Provider dérivé : plus-value latente totale (€).
final unrealizedPLProvider = Provider<double>((ref) {
  final state = ref.watch(portfolioProvider);
  final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
  var pl = 0.0;
  for (final pos in state.positions) {
    final stock = kStocks.where((s) => s.ticker == pos.ticker).firstOrNull;
    if (stock == null) continue;
    final current = priceAt(stock, day);
    pl += (current - pos.pru) * pos.qty;
  }
  return pl;
});

/// Provider dérivé : valeur actuelle de marché du portefeuille (€).
final portfolioMarketValueProvider = Provider<double>((ref) {
  final state = ref.watch(portfolioProvider);
  final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
  var v = 0.0;
  for (final pos in state.positions) {
    final stock = kStocks.where((s) => s.ticker == pos.ticker).firstOrNull;
    if (stock == null) continue;
    v += priceAt(stock, day) * pos.qty;
  }
  return v;
});
