import '../core/constants/app_constants.dart';
import '../core/enums/bead_color.dart';
import '../core/enums/level_difficulty.dart';
import '../models/block_model.dart';
import '../models/container_model.dart';
import '../models/level_model.dart';

class GameRepository {
  GameRepository();

  Future<List<LevelModel>> getLevels() async {
    return List.generate(
      AppConstants.totalLevels,
      (index) => _createDefaultLevel(index + 1),
    );
  }

  Future<LevelModel?> getLevel(int levelNumber) async {
    if (levelNumber < 1 || levelNumber > AppConstants.totalLevels) {
      return null;
    }
    return _createDefaultLevel(levelNumber);
  }

  LevelModel _createDefaultLevel(int levelNumber) {
    final colorCount = (2 + (levelNumber ~/ 40)).clamp(2, BeadColor.values.length);
    final colors = BeadColor.values.take(colorCount).toList();
    final blockCount = (4 + levelNumber ~/ 8).clamp(4, 16);
    final beadsPerBlock = (3 + (levelNumber % 4)).clamp(3, 6);

    final totalBeads = blockCount * beadsPerBlock;
    final difficulty = _difficultyForLevel(levelNumber);

    return LevelModel(
      id: 'level_${levelNumber.toString().padLeft(3, '0')}',
      levelNumber: levelNumber,
      difficulty: difficulty,
      blocks: List.generate(
        blockCount,
        (i) => BlockModel(
          id: 'block_$i',
          color: colors[i % colors.length],
          row: i ~/ 4,
          col: i % 4,
          beadCount: beadsPerBlock,
        ),
      ),
      containers: colors
          .map(
            (c) => ContainerModel(
              id: 'container_${c.name}',
              color: c,
              capacity: (totalBeads / colors.length).ceil() + 2,
              currentCount: 0,
            ),
          )
          .toList(),
      conveyorCapacity: (14 + levelNumber ~/ 10).clamp(12, AppConstants.maxConveyorCapacity),
      conveyorSpeed: difficulty.speedMultiplier * (1.1 + levelNumber * 0.025),
      targetScore: totalBeads * AppConstants.baseScorePerBead,
    );
  }

  LevelDifficulty _difficultyForLevel(int levelNumber) {
    if (levelNumber <= 50) return LevelDifficulty.easy;
    if (levelNumber <= 200) return LevelDifficulty.medium;
    if (levelNumber <= 450) return LevelDifficulty.hard;
    return LevelDifficulty.expert;
  }
}
