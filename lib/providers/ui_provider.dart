import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Currently selected tab index in the root sidebar (0 = Carnet).
final selectedTabProvider = StateProvider<int>((ref) => 0);
