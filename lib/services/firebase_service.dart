import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../core/logger/app_logger.dart';
import '../firebase_options.dart';

class FirebaseService {
  FirebaseService();

  bool _initialized = false;
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseRemoteConfig? _remoteConfig;

  bool get isInitialized => _initialized;
  String? get userId => _auth?.currentUser?.uid;
  FirebaseAuth? get auth => _auth;
  FirebaseFirestore? get firestore => _firestore;
  FirebaseRemoteConfig? get remoteConfig => _remoteConfig;

  Future<void> init() async {
    if (_initialized) return;

    if (!DefaultFirebaseOptions.isConfigured) {
      AppLogger.warning(
        'Firebase credentials not set. Run `flutterfire configure` to connect.',
      );
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      _remoteConfig = FirebaseRemoteConfig.instance;

      await _configureRemoteConfig();
      await _configureCrashlytics();

      _initialized = true;
      AppLogger.info('Firebase initialized');
    } catch (error, stackTrace) {
      AppLogger.error('Firebase initialization failed', error, stackTrace);
    }
  }

  Future<void> _configureRemoteConfig() async {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) return;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await remoteConfig.setDefaults(const {
      'ads_enabled': true,
      'daily_challenge_enabled': true,
      'min_app_version': '1.0.0',
    });

    if (kDebugMode) {
      AppLogger.info('Remote Config fetch skipped in debug builds');
      return;
    }

    try {
      await remoteConfig.fetchAndActivate();
    } catch (error) {
      AppLogger.warning('Remote Config fetch failed: $error');
    }
  }

  Future<void> _configureCrashlytics() async {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      return;
    }

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<String?> signInAnonymously() async {
    if (!_initialized || _auth == null) return null;

    try {
      User? user = _auth!.currentUser;

      if (user == null) {
        final credential = await _auth!.signInAnonymously();
        user = credential.user;
      }

      if (user == null) return null;

      // Ensure auth token is ready before Firestore requests.
      await user.getIdToken(true);
      await _auth!.authStateChanges().firstWhere(
            (account) => account?.uid == user!.uid,
          );

      AppLogger.info('Anonymous sign-in complete: ${user.uid}');
      return user.uid;
    } catch (error, stackTrace) {
      AppLogger.error('Anonymous sign-in failed', error, stackTrace);
      return null;
    }
  }

  Future<bool> refreshAuthToken() async {
    final user = _auth?.currentUser;
    if (user == null) return false;

    try {
      await user.getIdToken(true);
      return true;
    } catch (error) {
      AppLogger.warning('Auth token refresh failed: $error');
      return false;
    }
  }
}
