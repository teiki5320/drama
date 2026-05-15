import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/phone_apps.dart';
import '../../providers/phone_state_provider.dart';
import '../../providers/sent_replies_provider.dart';
import 'apps/banque_app.dart';
import 'apps/calendrier_app.dart';
import 'apps/cloud_app.dart';
import 'apps/instagram_app.dart';
import 'apps/messages_app.dart';
import 'apps/notes_app.dart';
import 'apps/photos_app.dart';
import 'apps/reglages_app.dart';
import 'apps/shell_app.dart';
import 'apps/telephone_app.dart';
import 'apps/tinder_app.dart';
import 'apps/ubereats_app.dart';
import 'apps/whatsapp_app.dart';
import 'home_screen.dart';
import 'lock_screen.dart';
import 'notification_banner.dart';

/// Contrôleur top-level du téléphone : décide quel écran afficher selon
/// l'état (locked → LockScreen, openApp → l'app concernée, sinon Home).
/// Écoute aussi le moteur d'événements pour afficher un banner quand un
/// événement narratif se déclenche.
class PhoneShell extends ConsumerStatefulWidget {
  const PhoneShell({super.key});

  @override
  ConsumerState<PhoneShell> createState() => _PhoneShellState();
}

class _PhoneShellState extends ConsumerState<PhoneShell> {
  @override
  void initState() {
    super.initState();
    // Écoute le dernier event et affiche un banner quand il change.
    // Le banner ne s'affiche pas si le téléphone est verrouillé ou si
    // le DND est actif (sauf pour Tristan/Maman qui passent).
    Future.microtask(() {
      ref.listenManual(lastTriggeredEventProvider, (_, next) {
        if (next == null) return;
        final phone = ref.read(phoneStateProvider);
        if (phone.isLocked) return; // pas de banner sur lock screen
        if (!mounted) return;
        showPhoneNotification(
          context,
          appId: next.notifAppId,
          title: next.notifTitle,
          body: next.notifBody,
          onTap: () =>
              ref.read(phoneStateProvider.notifier).openApp(next.notifAppId),
        );
      });
      // Auto-progression : quand Shen répond au SMS-clé du beat courant,
      // on enchaîne directement sur le beat suivant.
      ref.listenManual(sentRepliesProvider, (prev, next) {
        final prevKeys = prev?.keys.toSet() ?? <String>{};
        final newKeys = next.keys.toSet().difference(prevKeys);
        if (newKeys.isEmpty) return;
        final notifier = ref.read(phoneStateProvider.notifier);
        for (final beatId in newKeys) {
          notifier.maybeAdvanceAfterReply(beatId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

  /// Routing par appId vers le bon écran.
  Widget _routeApp(String id) {
    switch (id) {
      case 'messages':
        return const MessagesApp();
      case 'notes':
        return const NotesApp();
      case 'photos':
        return const PhotosApp();
      case 'banque':
        return const BanqueApp();
      case 'telephone':
        return const TelephoneApp();
      case 'whatsapp':
        return const WhatsAppApp();
      case 'calendrier':
        return const CalendrierApp();
      case 'ubereats':
        return const UberEatsApp();
      case 'instagram':
        return const InstagramApp();
      case 'tinder':
        return const TinderApp();
      case 'cloud':
        return const CloudApp();
      case 'reglages':
        return const ReglagesApp();
      default:
        return ShellApp(meta: appById(id));
    }
  }
}
