import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../core/logger/app_logger.dart';
import 'firebase_service.dart';

class AnalyticsService {
  AnalyticsService(this._firebaseService);

  final FirebaseService _firebaseService;
  FirebaseAnalytics? _analytics;
  bool _enabled = false;

  Future<void> init() async {
    if (!_firebaseService.isInitialized) {
      AppLogger.info('AnalyticsService running in offline mode');
      return;
    }

    _analytics = FirebaseAnalytics.instance;
    _enabled = !kDebugMode;

    try {
      await _analytics!.setAnalyticsCollectionEnabled(_enabled);
    } catch (error) {
      AppLogger.warning('Analytics collection toggle failed: $error');
      _enabled = false;
    }

    AppLogger.info(
      _enabled
          ? 'AnalyticsService initialized'
          : 'AnalyticsService disabled in debug builds',
    );
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_enabled) {
      AppLogger.debug('Analytics event (disabled): $name');
      return;
    }

    final analytics = _analytics;
    if (analytics == null) {
      AppLogger.debug('Analytics event (offline): $name');
      return;
    }

    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (error) {
      AppLogger.warning('Analytics event failed: $name — $error');
    }
  }

  Future<void> logLevelStart(int levelNumber) async {
    await logEvent('level_start', parameters: {'level': levelNumber});
  }

  Future<void> logLevelComplete(int levelNumber, int score, int stars) async {
    await logEvent('level_complete', parameters: {
      'level': levelNumber,
      'score': score,
      'stars': stars,
    });
  }

  Future<void> setUserId(String? userId) async {
    if (!_enabled) return;

    try {
      await _analytics?.setUserId(id: userId);
    } catch (error) {
      AppLogger.warning('Analytics setUserId failed: $error');
    }
  }
}
