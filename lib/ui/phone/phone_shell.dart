import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/phone_apps.dart';
import '../../providers/incoming_call_provider.dart';
import '../../providers/lock_notifications_provider.dart';
import '../../providers/phone_state_provider.dart';
import '../../providers/sent_replies_provider.dart';
import '../../providers/transition_provider.dart';
import 'apps/appstore_app.dart';
import 'apps/banque_app.dart';
import 'apps/calendrier_app.dart';
import 'apps/camera_app.dart';
import 'apps/cloud_app.dart';
import 'apps/instagram_app.dart';
import 'apps/messages_app.dart';
import 'apps/notes_app.dart';
import 'apps/photos_app.dart';
import 'apps/plans_app.dart';
import 'apps/reglages_app.dart';
import 'apps/spotify_app.dart';
import 'apps/shell_app.dart';
import 'apps/telephone_app.dart';
import 'apps/tinder_app.dart';
import 'apps/ubereats_app.dart';
import 'apps/whatsapp_app.dart';
import 'app_tutorial_overlay.dart';
import 'home_screen.dart';
import 'incoming_call_screen.dart';
import 'lock_screen.dart';
import 'notification_banner.dart';
import 'transition_screen.dart';

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
        // Pousse la notif dans l'historique du lock screen (toujours,
        // même en DND — la pile lock garde la trace).
        ref.read(lockNotificationsProvider.notifier).push(
              LockNotif.fromEvent(next),
            );
        // Cas spécial : un event tagué « appel entrant » déclenche
        // l'écran plein d'appel à la place du banner.
        // Les appels passent même en DND (comportement iOS « urgence »).
        if (next.notifAppId == 'telephone' &&
            next.notifTitle.toLowerCase().contains('appel')) {
          ref.read(incomingCallProvider.notifier).state = IncomingCall(
            displayName: next.notifBody.split('·').first.trim(),
            subtitle: next.notifTitle,
            masked: next.notifBody.toLowerCase().contains('masqué'),
            emoji: '📞',
            avatarColor: 0xFF6B7385,
          );
          return;
        }
        final phone = ref.read(phoneStateProvider);
        if (phone.isLocked) return; // pas de banner sur lock screen
        // DND : on supprime le banner mais on garde la notif sur lock.
        if (phone.dndEnabled) return;
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
    final call = ref.watch(incomingCallProvider);

    Widget body;
    if (call != null) {
      body = IncomingCallScreen(call: call);
    } else if (p.isLocked) {
      body = const LockScreen();
    } else if (p.openAppId != null) {
      body = _routeApp(p.openAppId!);
    } else {
      body = const HomeScreen();
    }

    final transition = ref.watch(beatTransitionProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              if (child.key != null &&
                  (child.key as ValueKey).value.toString().endsWith('-true')) {
                return FadeTransition(opacity: animation, child: child);
              }
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale:
                      Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey('${p.isLocked}-${p.openAppId}-${call != null}'),
              child: body,
            ),
          ),
          // Écran de transition entre beats — empilé au-dessus de tout
          if (transition != null) TransitionScreen(transition: transition),
        ],
      ),
    );
  }

  /// Routing par appId vers le bon écran.
  /// Chaque app est wrappée dans AppTutorialOverlay qui affiche un
  /// popup d'explication à la première ouverture.
  Widget _routeApp(String id) {
    final Widget app;
    switch (id) {
      case 'messages':
        app = const MessagesApp();
        break;
      case 'notes':
        app = const NotesApp();
        break;
      case 'photos':
        app = const PhotosApp();
        break;
      case 'banque':
        app = const BanqueApp();
        break;
      case 'telephone':
        app = const TelephoneApp();
        break;
      case 'whatsapp':
        app = const WhatsAppApp();
        break;
      case 'calendrier':
        app = const CalendrierApp();
        break;
      case 'ubereats':
        app = const UberEatsApp();
        break;
      case 'instagram':
        app = const InstagramApp();
        break;
      case 'tinder':
        app = const TinderApp();
        break;
      case 'cloud':
        app = const CloudApp();
        break;
      case 'reglages':
        app = const ReglagesApp();
        break;
      case 'appstore':
        app = const AppStoreApp();
        break;
      case 'camera':
        app = const CameraApp();
        break;
      case 'maps':
        app = const PlansApp();
        break;
      case 'spotify':
        app = const SpotifyApp();
        break;
      default:
        return ShellApp(meta: appById(id));
    }
    return AppTutorialOverlay(appId: id, child: app);
  }
}
