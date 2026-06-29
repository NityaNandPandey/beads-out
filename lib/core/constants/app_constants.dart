class AppConstants {
  AppConstants._();

  static const String appName = 'Beads Out';
  static const String appVersion = '1.0.0';

  static const int maxConveyorCapacity = 20;
  static const int totalLevels = 600;
  static const int defaultComboWindowMs = 1500;
  static const int baseScorePerBead = 10;

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const String hiveBoxName = 'beads_out_cache';
  static const String progressKey = 'player_progress';
  static const String settingsKey = 'player_settings';
}
