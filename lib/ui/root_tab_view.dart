import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ui_provider.dart';
import 'banque/banque_screen.dart';
import 'insta/insta_screen.dart';
import 'messages/messages_screen.dart';
import 'sidebar.dart';

class RootTabView extends ConsumerWidget {
  const RootTabView({super.key});

  // ACE et CARNET ont été supprimés — l'app pivote vers une version
  // téléphone. Les onglets restants : MESSAGES (narration principale),
  // BANQUE, INSTA. Le home screen téléphone viendra remplacer la
  // sidebar dans une PR suivante.
  static const _tabs = <Widget>[
    MessagesScreen(),
    BanqueScreen(),
    InstaScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedTabProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Sidebar(),
            const VerticalDivider(width: 0.5, thickness: 0.5),
            Expanded(
              child: IndexedStack(index: index, children: _tabs),
            ),
          ],
        ),
      ),
    );
  }
}
