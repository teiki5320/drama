import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/phone_apps.dart';
import '../../providers/phone_state_provider.dart';
import 'apps/messages_app.dart';
import 'apps/shell_app.dart';
import 'home_screen.dart';
import 'lock_screen.dart';

/// Contrôleur top-level du téléphone : décide quel écran afficher selon
/// l'état (locked → LockScreen, openApp → l'app concernée, sinon Home).
class PhoneShell extends ConsumerWidget {
  const PhoneShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(phoneStateProvider);

    Widget body;
    if (p.isLocked) {
      body = const LockScreen();
    } else if (p.openAppId != null) {
      body = _routeApp(p.openAppId!);
    } else {
      body = const HomeScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey('${p.isLocked}-${p.openAppId}'),
          child: body,
        ),
      ),
    );
  }

  /// Routing par appId vers le bon écran. Les apps non encore
  /// implémentées tombent sur la coquille générique.
  Widget _routeApp(String id) {
    switch (id) {
      case 'messages':
        return const MessagesApp();
      default:
        return ShellApp(meta: appById(id));
    }
  }
}
