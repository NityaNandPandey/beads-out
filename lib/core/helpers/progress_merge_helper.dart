import '../../models/player_progress.dart';

class ProgressMergeHelper {
  ProgressMergeHelper._();

  static PlayerProgress merge(PlayerProgress local, PlayerProgress remote) {
    final mergedLevelStars = Map<int, int>.from(local.levelStars);

    for (final entry in remote.levelStars.entries) {
      final existing = mergedLevelStars[entry.key] ?? 0;
      if (entry.value > existing) {
        mergedLevelStars[entry.key] = entry.value;
      }
    }

    return PlayerProgress(
      currentLevel: _max(local.currentLevel, remote.currentLevel),
      highestLevelUnlocked:
          _max(local.highestLevelUnlocked, remote.highestLevelUnlocked),
      totalStars: _max(local.totalStars, remote.totalStars),
      totalScore: _max(local.totalScore, remote.totalScore),
      levelStars: mergedLevelStars,
      coins: _max(local.coins, remote.coins),
      hasCompletedOnboarding:
          local.hasCompletedOnboarding || remote.hasCompletedOnboarding,
    );
  }

  static int _max(int a, int b) => a > b ? a : b;
}
