import '../core/constants/app_constants.dart';
import '../core/enums/game_state.dart';
import '../models/bead_model.dart';
import '../models/block_model.dart';
import '../models/conveyor_model.dart';
import '../models/container_model.dart';
import '../models/level_model.dart';
import 'bead_spawner.dart';
import 'combo_engine.dart';
import 'conveyor_engine.dart';
import 'score_engine.dart';
import 'sorting_logic.dart';

class GameEngine {
  GameEngine({required this.level});

  final LevelModel level;

  GameState state = GameState.idle;
  int score = 0;
  int combo = 0;
  int totalBeads = 0;
  int sortedBeads = 0;

  late ConveyorEngine conveyorEngine;
  late BeadSpawner beadSpawner;
  late SortingLogic sortingLogic;
  late ScoreEngine scoreEngine;
  late ComboEngine comboEngine;

  List<BlockModel> blocks = [];
  List<BeadModel> beads = [];
  List<ContainerModel> containers = [];
  ConveyorModel? conveyor;

  void init() {
    blocks = level.blocks.map((b) => b.copyWith()).toList();
    containers = level.containers.map((c) => c.copyWith()).toList();
    beads = [];
    score = 0;
    combo = 0;
    sortedBeads = 0;
    totalBeads = blocks.fold(0, (sum, b) => sum + b.beadCount);
    state = GameState.playing;

    conveyorEngine = ConveyorEngine(
      capacity: level.conveyorCapacity,
      speed: level.conveyorSpeed,
    );
    beadSpawner = BeadSpawner();
    sortingLogic = SortingLogic(containers: containers);
    scoreEngine = ScoreEngine(targetScore: level.targetScore);
    comboEngine = ComboEngine(
      windowMs: AppConstants.defaultComboWindowMs,
    );
    conveyor = conveyorEngine.conveyor;
  }

  void tapBlock(String blockId, double spawnX) {
    if (state != GameState.playing) return;

    final blockIndex = blocks.indexWhere((b) => b.id == blockId);
    if (blockIndex == -1 || blocks[blockIndex].isBroken) return;

    final block = blocks[blockIndex];
    blocks[blockIndex] = block.copyWith(isBroken: true);
    beads.addAll(beadSpawner.spawnFromBlock(block, spawnX));
  }

  void update(double dt) {
    if (state != GameState.playing) return;

    beads = conveyorEngine.updatePhysics(dt, beads);
    conveyor = conveyorEngine.conveyor;

    final result = sortingLogic.processBeads(beads);
    beads = result.beads;
    containers = sortingLogic.containers;

    for (var i = 0; i < result.sortedCount; i++) {
      scoreEngine.addScore(
        AppConstants.baseScorePerBead,
        comboEngine.currentCombo,
      );
      combo = comboEngine.registerSort();
      sortedBeads++;
    }
    score = scoreEngine.score;

    if (conveyorEngine.isOverflowing) {
      state = GameState.gameOver;
    } else if (_isLevelComplete()) {
      state = GameState.levelComplete;
    }
  }

  bool _isLevelComplete() {
    return blocks.every((b) => b.isBroken) &&
        sortedBeads >= totalBeads &&
        beads.every((b) => b.isSorted);
  }

  int calculateStars() {
    if (conveyorEngine.isOverflowing) return 0;
    final ratio = totalBeads == 0 ? 0.0 : sortedBeads / totalBeads;
    if (ratio >= 1.0 && combo >= 5) return 3;
    if (ratio >= 1.0) return 2;
    if (ratio >= 0.8) return 1;
    return 0;
  }

  double get conveyorFill =>
      (conveyor?.beadIds.length ?? 0) / (conveyor?.capacity ?? 1);

  void pause() {
    if (state == GameState.playing) state = GameState.paused;
  }

  void resume() {
    if (state == GameState.paused) state = GameState.playing;
  }
}
