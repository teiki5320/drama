import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';

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

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'Compte courant',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${s.argent} €',
                style: GoogleFonts.crimsonPro(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Portefeuille',
                value: '${portfolioValue.round()} €',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'PNL latente',
                value: pnl >= 0 ? '+$pnl €' : '$pnl €',
                valueColor: pnl > 0
                    ? AppColors.positive
                    : (pnl < 0 ? AppColors.negative : null),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(
          label: 'Patrimoine',
          value: '$patrimoine €',
        ),
        const SizedBox(height: 24),
        _StatCard(
          label: 'Followers',
          value:
              '${s.followers} · « ${engine.instaTagline(s.followers)} »',
        ),
        const SizedBox(height: 8),
        _StatCard(
          label: 'Revenus passifs',
          value: '${engine.passiveIncome(s.followers)} €/jour',
        ),
        const SizedBox(height: 24),
        _StatCard(
          label: 'Traitement maman',
          value: s.isMomTreatmentPaid
              ? '✅ Payé (-${EconomyEngine.kMomTreatmentCost} €)'
              : '⏳ ${EconomyEngine.kMomTreatmentCost} € avant J${EconomyEngine.kMomDeadlineDay}',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor,
  });
  final String label;
  final String value;
  final Color? valueColor;

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
            label,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

extension _Iter<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
