import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../models/game_state.dart';
import '../../models/investment.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';

class InvestissementTab extends ConsumerWidget {
  const InvestissementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            if (state.stockHoldings.isNotEmpty) ...[
              const _SectionHeader(label: 'Tes positions'),
              const SizedBox(height: 8),
              for (final entry in state.stockHoldings.entries)
                _PositionCard(
                  ticker: entry.key,
                  qty: entry.value,
                  avgCost: state.stockAvgCost[entry.key] ?? 0.0,
                  inv: all.where((i) => i.ticker == entry.key).firstOrNull,
                  state: state,
                  engine: engine,
                ),
              const SizedBox(height: 16),
            ],
            const _SectionHeader(label: 'Entreprises'),
            const SizedBox(height: 8),
            for (final inv in unlocked)
              _InvestmentRow(inv: inv, state: state, engine: engine),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.crimsonPro(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PositionCard extends ConsumerWidget {
  const _PositionCard({
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
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: const Color(0x141A1A1A)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('$ticker · $qty actions',
            style: GoogleFonts.inter(fontSize: 13.5)),
      );
    }
    final price = engine.currentPrice(state, inv!);
    final value = (price * qty).round();
    final cost = (avgCost * qty).round();
    final pnl = value - cost;
    final pnlColor =
        pnl > 0 ? AppColors.positive : (pnl < 0 ? AppColors.negative : AppColors.textSecondary);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticker,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$qty actions @ ${avgCost.toStringAsFixed(0)} € · maintenant ${price.toStringAsFixed(0)} €',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$value €',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pnl >= 0 ? '+$pnl €' : '$pnl €',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: pnlColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              _SmallButton(
                label: 'Vendre',
                color: AppColors.negative,
                onTap: () => _showTradeSheet(
                  context,
                  ref: ref,
                  inv: inv!,
                  isBuy: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    final variationPct = (current - inv.price) / inv.price * 100;
    final varColor = variationPct > 0.05
        ? AppColors.positive
        : (variationPct < -0.05 ? AppColors.negative : AppColors.textSecondary);
    final canBuy = engine.canBuyStock(state, inv, 1);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${inv.ticker} · ${inv.name}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      inv.sector,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${current.toStringAsFixed(0)} €',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${variationPct >= 0 ? '+' : ''}${variationPct.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                      color: varColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            inv.description,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _SmallButton(
                label: 'Acheter',
                color: AppColors.accentOrange,
                disabled: !canBuy.ok,
                onTap: () => _showTradeSheet(
                  context,
                  ref: ref,
                  inv: inv,
                  isBuy: true,
                ),
              ),
              if (!canBuy.ok) ...[
                const SizedBox(width: 8),
                Text(
                  canBuy.reason ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.disabled = false,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final bg = disabled ? const Color(0xFFEAE6DD) : color;
    final fg = disabled ? AppColors.textSecondary : Colors.white;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

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
    builder: (ctx) => _TradeSheet(inv: inv, isBuy: isBuy),
  );
}

class _TradeSheet extends ConsumerStatefulWidget {
  const _TradeSheet({required this.inv, required this.isBuy});

  final Investment inv;
  final bool isBuy;

  @override
  ConsumerState<_TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends ConsumerState<_TradeSheet> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final price = engine.currentPrice(state, widget.inv);
    final total = (price * _qty).round();
    final maxQty = widget.isBuy
        ? (state.argent ~/ price).clamp(0, 9999)
        : (state.stockHoldings[widget.inv.ticker] ?? 0);
    final canTrade = widget.isBuy
        ? engine.canBuyStock(state, widget.inv, _qty)
        : engine.canSellStock(state, widget.inv.ticker, _qty);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.isBuy ? 'Acheter' : 'Vendre'} ${widget.inv.ticker}',
            style: GoogleFonts.crimsonPro(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.inv.name} · ${price.toStringAsFixed(0)} €/action',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
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
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textSecondary)),
              Text(
                '$total €',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isBuy
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
                      final ctrl = ref.read(gameStateProvider.notifier);
                      if (widget.isBuy) {
                        await ctrl.buyStock(widget.inv, _qty);
                      } else {
                        await ctrl.sellStock(widget.inv, _qty);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    },
              child: Text(
                canTrade.ok
                    ? (widget.isBuy ? 'Confirmer l\'achat' : 'Confirmer la vente')
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
