import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class DramaApp extends StatelessWidget {
  const DramaApp({super.key});

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
