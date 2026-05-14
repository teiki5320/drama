import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shop_item.dart';

/// Charge `assets/data/shop_catalog.json` une seule fois et expose la
/// liste complète des 27 items achetables.
final shopCatalogProvider = FutureProvider<List<ShopItem>>((ref) async {
  final raw = await rootBundle.loadString('assets/data/shop_catalog.json');
  final list = jsonDecode(raw) as List<dynamic>;
  return list
      .map((e) => ShopItem.fromJson(e as Map<String, dynamic>))
      .toList(growable: false);
});
