import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'banque/banque_screen.dart';
import 'carnet/carnet_screen.dart';
import 'insta/insta_screen.dart';
import 'messages/messages_screen.dart';

class RootTabView extends ConsumerStatefulWidget {
  const RootTabView({super.key});

  @override
  ConsumerState<RootTabView> createState() => _RootTabViewState();
}

class _RootTabViewState extends ConsumerState<RootTabView> {
  int _index = 0;

  static const _tabs = <Widget>[
    CarnetScreen(),
    BanqueScreen(),
    InstaScreen(),
    MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Carnet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance),
            label: 'Banque',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'Insta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
