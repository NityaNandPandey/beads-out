import '../core/logger/app_logger.dart';

class NotificationService {
  NotificationService();

  Future<void> init() async {
    AppLogger.info('NotificationService initialized');
  }

  Future<void> scheduleDailyReminder() async {
    AppLogger.debug('Daily reminder scheduled');
  }
}
