import 'package:flutter/services.dart';

import '../core/logger/app_logger.dart';

class VibrationService {
  VibrationService();

  bool _enabled = true;

  Future<void> init() async {
    AppLogger.info('VibrationService initialized');
  }

  Future<void> lightImpact() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> mediumImpact() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  void setEnabled(bool enabled) => _enabled = enabled;
}
