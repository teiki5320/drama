import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ui_provider.dart';
import 'ace/ace_screen.dart';
import 'banque/banque_screen.dart';
import 'carnet/carnet_screen.dart';
import 'insta/insta_screen.dart';
import 'messages/messages_screen.dart';
import 'sidebar.dart';

class RootTabView extends ConsumerWidget {
  const RootTabView({super.key});

  // Ordre des onglets : ACE (BD animée) en haut, puis CARNET, BANQUE,
  // INSTA, INVIT. (cf. sidebar.dart pour les boutons).
  static const _tabs = <Widget>[
    AceScreen(),
    CarnetScreen(),
    BanqueScreen(),
    InstaScreen(),
    MessagesScreen(),
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
