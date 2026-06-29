import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'app/dependency_injection.dart';
import 'core/logger/app_logger.dart';
import 'firebase_options.dart';
import 'services/analytics_service.dart';
import 'services/firebase_service.dart';
import 'services/save_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info(
    DefaultFirebaseOptions.isConfigured
        ? 'Starting Beads Out with Firebase'
        : 'Starting Beads Out (Firebase credentials pending)',
  );

  await Hive.initFlutter();

  final saveService = SaveService();
  await saveService.init();

  final firebaseService = FirebaseService();
  await firebaseService.init();

  final analyticsService = AnalyticsService(firebaseService);
  await analyticsService.init();

  runApp(
    ProviderScope(
      overrides: [
        saveServiceProvider.overrideWithValue(saveService),
        firebaseServiceProvider.overrideWithValue(firebaseService),
        analyticsServiceProvider.overrideWithValue(analyticsService),
      ],
      child: const BeadsOutApp(),
    ),
  );
}
