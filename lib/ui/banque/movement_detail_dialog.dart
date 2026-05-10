import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../models/ledger_entry.dart';

void showMovementDetailDialog(BuildContext context, LedgerEntry entry) {
  showDialog<void>(
    context: context,
    builder: (_) => _MovementDetailDialog(entry: entry),
  );
}

class _MovementDetailDialog extends StatelessWidget {
  const _MovementDetailDialog({required this.entry});
  final LedgerEntry entry;

  String _kindLabel() {
    switch (entry.kind) {
      case LedgerEntryKind.passiveIncome:
        return 'Partenariat Insta';
      case LedgerEntryKind.shopPurchase:
        return 'Achat';
      case LedgerEntryKind.stockBuy:
        return 'Achat en bourse';
      case LedgerEntryKind.stockSell:
        return 'Vente en bourse';
      case LedgerEntryKind.momTreatment:
        return 'Traitement hôpital';
      case LedgerEntryKind.choiceIncome:
        return 'Revenu narratif';
      case LedgerEntryKind.choiceExpense:
        return 'Dépense narrative';
    }
  }

  String _timeFor() {
    switch (entry.kind) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final positive = entry.amount > 0;
    final color = positive ? AppColors.positive : AppColors.negative;
    return Dialog(
      backgroundColor: AppColors.paperCream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child:
                    Text(entry.emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _kindLabel().toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                entry.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${positive ? '+' : '-'}${formatMoney(entry.amount.abs())}',
                style: GoogleFonts.crimsonPro(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0x141A1A1A)),
            const SizedBox(height: 12),
            _Row(label: 'Jour', value: 'J${entry.day}'),
            _Row(label: 'Date', value: formatGameDate(entry.day)),
            _Row(label: 'Heure', value: _timeFor()),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentOrange,
                ),
                child: const Text(
                  'Fermer',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
