import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/investment.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';

class InvestissementTab extends ConsumerWidget {
  const InvestissementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
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
                _Position(
                  ticker: entry.key,
                  qty: entry.value,
                  current: all
                      .where((i) => i.ticker == entry.key)
                      .firstOrNull
                      ?.price,
                ),
              const SizedBox(height: 16),
            ],
            const _SectionHeader(label: 'Entreprises'),
            const SizedBox(height: 8),
            for (final inv in unlocked) _InvestmentRow(inv: inv),
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

class _Position extends StatelessWidget {
  const _Position(
      {required this.ticker, required this.qty, required this.current});

  final String ticker;
  final int qty;
  final double? current;

  @override
  Widget build(BuildContext context) {
    final value = current == null ? '—' : '${(current! * qty).round()} €';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ticker,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14)),
          Text('$qty actions · $value',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

class _InvestmentRow extends StatelessWidget {
  const _InvestmentRow({required this.inv});
  final Investment inv;

  @override
  Widget build(BuildContext context) {
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
              Text(
                '${inv.ticker} · ${inv.name}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
              Text(
                '${inv.price.toStringAsFixed(0)} €',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            inv.sector,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            inv.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.45,
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
