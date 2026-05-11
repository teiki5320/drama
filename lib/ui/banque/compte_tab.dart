import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../engine/economy_engine.dart';
import '../../models/ledger_entry.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';
import 'all_movements_screen.dart';
import 'movement_detail_dialog.dart';
import 'spending_breakdown.dart';
import 'stock_chart.dart';

class CompteTab extends ConsumerWidget {
  const CompteTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final investments = ref.watch(investmentsProvider);

    var portfolioValue = 0.0;
    var portfolioCost = 0.0;
    investments.whenData((list) {
      s.stockHoldings.forEach((ticker, qty) {
        final inv = list.where((i) => i.ticker == ticker).firstOrNull;
        if (inv == null) return;
        final price = engine.currentPrice(s, inv);
        portfolioValue += price * qty;
        final avg = s.stockAvgCost[ticker] ?? 0.0;
        portfolioCost += avg * qty;
      });
    });
    final pnl = (portfolioValue - portfolioCost).round();
    final patrimoine = s.argent + portfolioValue.round();

    final hist = s.wealthHistory;
    final wealthDelta = hist.length >= 2 ? hist.last - hist[hist.length - 2] : 0;
    final wealthDeltaPct = hist.length >= 2 && hist[hist.length - 2] > 0
        ? wealthDelta / hist[hist.length - 2] * 100
        : 0.0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        _HeroCompte(
          argent: s.argent,
          patrimoine: patrimoine,
          delta: wealthDelta,
          deltaPct: wealthDeltaPct,
          day: s.currentDay,
        ),
        const SizedBox(height: 14),
        _WealthChartCard(history: hist.map((e) => e.toDouble()).toList()),
        const SizedBox(height: 14),
        _StatGrid(
          liquide: s.argent,
          portefeuille: portfolioValue.round(),
          pnl: pnl,
          revenusJour: engine.passiveIncome(s.followers),
          followers: s.followers,
          tagline: engine.instaTagline(s.followers),
        ),
        const SizedBox(height: 14),
        SpendingBreakdown(entries: s.ledger),
        if (s.ledger.any((e) => e.amount < 0))
          const SizedBox(height: 14),
        // La carte deadline n'apparaît qu'à partir de J2 (post-diagnostic
        // Aubin), sinon le coût des 18 000 € est un spoiler à J1.
        if (s.currentDay >= 2) ...[
          _MomDeadlineCard(
            paid: s.isMomTreatmentPaid,
            argent: s.argent,
            currentDay: s.currentDay,
          ),
          const SizedBox(height: 14),
        ],
        _MovementsCard(entries: s.ledger),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// HERO
// ─────────────────────────────────────────────────────────────────────

class _HeroCompte extends StatelessWidget {
  const _HeroCompte({
    required this.argent,
    required this.patrimoine,
    required this.delta,
    required this.deltaPct,
    required this.day,
  });

  final int argent;
  final int patrimoine;
  final int delta;
  final double deltaPct;
  final int day;

  @override
  Widget build(BuildContext context) {
    final positive = delta >= 0;
    final deltaColor = delta == 0
        ? AppColors.textSecondary
        : (positive ? AppColors.positive : AppColors.negative);

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
                'COMPTE COURANT',
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
                  formatGameDate(day).toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formatMoney(argent),
            style: GoogleFonts.crimsonPro(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.0,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: deltaColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      delta == 0
                          ? Icons.remove
                          : (positive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                      size: 12,
                      color: deltaColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      delta == 0
                          ? '0 € · 24h'
                          : '${formatMoneySigned(delta)} (${positive ? '+' : ''}${deltaPct.toStringAsFixed(2)} %)',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: deltaColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Patrimoine ${formatMoney(patrimoine)}',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// CHART
// ─────────────────────────────────────────────────────────────────────

class _WealthChartCard extends StatefulWidget {
  const _WealthChartCard({required this.history});
  final List<double> history;

  @override
  State<_WealthChartCard> createState() => _WealthChartCardState();
}

class _WealthChartCardState extends State<_WealthChartCard> {
  int _windowDays = 30; // -1 = all, 7, 30

  List<double> get _windowed {
    if (_windowDays < 0 || widget.history.length <= _windowDays) {
      return widget.history;
    }
    return widget.history
        .sublist(widget.history.length - _windowDays);
  }

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
                'ÉVOLUTION DU PATRIMOINE',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              _TimeframePill(
                label: '7j',
                selected: _windowDays == 7,
                onTap: () => setState(() => _windowDays = 7),
              ),
              const SizedBox(width: 4),
              _TimeframePill(
                label: '30j',
                selected: _windowDays == 30,
                onTap: () => setState(() => _windowDays = 30),
              ),
              const SizedBox(width: 4),
              _TimeframePill(
                label: 'Tout',
                selected: _windowDays < 0,
                onTap: () => setState(() => _windowDays = -1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StockChart(values: _windowed, height: 130),
        ],
      ),
    );
  }
}

class _TimeframePill extends StatelessWidget {
  const _TimeframePill({
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.accentOrange : const Color(0xFFEFE9D8),
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

// ─────────────────────────────────────────────────────────────────────
// STAT GRID
// ─────────────────────────────────────────────────────────────────────

class _StatGrid extends StatelessWidget {
  const _StatGrid({
    required this.liquide,
    required this.portefeuille,
    required this.pnl,
    required this.revenusJour,
    required this.followers,
    required this.tagline,
  });

  final int liquide;
  final int portefeuille;
  final int pnl;
  final int revenusJour;
  final int followers;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final pnlColor = pnl > 0
        ? AppColors.positive
        : (pnl < 0 ? AppColors.negative : null);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                label: 'Liquidités',
                value: formatMoney(liquide),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniStat(
                label: 'Bourse',
                value: formatMoney(portefeuille),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                label: 'Plus-value latente',
                value: formatMoneySigned(pnl),
                valueColor: pnlColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniStat(
                label: 'Partenariats',
                value: '${formatMoney(revenusJour)}/jour',
                hint: '$followers abonnés · $tagline',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.valueColor,
    this.hint,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(
              hint!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// MOM DEADLINE
// ─────────────────────────────────────────────────────────────────────

class _MomDeadlineCard extends StatelessWidget {
  const _MomDeadlineCard({
    required this.paid,
    required this.argent,
    required this.currentDay,
  });

  final bool paid;
  final int argent;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    final cost = EconomyEngine.kMomTreatmentCost;
    final deadline = EconomyEngine.kMomDeadlineDay;
    final daysLeft = deadline - currentDay;
    final progress = (argent / cost).clamp(0.0, 1.0);

    // Intensité progressive : neutre avant J30, jaune J30-41, rouge J42+
    final urgent = !paid && daysLeft <= 3 && daysLeft >= 0;
    final warning = !paid && daysLeft <= 15 && daysLeft > 3;
    final tint = paid
        ? AppColors.positive
        : (urgent
            ? AppColors.negative
            : (warning ? const Color(0xFFD4A437) : null));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: tint == null
            ? AppColors.cardBg
            : tint.withValues(alpha: 0.06),
        border: Border.all(
          color: tint == null
              ? const Color(0x141A1A1A)
              : tint.withValues(alpha: 0.45),
          width: urgent ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                urgent ? '🚨' : '🏥',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  urgent
                      ? 'URGENT — Traitement de Maman'
                      : 'Traitement de Maman',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: urgent ? AppColors.negative : null,
                  ),
                ),
              ),
              if (paid)
                Text(
                  'Payé ✓',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.positive,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            paid
                ? 'Hôpital Tenon · ${formatMoney(cost)} versés.'
                : daysLeft >= 0
                    ? '${formatMoney(cost)} à réunir avant ${formatGameDate(deadline)} · il te reste $daysLeft jour${daysLeft == 1 ? '' : 's'}.'
                    : 'Deadline dépassée.',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: tint ?? AppColors.textSecondary,
              fontWeight: urgent ? FontWeight.w700 : FontWeight.w400,
              height: 1.4,
            ),
          ),
          if (!paid) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: urgent ? 8 : 6,
                backgroundColor: const Color(0xFFEAE6DD),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0
                      ? AppColors.positive
                      : (tint ?? AppColors.accentOrange),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)} %',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${formatMoney(argent.clamp(0, cost))} / ${formatMoney(cost)}',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// MOVEMENTS
// ─────────────────────────────────────────────────────────────────────

class _MovementsCard extends StatelessWidget {
  const _MovementsCard({required this.entries});
  final List<LedgerEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
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
            Text(
              'MOUVEMENTS',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Aucun mouvement encore.',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    final last = entries.reversed.take(8).toList(growable: false);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Text(
                  'MOUVEMENTS',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${entries.length} au total',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x141A1A1A)),
          for (var i = 0; i < last.length; i++) ...[
            _MovementRow(entry: last[i]),
            if (i < last.length - 1)
              const Divider(
                height: 1,
                indent: 56,
                color: Color(0x0F1A1A1A),
              ),
          ],
          if (entries.length > last.length) ...[
            const Divider(height: 1, color: Color(0x141A1A1A)),
            Builder(
              builder: (ctx) => InkWell(
                onTap: () => Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (_) => const AllMovementsScreen(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Voir tous les mouvements (${entries.length}) →',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.entry});
  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final positive = entry.amount > 0;
    final color = positive ? AppColors.positive : AppColors.negative;
    final sign = positive ? '+' : '-';
    return InkWell(
      onTap: () => showMovementDetailDialog(context, entry),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEDF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x0F1A1A1A)),
              ),
              alignment: Alignment.center,
              child: Text(entry.emoji,
                  style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${formatGameDateShort(entry.day)} · ${_timeFor(entry.kind)}',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$sign${formatMoney(entry.amount.abs())}',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _Iter<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

String _timeFor(LedgerEntryKind kind) {
  switch (kind) {
    case LedgerEntryKind.passiveIncome:
      return '08:14';
    case LedgerEntryKind.shopPurchase:
      return '14:30';
    case LedgerEntryKind.stockBuy:
      return '10:47';
    case LedgerEntryKind.stockSell:
      return '16:02';
    case LedgerEntryKind.momTreatment:
      return '11:30';
    case LedgerEntryKind.choiceExpense:
    case LedgerEntryKind.choiceIncome:
      return '20:00';
    case LedgerEntryKind.dailyExpense:
      return '12:30';
    case LedgerEntryKind.rent:
      return '00:01';
  }
}
