import 'dart:math';

import 'package:uuid/uuid.dart';

import '../core/constants/game_layout_constants.dart';
import '../models/bead_model.dart';
import '../models/block_model.dart';

class BeadSpawner {
  BeadSpawner() : _uuid = const Uuid(), _random = Random();

  final Uuid _uuid;
  final Random _random;

  List<BeadModel> spawnFromBlock(BlockModel block, double spawnX) {
    return List.generate(block.beadCount, (i) {
      final spread =
          (i - block.beadCount / 2) * GameLayoutConstants.fallSpread;
      return BeadModel(
        id: _uuid.v4(),
        color: block.color,
        x: spawnX + spread + _random.nextDouble() * 6 - 3,
        y: 40 + block.row * 8,
        velocityX: _random.nextDouble() * 20 - 10,
        velocityY: 40 + _random.nextDouble() * 20,
      );
    });
  }
}
