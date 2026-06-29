import '../core/logger/app_logger.dart';

class VibrationService {
  VibrationService();

  bool _enabled = true;

  Future<void> init() async {
    AppLogger.info('VibrationService initialized');
  }

  Future<void> lightImpact() async {
    if (!_enabled) return;
    AppLogger.debug('Light haptic feedback');
  }

  Future<void> mediumImpact() async {
    if (!_enabled) return;
    AppLogger.debug('Medium haptic feedback');
  }

  void setEnabled(bool enabled) => _enabled = enabled;
}
