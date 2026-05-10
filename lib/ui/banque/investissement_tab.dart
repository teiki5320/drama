import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../engine/economy_engine.dart';
import '../../models/game_state.dart';
import '../../models/investment.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';
import 'market_news.dart';
import 'stock_chart.dart';
import 'stock_detail_screen.dart';

enum _SortMode { all, gainers, losers, volatile }

class InvestissementTab extends ConsumerStatefulWidget {
  const InvestissementTab({super.key});

  @override
  ConsumerState<InvestissementTab> createState() =>
      _InvestissementTabState();
}

class _InvestissementTabState extends ConsumerState<InvestissementTab> {
  _SortMode _sort = _SortMode.all;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final async = ref.watch(investmentsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erreur : $e')),
      data: (all) {
        final unlocked = all.where((i) {
          final u = i.unlockedAtDay;
          return u == null || state.currentDay >= u;
        }).toList(growable: false);
        final locked = all.where((i) {
          final u = i.unlockedAtDay;
          return u != null && state.currentDay < u;
        }).toList(growable: false);

        var portfolioValue = 0.0;
        var dayDelta = 0.0;
        var marketDeltaPctSum = 0.0;
        var marketDeltaPctCount = 0;
        state.stockHoldings.forEach((ticker, qty) {
          final inv = all.where((i) => i.ticker == ticker).firstOrNull;
          if (inv == null) return;
          final hist = state.stockPriceHistory[ticker] ?? const <double>[];
          final price = engine.currentPrice(state, inv);
          portfolioValue += price * qty;
          if (hist.length >= 2) {
            dayDelta += (hist.last - hist[hist.length - 2]) * qty;
          }
        });
        // Calcul de la perf moyenne du marché parisien (jour)
        for (final inv in all) {
          final hist = state.stockPriceHistory[inv.ticker] ?? const <double>[];
          if (hist.length >= 2) {
            final p = hist[hist.length - 2];
            if (p > 0) {
              marketDeltaPctSum += (hist.last - p) / p * 100;
              marketDeltaPctCount++;
            }
          }
        }
        final marketDeltaPct = marketDeltaPctCount == 0
            ? 0.0
            : marketDeltaPctSum / marketDeltaPctCount;

        final positions = state.stockHoldings.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        // Filtrer + trier le marché selon _sort
        final marketEntries = unlocked
            .where((i) => !state.stockHoldings.containsKey(i.ticker))
            .toList();
        marketEntries.sort((a, b) {
          final pa = _dayPctFor(state, a);
          final pb = _dayPctFor(state, b);
          switch (_sort) {
            case _SortMode.all:
              return a.ticker.compareTo(b.ticker);
            case _SortMode.gainers:
              return pb.compareTo(pa);
            case _SortMode.losers:
              return pa.compareTo(pb);
            case _SortMode.volatile:
              final ra = computeRisk(
                  state.stockPriceHistory[a.ticker] ?? const <double>[]);
              final rb = computeRisk(
                  state.stockPriceHistory[b.ticker] ?? const <double>[]);
              return rb.index.compareTo(ra.index);
          }
        });

        final activeNews = activeNewsForDay(state.currentDay);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            _MarketHeader(
              day: state.currentDay,
              portfolioValue: portfolioValue.round(),
              dayDelta: dayDelta.round(),
              marketDeltaPct: marketDeltaPct,
            ),
            const SizedBox(height: 14),
            if (activeNews != null) ...[
              MarketNewsBanner(news: activeNews),
              const SizedBox(height: 14),
            ],
            if (positions.isNotEmpty) ...[
              const _SectionLabel('TES POSITIONS'),
              const SizedBox(height: 6),
              _RowsCard(
                children: [
                  for (final entry in positions)
                    _PositionRow(
                      ticker: entry.key,
                      qty: entry.value,
                      avgCost: state.stockAvgCost[entry.key] ?? 0.0,
                      inv: all.where((i) => i.ticker == entry.key).firstOrNull,
                      state: state,
                      engine: engine,
                    ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            Row(
              children: [
                const _SectionLabel('MARCHÉ'),
                const Spacer(),
                _SortPill(label: 'Tous', selected: _sort == _SortMode.all, onTap: () => setState(() => _sort = _SortMode.all)),
                const SizedBox(width: 4),
                _SortPill(label: '↑', selected: _sort == _SortMode.gainers, onTap: () => setState(() => _sort = _SortMode.gainers)),
                const SizedBox(width: 4),
                _SortPill(label: '↓', selected: _sort == _SortMode.losers, onTap: () => setState(() => _sort = _SortMode.losers)),
                const SizedBox(width: 4),
                _SortPill(label: '⚡', selected: _sort == _SortMode.volatile, onTap: () => setState(() => _sort = _SortMode.volatile)),
              ],
            ),
            const SizedBox(height: 6),
            _RowsCard(
              children: [
                for (final inv in marketEntries)
                  _InvestmentRow(
                    inv: inv,
                    state: state,
                    engine: engine,
                  ),
              ],
            ),
            if (locked.isNotEmpty) ...[
              const SizedBox(height: 14),
              const _SectionLabel('À VENIR'),
              const SizedBox(height: 6),
              _RowsCard(
                children: [
                  for (final inv in locked)
                    _LockedRow(inv: inv),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// MARKET HEADER
// ─────────────────────────────────────────────────────────────────────

class _MarketHeader extends StatelessWidget {
  const _MarketHeader({
    required this.day,
    required this.portfolioValue,
    required this.dayDelta,
    required this.marketDeltaPct,
  });

  final int day;
  final int portfolioValue;
  final int dayDelta;
  final double marketDeltaPct;

  @override
  Widget build(BuildContext context) {
    final positive = dayDelta >= 0;
    final deltaColor = dayDelta == 0
        ? AppColors.textSecondary
        : (positive ? AppColors.positive : AppColors.negative);
    final deltaPct = portfolioValue > 0 && (portfolioValue - dayDelta) > 0
        ? (dayDelta / (portfolioValue - dayDelta)) * 100
        : 0.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFAE0CC), Color(0xFFFCEBC9)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PORTEFEUILLE',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'BOURSE DE PARIS',
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formatMoney(portfolioValue),
            style: GoogleFonts.crimsonPro(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: deltaColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  dayDelta == 0
                      ? Icons.remove
                      : (positive
                          ? Icons.arrow_upward
                          : Icons.arrow_downward),
                  size: 12,
                  color: deltaColor,
                ),
                const SizedBox(width: 3),
                Text(
                  dayDelta == 0
                      ? 'stable · 24h'
                      : '${formatMoneySigned(dayDelta)} (${positive ? '+' : ''}${deltaPct.toStringAsFixed(2)} %) · 24h',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: deltaColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Marché parisien ${marketDeltaPct >= 0 ? '+' : ''}${marketDeltaPct.toStringAsFixed(2)} %',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RowsCard extends StatelessWidget {
  const _RowsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final withDividers = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      withDividers.add(children[i]);
      if (i < children.length - 1) {
        withDividers.add(
          const Divider(height: 1, indent: 14, color: Color(0x0F1A1A1A)),
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: withDividers),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// POSITION ROW (dense)
// ─────────────────────────────────────────────────────────────────────

class _PositionRow extends ConsumerWidget {
  const _PositionRow({
    required this.ticker,
    required this.qty,
    required this.avgCost,
    required this.inv,
    required this.state,
    required this.engine,
  });

  final String ticker;
  final int qty;
  final double avgCost;
  final Investment? inv;
  final GameState state;
  final EconomyEngine engine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (inv == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Text(
          '$ticker · $qty actions',
          style: GoogleFonts.inter(fontSize: 13),
        ),
      );
    }
    final price = engine.currentPrice(state, inv!);
    final value = (price * qty).round();
    final cost = (avgCost * qty).round();
    final pnl = value - cost;
    final pnlColor = pnl > 0
        ? AppColors.positive
        : (pnl < 0 ? AppColors.negative : AppColors.textSecondary);
    final history = state.stockPriceHistory[inv!.ticker] ?? const <double>[];
    final dayDelta = history.length >= 2
        ? history.last - history[history.length - 2]
        : 0.0;
    final dayPct = history.length >= 2 && history[history.length - 2] > 0
        ? (dayDelta / history[history.length - 2]) * 100
        : 0.0;
    final dayColor = dayDelta > 0
        ? AppColors.positive
        : (dayDelta < 0 ? AppColors.negative : AppColors.textSecondary);

    return InkWell(
      onTap: () => _openStockDetail(context, ref, inv!),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            // Left: ticker + name
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RiskDot(history: history),
                      const SizedBox(width: 4),
                      Text(
                        ticker,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$qty × ${avgCost.toStringAsFixed(0)} €',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Sparkline
            Expanded(
              child: Center(
                child: Sparkline(values: history, width: 80),
              ),
            ),
            // Right: price + day var, pnl badge under
            SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatMoney(value),
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        dayDelta == 0
                            ? Icons.remove
                            : (dayDelta > 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                        size: 10,
                        color: dayColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${dayPct >= 0 ? '+' : ''}${dayPct.toStringAsFixed(1)} %',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: dayColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pnl >= 0 ? '+${formatMoney(pnl)}' : formatMoney(pnl),
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: pnlColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// INVESTMENT ROW (watchlist)
// ─────────────────────────────────────────────────────────────────────

class _InvestmentRow extends ConsumerWidget {
  const _InvestmentRow({
    required this.inv,
    required this.state,
    required this.engine,
  });

  final Investment inv;
  final GameState state;
  final EconomyEngine engine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = engine.currentPrice(state, inv);
    final history = state.stockPriceHistory[inv.ticker] ?? const <double>[];
    final dayDelta = history.length >= 2
        ? history.last - history[history.length - 2]
        : 0.0;
    final dayPct = history.length >= 2 && history[history.length - 2] > 0
        ? (dayDelta / history[history.length - 2]) * 100
        : 0.0;
    final dayColor = dayDelta > 0
        ? AppColors.positive
        : (dayDelta < 0 ? AppColors.negative : AppColors.textSecondary);
    final canBuy = engine.canBuyStock(state, inv, 1);

    return InkWell(
      onTap: canBuy.ok
          ? () => _openStockDetail(context, ref, inv)
          : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            // Left: ticker + sector
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RiskDot(history: history),
                      const SizedBox(width: 4),
                      Text(
                        inv.ticker,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    inv.sector,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Sparkline
            Expanded(
              child: Center(
                child: Sparkline(values: history, width: 80),
              ),
            ),
            // Right: price + day var
            SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${current.toStringAsFixed(0)} €',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        dayDelta == 0
                            ? Icons.remove
                            : (dayDelta > 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                        size: 10,
                        color: dayColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${dayPct >= 0 ? '+' : ''}${dayPct.toStringAsFixed(1)} %',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: dayColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedRow extends StatelessWidget {
  const _LockedRow({required this.inv});
  final Investment inv;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inv.ticker,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  inv.sector,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Icon(Icons.lock_outline, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            'J${inv.unlockedAtDay}',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// TRADE SHEET (bottom sheet)
// ─────────────────────────────────────────────────────────────────────

void _showTradeSheet(
  BuildContext context, {
  required WidgetRef ref,
  required Investment inv,
  required bool isBuy,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.paperCream,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _TradeSheet(inv: inv, initialIsBuy: isBuy),
  );
}

class _TradeSheet extends ConsumerStatefulWidget {
  const _TradeSheet({required this.inv, required this.initialIsBuy});

  final Investment inv;
  final bool initialIsBuy;

  @override
  ConsumerState<_TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends ConsumerState<_TradeSheet> {
  int _qty = 1;
  late bool _isBuy = widget.initialIsBuy;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final price = engine.currentPrice(state, widget.inv);
    final total = (price * _qty).round();
    final hasPosition =
        (state.stockHoldings[widget.inv.ticker] ?? 0) > 0;
    final maxQty = _isBuy
        ? (state.argent ~/ price).clamp(0, 9999)
        : (state.stockHoldings[widget.inv.ticker] ?? 0);
    final canTrade = _isBuy
        ? engine.canBuyStock(state, widget.inv, _qty)
        : engine.canSellStock(state, widget.inv.ticker, _qty);
    final history =
        state.stockPriceHistory[widget.inv.ticker] ?? const <double>[];
    final avgCost = state.stockAvgCost[widget.inv.ticker];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.inv.ticker,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.inv.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                '${price.toStringAsFixed(0)} €',
                style: GoogleFonts.crimsonPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.inv.description,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          StockChart(values: history, avgCost: avgCost),
          const SizedBox(height: 12),
          // Buy/Sell switch (sell only available if position)
          if (hasPosition)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9D8),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Expanded(
                    child: _SegmentBtn(
                      label: 'Acheter',
                      selected: _isBuy,
                      onTap: () => setState(() {
                        _isBuy = true;
                        _qty = 1;
                      }),
                    ),
                  ),
                  Expanded(
                    child: _SegmentBtn(
                      label: 'Vendre',
                      selected: !_isBuy,
                      onTap: () => setState(() {
                        _isBuy = false;
                        _qty = 1;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          if (hasPosition) const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepperButton(
                icon: Icons.remove,
                onTap: _qty > 1 ? () => setState(() => _qty--) : null,
              ),
              Column(
                children: [
                  Text(
                    '$_qty',
                    style: GoogleFonts.crimsonPro(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'actions · max $maxQty',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              _StepperButton(
                icon: Icons.add,
                onTap: _qty < maxQty ? () => setState(() => _qty++) : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textSecondary)),
              Text(
                formatMoney(total),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBuy
                    ? AppColors.accentOrange
                    : AppColors.negative,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: !canTrade.ok
                  ? null
                  : () async {
                      HapticFeedback.lightImpact();
                      final ctrl = ref.read(gameStateProvider.notifier);
                      if (_isBuy) {
                        await ctrl.buyStock(widget.inv, _qty);
                      } else {
                        await ctrl.sellStock(widget.inv, _qty);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    },
              child: Text(
                canTrade.ok
                    ? (_isBuy
                        ? 'Confirmer l\'achat'
                        : 'Confirmer la vente')
                    : (canTrade.reason ?? '—'),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentBtn extends StatelessWidget {
  const _SegmentBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFEAE6DD) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x141A1A1A)),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: disabled ? AppColors.textSecondary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

extension _Iter<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

double _dayPctFor(GameState state, Investment inv) {
  final hist = state.stockPriceHistory[inv.ticker] ?? const <double>[];
  if (hist.length < 2) return 0.0;
  final prev = hist[hist.length - 2];
  if (prev <= 0) return 0.0;
  return (hist.last - prev) / prev * 100;
}

void _openStockDetail(BuildContext context, WidgetRef ref, Investment inv) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => StockDetailScreen(
      inv: inv,
      onTrade: (ctx, isBuy) {
        Navigator.of(ctx).pop();
        _showTradeSheet(context, ref: ref, inv: inv, isBuy: isBuy);
      },
    ),
  ));
}

class _RiskDot extends StatelessWidget {
  const _RiskDot({required this.history});
  final List<double> history;

  @override
  Widget build(BuildContext context) {
    final meta = riskMeta(computeRisk(history));
    return Tooltip(
      message: meta.label,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: meta.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _SortPill extends StatelessWidget {
  const _SortPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minWidth: 30),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : const Color(0xFFEFE9D8),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
