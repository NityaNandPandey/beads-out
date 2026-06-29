import 'package:flutter/services.dart';

import '../core/logger/app_logger.dart';

enum FeedbackType { tap, success, error, heavy }

/// Centralized haptic + sound feedback for premium interactions.
class FeedbackService {
  FeedbackService();

  bool _hapticsEnabled = true;
  bool _sfxEnabled = true;

  void syncSettings({required bool haptics, required bool sfx}) {
    _hapticsEnabled = haptics;
    _sfxEnabled = sfx;
  }

  Future<void> play(FeedbackType type) async {
    if (_hapticsEnabled) {
      switch (type) {
        case FeedbackType.tap:
          await HapticFeedback.lightImpact();
        case FeedbackType.success:
          await HapticFeedback.mediumImpact();
        case FeedbackType.error:
          await HapticFeedback.heavyImpact();
        case FeedbackType.heavy:
          await HapticFeedback.heavyImpact();
      }
    }

    if (_sfxEnabled) {
      try {
        switch (type) {
          case FeedbackType.tap:
            await SystemSound.play(SystemSoundType.click);
          case FeedbackType.success:
          case FeedbackType.heavy:
            await SystemSound.play(SystemSoundType.alert);
          case FeedbackType.error:
            await SystemSound.play(SystemSoundType.click);
        }
      } catch (error) {
        AppLogger.debug('System sound unavailable: $error');
      }
    }
  }

  Future<void> tap() => play(FeedbackType.tap);
  Future<void> success() => play(FeedbackType.success);
  Future<void> celebrate() => play(FeedbackType.heavy);
}
