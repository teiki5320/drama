import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'ui/onboarding_screen.dart';
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
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(hasSeenOnboardingProvider);
    return async.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const RootTabView(),
      data: (seen) => seen ? const RootTabView() : const OnboardingScreen(),
    );
  }
}
