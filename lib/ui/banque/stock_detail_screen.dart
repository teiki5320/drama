import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../engine/economy_engine.dart';
import '../../models/investment.dart';
import '../../providers/game_state_provider.dart';
import 'market_news.dart';
import 'stock_chart.dart';

/// Vue plein écran d'une action : chart 60j + perf 7j/30j/tout +
/// description longue + rumeurs en cours + boutons Acheter / Vendre.
class StockDetailScreen extends ConsumerStatefulWidget {
  const StockDetailScreen({
    super.key,
    required this.inv,
    required this.onTrade,
  });

  final Investment inv;
  final void Function(BuildContext context, bool isBuy) onTrade;

  @override
  ConsumerState<StockDetailScreen> createState() =>
      _StockDetailScreenState();
}

class _StockDetailScreenState extends ConsumerState<StockDetailScreen> {
  int _windowDays = 30;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final price = engine.currentPrice(state, widget.inv);
    final history =
        state.stockPriceHistory[widget.inv.ticker] ?? const <double>[];
    final qty = state.stockHoldings[widget.inv.ticker] ?? 0;
    final avgCost = state.stockAvgCost[widget.inv.ticker];

    final windowed = _windowDays < 0 || history.length <= _windowDays
        ? history
        : history.sublist(history.length - _windowDays);

    // Performance sur la fenêtre
    final firstPrice = windowed.isNotEmpty ? windowed.first : price;
    final perfPct = firstPrice > 0
        ? ((price - firstPrice) / firstPrice) * 100
        : 0.0;
    final perfColor = perfPct > 0.05
        ? AppColors.positive
        : (perfPct < -0.05 ? AppColors.negative : AppColors.textSecondary);

    // Risque (volatilité = std-dev relative)
    final risk = computeRisk(history);

    // News scénarisée ciblant ce ticker
    final allNews = kMarketNews
        .where((n) =>
            n.ticker == widget.inv.ticker &&
            state.currentDay >= n.day &&
            state.currentDay < n.day + 2)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      appBar: AppBar(
        title: Text(
          widget.inv.ticker,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        children: [
          _Header(
            inv: widget.inv,
            price: price,
            qty: qty,
            risk: risk,
          ),
          const SizedBox(height: 16),
          _ChartCard(
            history: windowed,
            avgCost: avgCost,
            windowDays: _windowDays,
            onWindowChanged: (d) => setState(() => _windowDays = d),
            perfPct: perfPct,
            perfColor: perfColor,
          ),
          const SizedBox(height: 14),
          if (allNews.isNotEmpty) ...[
            for (final n in allNews) ...[
              MarketNewsBanner(news: n),
              const SizedBox(height: 12),
            ],
          ],
          _DescriptionCard(inv: widget.inv),
          const SizedBox(height: 14),
          if (qty > 0) _PositionCard(
            qty: qty,
            avgCost: avgCost ?? 0.0,
            price: price,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              if (qty > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onTrade(context, false);
                    },
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColors.negative),
                      foregroundColor: AppColors.negative,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Vendre',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onTrade(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentOrange,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Acheter',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// RISK
// ─────────────────────────────────────────────────────────────────────

enum RiskLevel { low, medium, high }

RiskLevel computeRisk(List<double> history) {
  if (history.length < 5) return RiskLevel.low;
  final tail = history.length > 14
      ? history.sublist(history.length - 14)
      : history;
  final mean = tail.reduce((a, b) => a + b) / tail.length;
  if (mean == 0) return RiskLevel.low;
  final variance = tail
          .map((v) => (v - mean) * (v - mean))
          .reduce((a, b) => a + b) /
      tail.length;
  final std = math.sqrt(variance);
  final coef = std / mean; // coefficient de variation
  if (coef >= 0.04) return RiskLevel.high;
  if (coef >= 0.02) return RiskLevel.medium;
  return RiskLevel.low;
}

({Color color, String label, String emoji}) riskMeta(RiskLevel r) {
  switch (r) {
    case RiskLevel.low:
      return (color: AppColors.positive, label: 'Calme', emoji: '🟢');
    case RiskLevel.medium:
      return (color: const Color(0xFFD4A437), label: 'Mouvant', emoji: '🟡');
    case RiskLevel.high:
      return (color: AppColors.negative, label: 'Volatile', emoji: '🔴');
  }
}

// ─────────────────────────────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.inv,
    required this.price,
    required this.qty,
    required this.risk,
  });

  final Investment inv;
  final double price;
  final int qty;
  final RiskLevel risk;

  @override
  Widget build(BuildContext context) {
    final meta = riskMeta(risk);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFAE0CC), Color(0xFFFCEBC9)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                inv.name,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(meta.emoji, style: const TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    Text(
                      meta.label,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: meta.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            inv.sector,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${price.toStringAsFixed(0)} €',
            style: GoogleFonts.crimsonPro(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
          if (qty > 0) ...[
            const SizedBox(height: 6),
            Text(
              'Tu possèdes $qty action${qty == 1 ? '' : 's'}.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.history,
    required this.avgCost,
    required this.windowDays,
    required this.onWindowChanged,
    required this.perfPct,
    required this.perfColor,
  });

  final List<double> history;
  final double? avgCost;
  final int windowDays;
  final ValueChanged<int> onWindowChanged;
  final double perfPct;
  final Color perfColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PERFORMANCE ${perfPct >= 0 ? '+' : ''}${perfPct.toStringAsFixed(1)} %',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: perfColor,
                ),
              ),
              const Spacer(),
              _TimePill(label: '7j', selected: windowDays == 7, onTap: () => onWindowChanged(7)),
              const SizedBox(width: 4),
              _TimePill(label: '30j', selected: windowDays == 30, onTap: () => onWindowChanged(30)),
              const SizedBox(width: 4),
              _TimePill(label: 'Tout', selected: windowDays < 0, onTap: () => onWindowChanged(-1)),
            ],
          ),
          const SizedBox(height: 10),
          StockChart(values: history, avgCost: avgCost, height: 160),
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : const Color(0xFFEFE9D8),
          borderRadius: BorderRadius.circular(8),
        ),
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

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.inv});
  final Investment inv;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPTION',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            inv.description,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          if (inv.unlockedAtDay != null) ...[
            const SizedBox(height: 8),
            Text(
              'Débloqué à partir de J${inv.unlockedAtDay}.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.accentOrange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.qty,
    required this.avgCost,
    required this.price,
  });

  final int qty;
  final double avgCost;
  final double price;

  @override
  Widget build(BuildContext context) {
    final value = (price * qty).round();
    final cost = (avgCost * qty).round();
    final pnl = value - cost;
    final color = pnl > 0
        ? AppColors.positive
        : (pnl < 0 ? AppColors.negative : AppColors.textSecondary);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TA POSITION',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _Row(label: 'Quantité', value: '$qty actions'),
          _Row(
              label: 'PRU',
              value: '${avgCost.toStringAsFixed(0)} €'),
          _Row(label: 'Valeur actuelle', value: formatMoney(value)),
          _Row(
            label: 'Plus-value latente',
            value: pnl >= 0 ? '+${formatMoney(pnl)}' : formatMoney(pnl),
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
