import '../core/constants/app_constants.dart';
import '../models/player_progress.dart';
import '../services/save_service.dart';

class ProgressRepository {
  ProgressRepository(this._saveService);

  final SaveService _saveService;
  PlayerProgress _progress = const PlayerProgress();

  PlayerProgress get progress => _progress;

  Future<void> load() async {
    final data = await _saveService.getMap(AppConstants.progressKey);
    if (data != null) {
      _progress = PlayerProgress.fromJson(data);
    }
  }

  Future<void> save(PlayerProgress progress) async {
    _progress = progress;
    await _saveService.saveMap(AppConstants.progressKey, progress.toJson());
  }

  Future<void> completeLevel(int levelNumber, int stars, int score) async {
    final updatedStars = Map<int, int>.from(_progress.levelStars);
    final existingStars = updatedStars[levelNumber] ?? 0;
    if (stars > existingStars) {
      updatedStars[levelNumber] = stars;
    }

    _progress = _progress.copyWith(
      currentLevel: levelNumber + 1 > AppConstants.totalLevels
          ? AppConstants.totalLevels
          : levelNumber + 1 > _progress.currentLevel
              ? levelNumber + 1
              : _progress.currentLevel,
      highestLevelUnlocked: levelNumber + 1 > _progress.highestLevelUnlocked
          ? (levelNumber + 1).clamp(1, AppConstants.totalLevels)
          : _progress.highestLevelUnlocked,
      totalStars: _progress.totalStars + stars - existingStars,
      totalScore: _progress.totalScore + score,
      levelStars: updatedStars,
      coins: _progress.coins + (stars * 5),
    );
    await save(_progress);
  }
}
