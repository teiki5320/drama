import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'ui/root_tab_view.dart';

void main() {
  runApp(const ProviderScope(child: ContreJourApp()));
}

class ContreJourApp extends StatelessWidget {
  const ContreJourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'À Contre-Jour',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const RootTabView(),
    );
  }
}
