import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog_loader.dart';
import '../models/insta_post.dart';
import '../models/investment.dart';
import '../models/shop_item.dart';

final catalogLoaderProvider = Provider<CatalogLoader>(
  (ref) => const CatalogLoader(),
);

final shopCatalogProvider = FutureProvider<List<ShopItem>>((ref) async {
  return ref.watch(catalogLoaderProvider).loadShop();
});

final investmentsProvider = FutureProvider<List<Investment>>((ref) async {
  return ref.watch(catalogLoaderProvider).loadInvestments();
});

final instaSeedProvider = FutureProvider<List<InstaPost>>((ref) async {
  return ref.watch(catalogLoaderProvider).loadInstaSeed();
});
