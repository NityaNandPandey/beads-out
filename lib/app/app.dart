import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'dependency_injection.dart';
import 'routes.dart';

class BeadsOutApp extends ConsumerWidget {
  const BeadsOutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    ref.read(feedbackServiceProvider).syncSettings(
          haptics: settings.hapticsEnabled,
          sfx: settings.sfxEnabled,
        );

    return MaterialApp.router(
      title: 'Beads Out',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
