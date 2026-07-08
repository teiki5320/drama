import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/banque_data.dart';
import '../../../models/phone_state.dart';
import '../../../models/shop_item.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../providers/shop_catalog_provider.dart';
import '../status_bar.dart';

/// App Banque — 3 onglets : Compte / Investissement / Achats. Comme
/// l'ancien BanqueScreen mais intégré dans la métaphore téléphone.
class BanqueApp extends ConsumerStatefulWidget {
  const BanqueApp({super.key});

  @override
  ConsumerState<BanqueApp> createState() => _BanqueAppState();
}

class _BanqueAppState extends ConsumerState<BanqueApp> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(phoneStateProvider);
    final visibleStocks = kStocks
        .where((s) => s.unlockedAtDay == null || s.unlockedAtDay! <= p.currentDay)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF1F2937), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  'Banque',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Icon(Icons.qr_code_scanner,
                    color: Colors.grey.shade500, size: 22),
              ],
            ),
          ),
          // Tabs Compte / Investissement / Achats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _TabPill(
                    label: 'Compte',
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0),
                  ),
                  _TabPill(
                    label: 'Investissement',
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1),
                  ),
                  _TabPill(
                    label: 'Achats',
                    selected: _tab == 2,
                    onTap: () => setState(() => _tab = 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _tab == 0
                ? _CompteView(state: p)
                : _tab == 1
                    ? _InvestissementView(stocks: visibleStocks)
                    : _AchatsView(state: p),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Compte ──────────────────────────────────────────────────────
class _CompteView extends StatelessWidget {
  const _CompteView({required this.state});
  final PhoneState state;

  @override
  Widget build(BuildContext context) {
    // Solde = balance de départ + mouvements canoniques (jour <= currentDay)
    // + mouvements dynamiques (achats du joueur).
    final staticBalance = kStartingBalance +
        kMovements
            .where((m) => m.day <= state.currentDay)
            .fold<int>(0, (a, m) => a + m.amount);
    final dynamicDelta =
        state.dynamicMovements.fold<int>(0, (a, m) => a + m.amount);
    final balance = staticBalance + dynamicDelta;
    final lowBalance = balance < 100;

    // Combine mouvements canoniques + dynamiques pour l'affichage.
    final allMvts = <_DisplayMvt>[
      ...kMovements
          .where((m) => m.day <= state.currentDay)
          .map((m) => _DisplayMvt(
                emoji: m.emoji,
                label: m.label,
                amount: m.amount,
                dateLabel: m.day == 0
                    ? 'La semaine dernière'
                    : 'J${m.day} · ${m.time}',
              )),
      ...state.dynamicMovements.map((m) => _DisplayMvt(
            emoji: m.emoji,
            label: m.label,
            amount: m.amount,
            dateLabel: 'J${m.day} · ${m.time}',
          )),
    ].reversed.toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Solde
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMPTE COURANT',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatMoney(balance),
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  color: lowBalance
                      ? const Color(0xFFE53935)
                      : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mlle Marchand · BNP Paribas',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        if (lowBalance)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE53935).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Color(0xFFE53935), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apple Pay indisponible',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE53935),
                          ),
                        ),
                        Text(
                          'Solde insuffisant pour autoriser un paiement.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Mouvements récents',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: allMvts.map((m) => _MovementRow(mvt: m)).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _DisplayMvt {
  final String emoji;
  final String label;
  final int amount;
  final String dateLabel;
  const _DisplayMvt({
    required this.emoji,
    required this.label,
    required this.amount,
    required this.dateLabel,
  });
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.mvt});
  final _DisplayMvt mvt;

  @override
  Widget build(BuildContext context) {
    final isOut = mvt.amount < 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(mvt.emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mvt.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  mvt.dateLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            (mvt.amount > 0 ? '+ ' : '') + _formatMoney(mvt.amount),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isOut
                  ? const Color(0xFFE53935)
                  : const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Investissement ──────────────────────────────────────────────
class _InvestissementView extends ConsumerWidget {
  const _InvestissementView({required this.stocks});
  final List<StockPosition> stocks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);
    final pl = ref.watch(unrealizedPLProvider);
    final mv = ref.watch(portfolioMarketValueProvider);
    final hasPositions = portfolio.positions.isNotEmpty;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // ── Carte résumé portefeuille (PRU / valeur / +-value latente) ──
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('PEA · Mon portefeuille',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white70,
                          letterSpacing: 0.6)),
                  const Spacer(),
                  Text(
                    hasPositions
                        ? '${portfolio.positions.length} ligne${portfolio.positions.length > 1 ? "s" : ""}'
                        : 'Aucune position',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                hasPositions ? '${mv.toStringAsFixed(2)} €' : '0,00 €',
                style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              if (hasPositions)
                Row(
                  children: [
                    Icon(
                      pl >= 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: pl >= 0
                          ? const Color(0xFF66D7A1)
                          : const Color(0xFFFD5068),
                      size: 18,
                    ),
                    Text(
                      'Plus-value latente : ${pl.toStringAsFixed(2)} €',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: pl >= 0
                              ? const Color(0xFF66D7A1)
                              : const Color(0xFFFD5068)),
                    ),
                  ],
                )
              else
                Text(
                  'Tap sur une action pour acheter.',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white60,
                      fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.show_chart, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Marché · Paris',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Text(
                'Ouvert',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...stocks.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _StockRow(stock: s),
            )),
        const SizedBox(height: 16),
        const _MarketNewsFeed(),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Feed de news bourse — affiche les 8 dernières news jusqu'à `currentDay`.
class _MarketNewsFeed extends ConsumerWidget {
  const _MarketNewsFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final news = kMarketNews
        .where((n) => n.day <= day)
        .toList()
        .reversed
        .take(8)
        .toList();
    if (news.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.newspaper,
                  color: Color(0xFF1A1A1A), size: 18),
              const SizedBox(width: 8),
              Text(
                'Actualités marché',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final n in news) ...[
            _NewsRow(news: n),
            if (n != news.last)
              Divider(height: 16, color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }
}

class _NewsRow extends StatelessWidget {
  const _NewsRow({required this.news});
  final MarketNews news;

  @override
  Widget build(BuildContext context) {
    Color sentimentColor() {
      switch (news.sentiment) {
        case '+':
          return const Color(0xFF2E7D32);
        case '-':
          return const Color(0xFFE53935);
        default:
          return Colors.grey.shade500;
      }
    }
    IconData sentimentIcon() {
      switch (news.sentiment) {
        case '+':
          return Icons.trending_up;
        case '-':
          return Icons.trending_down;
        default:
          return Icons.trending_flat;
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: sentimentColor().withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            news.ticker,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: sentimentColor(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.headline,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                news.snippet,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'J${news.day} · ${news.time}',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        Icon(sentimentIcon(), color: sentimentColor(), size: 14),
      ],
    );
  }
}

class _StockRow extends ConsumerWidget {
  const _StockRow({required this.stock});
  final StockPosition stock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final price = priceAt(stock, day);
    final change = change24hAt(stock, day);
    final history = priceHistory(stock, day);
    final up = change >= 0;
    final position = ref.watch(portfolioProvider).positionOf(stock.ticker);
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        _showTradeSheet(context, ref, stock, price);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: position != null
              ? Border.all(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
                  width: 1)
              : null,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      stock.ticker,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    if (position != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${position.qty}×',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  stock.name,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 70,
              height: 28,
              child: CustomPaint(
                painter: _SparklinePainter(
                  points: history,
                  color: up
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE53935),
                ),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price.toStringAsFixed(2),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  '${up ? "+" : ""}${change.toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: up
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTradeSheet(
      BuildContext context, WidgetRef ref, StockPosition s, double price) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _TradeSheet(stock: s, price: price),
    );
  }
}

/// Bottom sheet d'achat / vente d'une action.
class _TradeSheet extends ConsumerStatefulWidget {
  const _TradeSheet({required this.stock, required this.price});
  final StockPosition stock;
  final double price;

  @override
  ConsumerState<_TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends ConsumerState<_TradeSheet> {
  int _qty = 1;
  String _action = 'buy';
  String? _error;

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(portfolioProvider).positionOf(widget.stock.ticker);
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final price = priceAt(widget.stock, day);
    final total = price * _qty;
    final canSell = position != null && position.qty >= _qty;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(widget.stock.ticker,
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  Text(widget.stock.name,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.grey.shade600)),
                  const Spacer(),
                  Text('${price.toStringAsFixed(2)} €',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              Text(widget.stock.description,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 14),
              if (position != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text('Position : ${position.qty} actions',
                          style: GoogleFonts.inter(fontSize: 12)),
                      const Spacer(),
                      Text(
                          'PRU ${position.pru.toStringAsFixed(2)} €',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              // Toggle Achat / Vente
              Row(
                children: [
                  Expanded(
                    child: _ToggleBtn(
                      label: 'Acheter',
                      active: _action == 'buy',
                      color: const Color(0xFF2E7D32),
                      onTap: () => setState(() {
                        _action = 'buy';
                        _error = null;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ToggleBtn(
                      label: 'Vendre',
                      active: _action == 'sell',
                      color: const Color(0xFFE53935),
                      onTap: position == null
                          ? () {}
                          : () => setState(() {
                                _action = 'sell';
                                _error = null;
                              }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Quantité
              Row(
                children: [
                  Text('Quantité',
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _qty > 1
                        ? () => setState(() {
                              _qty--;
                              _error = null;
                            })
                        : null,
                  ),
                  SizedBox(
                    width: 50,
                    child: Center(
                      child: Text('$_qty',
                          style: GoogleFonts.inter(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() {
                      _qty++;
                      _error = null;
                    }),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Text(
                      _action == 'buy'
                          ? 'Coût total'
                          : 'Produit de vente',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: Colors.grey.shade700)),
                  const Spacer(),
                  Text(
                      '${total.toStringAsFixed(2)} €',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _action == 'buy'
                              ? const Color(0xFFE53935)
                              : const Color(0xFF2E7D32))),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: const Color(0xFFE53935))),
              ],
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  final notifier = ref.read(portfolioProvider.notifier);
                  final err = _action == 'buy'
                      ? notifier.buy(
                          ticker: widget.stock.ticker, qty: _qty, price: price)
                      : (canSell
                          ? notifier.sell(
                              ticker: widget.stock.ticker,
                              qty: _qty,
                              price: price)
                          : 'Position insuffisante');
                  if (err == null) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() => _error = err);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _action == 'buy'
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _action == 'buy'
                          ? 'Acheter $_qty ${widget.stock.ticker}'
                          : 'Vendre $_qty ${widget.stock.ticker}',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
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

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: active ? color : Colors.grey.shade300, width: 1),
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : Colors.grey.shade700)),
        ),
      ),
    );
  }
}

// ─── Achats ──────────────────────────────────────────────────────
class _AchatsView extends ConsumerStatefulWidget {
  const _AchatsView({required this.state});
  final PhoneState state;

  @override
  ConsumerState<_AchatsView> createState() => _AchatsViewState();
}

class _AchatsViewState extends ConsumerState<_AchatsView> {
  String? _categoryFilter; // null = tout

  @override
  Widget build(BuildContext context) {
    final asyncCatalog = ref.watch(shopCatalogProvider);

    return asyncCatalog.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text('Erreur catalogue : $e',
            style: GoogleFonts.inter(color: Colors.red)),
      ),
      data: (items) {
        final filtered = _categoryFilter == null
            ? items
            : items.where((i) => i.category == _categoryFilter).toList();
        return Column(
          children: [
            // Filtres catégorie en pills horizontales
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CategoryPill(
                    label: 'Tout',
                    selected: _categoryFilter == null,
                    onTap: () => setState(() => _categoryFilter = null),
                  ),
                  ...kShopCategories.entries.map((e) => _CategoryPill(
                        label: e.value,
                        selected: _categoryFilter == e.key,
                        onTap: () => setState(() => _categoryFilter = e.key),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, i) =>
                    _ShopCard(item: filtered[i], state: widget.state),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: selected
                    ? Colors.transparent
                    : const Color(0xFFE0E0E0)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  selected ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopCard extends ConsumerWidget {
  const _ShopCard({required this.item, required this.state});
  final ShopItem item;
  final PhoneState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = kStartingBalance +
        kMovements
            .where((m) => m.day <= state.currentDay)
            .fold<int>(0, (a, m) => a + m.amount) +
        state.dynamicMovements.fold<int>(0, (a, m) => a + m.amount);
    final owned = state.ownedItems.contains(item.id);
    final lockedByMood = state.mood < item.requiredMood;
    final lockedByRep = state.reputation < item.requiredReputation;
    final tooExpensive = balance < item.price;
    final canBuy = !owned && !lockedByMood && !lockedByRep && !tooExpensive;

    String btnLabel;
    Color btnBg;
    if (owned) {
      btnLabel = 'Possédé';
      btnBg = const Color(0xFF8B8B8B);
    } else if (lockedByMood) {
      btnLabel = 'Mood ≥ ${item.requiredMood} requis';
      btnBg = Colors.grey.shade400;
    } else if (lockedByRep) {
      btnLabel = '⭐ ${item.requiredReputation} requis';
      btnBg = Colors.grey.shade400;
    } else if (tooExpensive) {
      btnLabel = 'Trop cher';
      btnBg = Colors.grey.shade400;
    } else {
      btnLabel = 'Acheter ${_formatMoney(item.price)}';
      btnBg = const Color(0xFFD97757);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.crimsonPro(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
            ),
          ),
          // Deltas mood/réputation
          if (item.moodGain != 0 || item.reputationGain != 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  if (item.moodGain != 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        '😊 ${item.moodGain > 0 ? "+" : ""}${item.moodGain}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: item.moodGain > 0
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFE53935),
                        ),
                      ),
                    ),
                  if (item.reputationGain != 0)
                    Text(
                      '⭐ ${item.reputationGain > 0 ? "+" : ""}${item.reputationGain}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFFD97757),
                      ),
                    ),
                ],
              ),
            ),
          // Bouton acheter
          InkWell(
            onTap: () {
              if (canBuy) {
                HapticFeedback.mediumImpact();
                ref.read(phoneStateProvider.notifier).buyItem(
                      id: item.id,
                      name: item.name,
                      emoji: item.emoji,
                      price: item.price,
                      moodGain: item.moodGain,
                      reputationGain: item.reputationGain,
                      instaCaption: item.generatesInstaPost
                          ? item.instaPostCaption
                          : null,
                      instaEmoji: item.instaPostEmoji,
                    );
              } else {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 1600),
                    backgroundColor: const Color(0xFF1F2937),
                    content: Text(
                      owned
                          ? 'Tu possèdes déjà cet objet.'
                          : tooExpensive
                              ? 'Solde insuffisant : il manque ${_formatMoney(item.price - balance)}.'
                              : lockedByMood
                                  ? 'Mood ${state.mood} → requis ${item.requiredMood}.'
                                  : '⭐ ${state.reputation} → requis ${item.requiredReputation}.',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: btnBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                btnLabel,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatMoney(int v) {
  final s = v.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  final prefix = v < 0 ? '- ' : '';
  return '$prefix$buf €';
}

/// Sparkline minimaliste pour l'historique de prix d'une action.
/// Trace une polyline simple sur le canvas, sans grille, à 1px.
class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.points, required this.color});
  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final minV = points.reduce((a, b) => a < b ? a : b);
    final maxV = points.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs();
    final dx = size.width / (points.length - 1);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final t = range == 0 ? 0.5 : (points[i] - minV) / range;
      final y = size.height - t * size.height;
      final x = i * dx;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.points != points || old.color != color;
}
