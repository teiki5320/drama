import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
import '../../core/colors.dart';
import 'achats_tab.dart';
import 'compte_tab.dart';
import 'investissement_tab.dart';

class BanqueScreen extends StatefulWidget {
  const BanqueScreen({super.key});

  @override
  State<BanqueScreen> createState() => _BanqueScreenState();
}

class _BanqueScreenState extends State<BanqueScreen> {
  int _sub = 0; // start on COMPTE — c'est la home banque maintenant

  static const _labels = ['COMPTE', 'INVESTISSEMENT', 'ACHATS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BigTitle('Banque'),
          _PillTabs(
            labels: _labels,
            selected: _sub,
            onTap: (i) => setState(() => _sub = i),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: IndexedStack(
              index: _sub,
              children: const [
                CompteTab(),
                InvestissementTab(),
                AchatsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTabs extends StatelessWidget {
  const _PillTabs({
    required this.labels,
    required this.selected,
    required this.onTap,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: _PillTab(
                label: labels[i],
                selected: i == selected,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _PillTab extends StatelessWidget {
  const _PillTab({
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: selected
                    ? AppColors.accentOrange
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              width: 32,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accentOrange
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
