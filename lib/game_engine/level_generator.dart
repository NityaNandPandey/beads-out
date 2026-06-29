import '../core/enums/level_difficulty.dart';
import '../models/level_model.dart';
import '../repositories/game_repository.dart';

class LevelGenerator {
  LevelGenerator(this._gameRepository);

  final GameRepository _gameRepository;

  Future<LevelModel> generateLevel(int levelNumber) async {
    final level = await _gameRepository.getLevel(levelNumber);
    if (level != null) return level;
    return (await _gameRepository.getLevel(1))!;
  }

  Future<List<LevelModel>> getAllLevels() => _gameRepository.getLevels();
}

class DifficultyManager {
  static LevelDifficulty getDifficultyForLevel(int levelNumber) {
    if (levelNumber <= 50) return LevelDifficulty.easy;
    if (levelNumber <= 200) return LevelDifficulty.medium;
    if (levelNumber <= 450) return LevelDifficulty.hard;
    return LevelDifficulty.expert;
  }

  static double getSpeedMultiplier(int levelNumber) {
    return getDifficultyForLevel(levelNumber).speedMultiplier;
  }
}
