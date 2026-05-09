import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/insta_post.dart';
import '../models/investment.dart';
import '../models/shop_item.dart';

class CatalogLoader {
  const CatalogLoader();

  Future<List<ShopItem>> loadShop() async {
    final raw = await rootBundle.loadString('assets/data/shop_catalog.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ShopItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<Investment>> loadInvestments() async {
    final raw = await rootBundle.loadString('assets/data/investments.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Investment.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<InstaPost>> loadInstaSeed() async {
    final raw = await rootBundle.loadString('assets/data/insta_seed.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => InstaPost.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
