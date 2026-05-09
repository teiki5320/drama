import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/day_entry.dart';

class ScenarioLoader {
  const ScenarioLoader();

  Future<List<DayEntry>> loadAll() async {
    final String raw = await rootBundle.loadString('assets/data/scenario.json');
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => DayEntry.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
