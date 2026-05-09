import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../engine/economy_engine.dart';
import '../../models/shop_item.dart';
import '../../providers/catalogs_provider.dart';
import '../../providers/game_state_provider.dart';

const _categoryLabels = <String, String>{
  'all': 'Tout',
  'vehicule': 'Véhicule',
  'mode': 'Mode',
  'beaute': 'Beauté',
  'voyage': 'Voyage',
  'tech': 'Tech',
  'deco': 'Déco',
  'bijoux': 'Bijoux',
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
    final state = ref.watch(gameStateProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erreur : $e')),
      data: (items) {
        final categories = ['all', ..._categoryLabels.keys.where((k) => k != 'all')];
        final visible = _filter == 'all'
            ? items
            : items.where((i) => i.category == _filter).toList();

        return Column(
          children: [
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final selected = cat == _filter;
                  return ChoiceChip(
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = cat),
                    label: Text(_categoryLabels[cat] ?? cat),
                    selectedColor:
                        AppColors.accentOrange.withValues(alpha: 0.2),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: visible.length,
                itemBuilder: (context, i) => _ShopCard(item: visible[i]),
              ),
            ),
          ],
        );
      },
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
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(
            item.name,
            style: const TextStyle(
                fontSize: 13.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item.description,
              style: GoogleFonts.inter(
                fontStyle: FontStyle.italic,
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
          Row(
            children: [
              if (item.moodGain != 0)
                _Delta(emoji: '😊', value: item.moodGain),
              if (item.reputationGain != 0) ...[
                if (item.moodGain != 0) const SizedBox(width: 8),
                _Delta(emoji: '⭐', value: item.reputationGain),
              ],
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (owned || !check.ok)
                  ? null
                  : () => ref
                      .read(gameStateProvider.notifier)
                      .buyItem(item),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: Text(owned
                  ? 'Possédé'
                  : (check.ok ? '${item.price} €' : check.reason ?? '—')),
            ),
          ),
        ],
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
    final color =
        value >= 0 ? AppColors.positive : AppColors.negative;
    final sign = value >= 0 ? '+' : '';
    return Text(
      '$emoji $sign$value',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
