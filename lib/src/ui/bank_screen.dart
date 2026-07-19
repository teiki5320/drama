import 'package:flutter/material.dart';

import '../engine.dart';
import '../palette.dart';
import 'widgets.dart';

/// L'appli « Ma Banque » : le compte de Shen, opération par opération.
/// La précarité en chiffres — chaque coup dur de l'histoire s'y lira.
class BankScreen extends StatelessWidget {
  const BankScreen({super.key, required this.engine, required this.onBack});

  final GameEngine engine;
  final VoidCallback onBack;

  String _euros(double v) {
    final s = v.abs().toStringAsFixed(2).replaceAll('.', ',');
    return '${v < 0 ? '−' : '+'}$s €';
  }

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final solde = engine.bankBalance.toStringAsFixed(2).replaceAll('.', ',');
    return Container(
      color: pal.threadBg,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameClockBar(engine: engine),
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: pal.chev, size: 22),
                  tooltip: 'Accueil',
                ),
                Text(
                  'Ma Banque',
                  style: TextStyle(
                    color: pal.headText,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1F6D57), Color(0xFF123F33)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMPTE COURANT · S. MARCHAND',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$solde €',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'FR76 •••• •••• 4207   ·   Découvert autorisé : 0,00 €',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Text(
                'DERNIÈRES OPÉRATIONS',
                style: TextStyle(
                  color: pal.meta,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: engine.bankOps.length,
                itemBuilder: (context, i) {
                  final op = engine.bankOps[i];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: pal.rowBorder, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                op.label,
                                style: TextStyle(
                                  color: pal.headText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                op.date,
                                style: TextStyle(
                                    color: pal.preview, fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _euros(op.amount),
                          style: TextStyle(
                            color: op.amount >= 0
                                ? const Color(0xFF2E9E5B)
                                : pal.headText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
