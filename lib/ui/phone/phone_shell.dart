import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/phone_apps.dart';
import '../../data/banque_data.dart';
import '../../data/day_events.dart';
import '../../data/epilogues.dart';
import '../../providers/epilogue_provider.dart';
import '../../providers/incoming_call_provider.dart';
import '../../providers/lock_notifications_provider.dart';
import '../../providers/phone_state_provider.dart';
import '../../providers/portfolio_provider.dart';
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
import 'screens/epilogue_screen.dart';
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
  /// Navigator IMBRIQUÉ : les fils de conversation se pushent ici, sous
  /// les overlays (transition, appel, épilogue) — avant, ces écrans se
  /// jouaient invisibles SOUS les routes du Navigator racine.
  final _phoneNavKey = GlobalKey<NavigatorState>();

  /// File d'attente des bannières (plusieurs events sur une même avance
  /// s'empilaient au même endroit) — on les joue l'une après l'autre.
  final List<DayEvent> _bannerQueue = [];
  bool _bannerShowing = false;

  void _enqueueBanner(DayEvent e) {
    _bannerQueue.add(e);
    _drainBanners();
  }

  Future<void> _drainBanners() async {
    if (_bannerShowing) return;
    _bannerShowing = true;
    while (_bannerQueue.isNotEmpty && mounted) {
      final e = _bannerQueue.removeAt(0);
      await showPhoneNotification(
        context,
        appId: e.notifAppId,
        title: e.notifTitle,
        body: e.notifBody,
        onTap: () =>
            ref.read(phoneStateProvider.notifier).openApp(e.notifAppId),
      );
    }
    _bannerShowing = false;
  }

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
        // Cas spécial : un event marqué `isIncomingCall` déclenche
        // l'écran plein d'appel à la place du banner.
        // Les appels passent même en DND (comportement iOS « urgence »).
        if (next.isIncomingCall) {
          ref.read(incomingCallProvider.notifier).state = IncomingCall(
            displayName: next.notifBody.split('·').first.trim(),
            subtitle: next.notifTitle,
            masked: next.notifBody.toLowerCase().contains('masqué'),
            emoji: '📞',
            avatarColor: 0xFF6B7385,
            transcript: next.callTranscript,
            callerId: next.callerId,
          );
          return;
        }
        final phone = ref.read(phoneStateProvider);
        if (phone.isLocked) return; // pas de banner sur lock screen
        // DND : on supprime le banner mais on garde la notif sur lock.
        if (phone.dndEnabled) return;
        if (!mounted) return;
        _enqueueBanner(next);
      });
      // Verrouillage nocturne ou épilogue : on referme la pile de
      // conversations du navigator imbriqué (sinon le lock/l'épilogue
      // apparaîtrait sous un fil ouvert).
      ref.listenManual(
          phoneStateProvider.select((s) => s.isLocked), (prev, next) {
        if (next == true && prev != true) {
          _phoneNavKey.currentState?.popUntil((r) => r.isFirst);
        }
      });
      ref.listenManual(epilogueProvider, (prev, next) {
        if (next != null) {
          _phoneNavKey.currentState?.popUntil((r) => r.isFirst);
        }
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
        // Fin de partie : la réponse au SMS final de Camille (J112)
        // déclenche l'épilogue calculé depuis l'état réel de la partie.
        if (newKeys.contains('epilogue_j112')) {
          _showEpilogue(next);
        }
      });
    });
  }

  /// Calcule l'épilogue mérité (solde réel + choix pivots) et l'affiche.
  /// Le solde reprend la formule de la Banque : départ + mouvements
  /// canoniques échus + mouvements dynamiques (achats/gains du joueur).
  void _showEpilogue(Map<String, SentReply> replies) {
    final p = ref.read(phoneStateProvider);
    var balance = kStartingBalance;
    for (final m in kMovements) {
      if (m.day <= p.currentDay) balance += m.amount;
    }
    for (final m in p.dynamicMovements) {
      if (m.day <= p.currentDay) balance += m.amount;
    }
    // La richesse compte le portefeuille : investir ne doit pas mener
    // au deuil alors que Shen est riche sur le papier.
    balance += ref.read(portfolioMarketValueProvider).round();
    final epilogue = resolveEpilogue(
      finalBalance: balance,
      mood: p.mood,
      repliesByBeat: {
        for (final e in replies.entries) e.key: e.value.text,
      },
    );
    ref.read(epilogueProvider.notifier).state = epilogue;
  }

  @override
  Widget build(BuildContext context) {
    final transition = ref.watch(beatTransitionProvider);
    final call = ref.watch(incomingCallProvider);
    final epilogue = ref.watch(epilogueProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Le cœur du téléphone (lock / home / apps) + les fils poussés.
          Navigator(
            key: _phoneNavKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
              settings: settings,
              builder: (_) => const _PhoneRoot(),
            ),
          ),
          // Overlays, du plus discret au plus impérieux :
          // transition < appel entrant < épilogue.
          if (transition != null) TransitionScreen(transition: transition),
          if (call != null) IncomingCallScreen(call: call),
          if (epilogue != null)
            EpilogueScreen(
              epilogue: epilogue,
              onClose: () =>
                  ref.read(epilogueProvider.notifier).state = null,
            ),
        ],
      ),
    );
  }

}

/// Cœur du téléphone : lock → home → app ouverte. Vit comme PREMIÈRE
/// route du Navigator imbriqué de PhoneShell — les conversations se
/// pushent au-dessus de lui, mais SOUS les overlays du shell.
class _PhoneRoot extends ConsumerWidget {
  const _PhoneRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(phoneStateProvider);

    Widget body;
    if (p.isLocked) {
      body = const LockScreen();
    } else if (p.openAppId != null) {
      body = _routeApp(ref, p.openAppId!);
    } else {
      body = const HomeScreen();
    }

    return AnimatedSwitcher(
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
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey('${p.isLocked}-${p.openAppId}'),
        child: body,
      ),
    );
  }

  /// Routing par appId vers le bon écran.
  /// Chaque app est wrappée dans AppTutorialOverlay qui affiche un
  /// popup d'explication à la première ouverture.
  Widget _routeApp(WidgetRef ref, String id) {
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
        return (() {
        final meta = appByIdOrNull(id);
        if (meta == null) {
          // App disparue (vieille save) : on referme proprement.
          Future.microtask(
              () => ref.read(phoneStateProvider.notifier).closeApp());
          return const HomeScreen();
        }
        return ShellApp(meta: meta);
      })();
    }
    return AppTutorialOverlay(appId: id, child: app);
  }
}
