import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../models/shop_item.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';

const _categoryLabels = <String, ({String label, String emoji})>{
  'all': (label: 'Tout', emoji: '🛍️'),
  'vehicule': (label: 'Véhicule', emoji: '🛵'),
  'mode': (label: 'Mode', emoji: '👗'),
  'immobilier': (label: 'Immobilier', emoji: '🏠'),
  'art': (label: 'Art', emoji: '🎨'),
  'beaute': (label: 'Beauté', emoji: '🌸'),
  'voyage': (label: 'Voyage', emoji: '✈️'),
  'tech': (label: 'Tech', emoji: '📱'),
  'deco': (label: 'Déco', emoji: '🌿'),
  'bijoux': (label: 'Bijoux', emoji: '💎'),
};

class AchatsTab extends ConsumerStatefulWidget {
  const AchatsTab({super.key});

  @override
  ConsumerState<AchatsTab> createState() => _AchatsTabState();
}

class _AchatsTabState extends ConsumerState<AchatsTab> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(shopCatalogProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erreur : $e')),
      data: (items) {
        final visible = _filter == 'all'
            ? items
            : items.where((i) => i.category == _filter).toList();

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _RecompenseCard()),
            SliverToBoxAdapter(child: _SectionLabel('CATALOGUE')),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  itemCount: _categoryLabels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final cat = _categoryLabels.keys.elementAt(i);
                    final meta = _categoryLabels[cat]!;
                    final selected = cat == _filter;
                    return _CategoryPill(
                      label: '${meta.emoji}  ${meta.label}',
                      selected: selected,
                      onTap: () => setState(() => _filter = cat),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 280,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ShopCard(item: visible[i]),
                  childCount: visible.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecompenseCard extends StatelessWidget {
  const _RecompenseCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEBC9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                'RÉCOMPENSES',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Plus tu progresses, plus de catégories se débloquent. Mood ≥ 4 ouvre Déco, ≥ 5 Tech, ≥ 6 Mode, ≥ 7 Bijoux, ≥ 8 Voyage. Réputation ★ déverrouille les pièces de luxe.',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
          color: AppColors.textSecondary,
        ),
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.accentOrange
                : const Color(0x141A1A1A),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopCard extends ConsumerWidget {
  const _ShopCard({required this.item});

  final ShopItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final engine = ref.watch(economyEngineProvider);
    final check = engine.canBuy(state, item);
    final owned = state.ownedItems.contains(item.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 36)),
              const Spacer(),
              Text(
                _formatPrice(item.price),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item.description,
              style: GoogleFonts.inter(
                fontStyle: FontStyle.italic,
                fontSize: 11.5,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (item.moodGain != 0)
                _Delta(emoji: '😊', value: item.moodGain),
              if (item.reputationGain != 0) ...[
                if (item.moodGain != 0) const SizedBox(width: 10),
                _Delta(emoji: '⭐', value: item.reputationGain),
              ],
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _BuyButton(
              owned: owned,
              ok: check.ok,
              reason: check.reason,
              price: item.price,
              onPressed: () async {
                await ref.read(gameStateProvider.notifier).buyItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPrice(int v) {
    if (v >= 1000) {
      // 8900 -> "8 900 €"
      final s = v.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
        buf.write(s[i]);
      }
      return '${buf.toString()} €';
    }
    return '$v €';
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({
    required this.owned,
    required this.ok,
    required this.reason,
    required this.price,
    required this.onPressed,
  });

  final bool owned;
  final bool ok;
  final String? reason;
  final int price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = owned || !ok;
    final label = owned ? 'Possédé' : (ok ? 'Acheter' : reason ?? '—');
    final bg = disabled ? const Color(0xFFEAE6DD) : AppColors.accentOrange;
    final fg = disabled ? AppColors.textSecondary : Colors.white;

    return InkWell(
      onTap: disabled ? null : onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _Delta extends StatelessWidget {
  const _Delta({required this.emoji, required this.value});
  final String emoji;
  final int value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.positive : AppColors.negative;
    final sign = value >= 0 ? '+' : '';
    return Text(
      '$emoji $sign$value',
      style: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
