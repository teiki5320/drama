import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/phone_state_provider.dart';
import 'providers/relationships_provider.dart';
import 'providers/sent_replies_provider.dart';
import 'services/persistence_service.dart';
import 'ui/phone/device_frame.dart';
import 'ui/phone/phone_shell.dart';

/// Point d'entrée — l'app est un faux téléphone. Toute la navigation et
/// la narration passent par `PhoneShell` (lock → home → apps).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );
  runApp(const ProviderScope(child: DramaApp()));
}

class DramaApp extends ConsumerStatefulWidget {
  const DramaApp({super.key});

  @override
  ConsumerState<DramaApp> createState() => _DramaAppState();
}

class _DramaAppState extends ConsumerState<DramaApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    // 1) Hydrate les 3 sources depuis shared_preferences si présentes.
    final phone = await PersistenceService.loadPhoneState();
    if (phone != null && mounted) {
      ref.read(phoneStateProvider.notifier).hydrate(phone);
    }
    final rels = await PersistenceService.loadRelationships();
    if (rels != null && mounted) {
      ref.read(relationshipsProvider.notifier).hydrate(rels);
    }
    final replies = await PersistenceService.loadSentReplies();
    if (replies != null && mounted) {
      ref.read(sentRepliesProvider.notifier).hydrate(replies);
    }

    // 2) Branche l'auto-save sur chaque mutation.
    ref.listenManual(phoneStateProvider, (_, next) {
      PersistenceService.savePhoneState(next);
    });
    ref.listenManual(relationshipsProvider, (_, next) {
      PersistenceService.saveRelationships(next);
    });
    ref.listenManual(sentRepliesProvider, (_, next) {
      PersistenceService.saveSentReplies(next);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drama',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const DeviceFrame(child: PhoneShell()),
    );
  }
}
