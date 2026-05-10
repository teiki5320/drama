import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../models/ledger_entry.dart';
import '../../providers/game_state_provider.dart';
import 'movement_detail_dialog.dart';

/// Liste filtrable de tous les mouvements de la partie en cours.
/// Lié depuis CompteTab via "Voir tous les mouvements".
class AllMovementsScreen extends ConsumerStatefulWidget {
  const AllMovementsScreen({super.key});

  @override
  ConsumerState<AllMovementsScreen> createState() =>
      _AllMovementsScreenState();
}

class _AllMovementsScreenState extends ConsumerState<AllMovementsScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final ledger = ref.watch(gameStateProvider).ledger;
    final filtered = ledger.reversed.where(_filter.test).toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      appBar: AppBar(
        title: Text(
          'Tous les mouvements',
          style: GoogleFonts.crimsonPro(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                for (final f in _Filter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterPill(
                      label: f.label,
                      selected: f == _filter,
                      onTap: () => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          if (filtered.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Aucun mouvement pour ce filtre.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final e = filtered[i];
                  return _MovementRow(
                    entry: e,
                    onTap: () => showMovementDetailDialog(context, e),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

enum _Filter {
  all('Tout', null),
  shop('Achats', LedgerEntryKind.shopPurchase),
  partenariats('Partenariats', LedgerEntryKind.passiveIncome),
  bourse('Bourse', null),
  medical('Médical', LedgerEntryKind.momTreatment),
  choix('Choix', null);

  const _Filter(this.label, this.kind);
  final String label;
  final LedgerEntryKind? kind;

  bool test(LedgerEntry e) {
    switch (this) {
      case _Filter.all:
        return true;
      case _Filter.bourse:
        return e.kind == LedgerEntryKind.stockBuy ||
            e.kind == LedgerEntryKind.stockSell;
      case _Filter.choix:
        return e.kind == LedgerEntryKind.choiceIncome ||
            e.kind == LedgerEntryKind.choiceExpense;
      default:
        return e.kind == kind;
    }
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.accentOrange
                : const Color(0x141A1A1A),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.entry, required this.onTap});
  final LedgerEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = entry.amount > 0;
    final color = positive ? AppColors.positive : AppColors.negative;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: const Color(0x141A1A1A)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEDF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x0F1A1A1A)),
              ),
              alignment: Alignment.center,
              child: Text(entry.emoji, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatGameDate(entry.day),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${positive ? '+' : '-'}${formatMoney(entry.amount.abs())}',
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
