import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../models/ledger_entry.dart';

/// Décomposition des dépenses par grande catégorie. Affichage : barre
/// horizontale stackée + légende.
class SpendingBreakdown extends StatelessWidget {
  const SpendingBreakdown({super.key, required this.entries});
  final List<LedgerEntry> entries;

  @override
  Widget build(BuildContext context) {
    final buckets = <_Bucket>[
      _Bucket(label: 'Médical', emoji: '🏥', color: const Color(0xFFD97757)),
      _Bucket(label: 'Achats', emoji: '🛍️', color: const Color(0xFFE8AC83)),
      _Bucket(label: 'Bourse', emoji: '📈', color: const Color(0xFF8E8B7A)),
      _Bucket(label: 'Narratif', emoji: '🧾', color: const Color(0xFFB5A282)),
    ];

    for (final e in entries) {
      if (e.amount >= 0) continue;
      final abs = e.amount.abs();
      switch (e.kind) {
        case LedgerEntryKind.momTreatment:
          buckets[0].total += abs;
          break;
        case LedgerEntryKind.shopPurchase:
          buckets[1].total += abs;
          break;
        case LedgerEntryKind.stockBuy:
          buckets[2].total += abs;
          break;
        case LedgerEntryKind.choiceExpense:
          buckets[3].total += abs;
          break;
        case LedgerEntryKind.passiveIncome:
        case LedgerEntryKind.stockSell:
        case LedgerEntryKind.choiceIncome:
          break;
      }
    }

    final total = buckets.fold<int>(0, (s, b) => s + b.total);
    if (total == 0) return const SizedBox.shrink();

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
                'OÙ EST PARTI L\'ARGENT',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                formatMoney(total),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  for (final b in buckets)
                    if (b.total > 0)
                      Expanded(
                        flex: ((b.total / total) * 1000).round(),
                        child: Container(color: b.color),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              for (final b in buckets)
                if (b.total > 0) _LegendItem(bucket: b, total: total),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bucket {
  final String label;
  final String emoji;
  final Color color;
  int total = 0;
  _Bucket({required this.label, required this.emoji, required this.color});
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.bucket, required this.total});
  final _Bucket bucket;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = (bucket.total / total * 100).round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: bucket.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${bucket.emoji} ${bucket.label}',
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$pct %',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
