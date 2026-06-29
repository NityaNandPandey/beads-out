import 'package:equatable/equatable.dart';

import '../core/enums/bead_color.dart';
import '../core/enums/level_difficulty.dart';
import 'block_model.dart';
import 'container_model.dart';

class LevelModel extends Equatable {
  const LevelModel({
    required this.id,
    required this.levelNumber,
    required this.difficulty,
    required this.blocks,
    required this.containers,
    required this.conveyorCapacity,
    required this.conveyorSpeed,
    required this.targetScore,
    this.starsRequired = 1,
    this.timeLimitSeconds,
  });

  final String id;
  final int levelNumber;
  final LevelDifficulty difficulty;
  final List<BlockModel> blocks;
  final List<ContainerModel> containers;
  final int conveyorCapacity;
  final double conveyorSpeed;
  final int targetScore;
  final int starsRequired;
  final int? timeLimitSeconds;

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as String,
      levelNumber: json['levelNumber'] as int,
      difficulty: LevelDifficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => LevelDifficulty.easy,
      ),
      blocks: (json['blocks'] as List<dynamic>? ?? [])
          .map((b) => BlockModel(
                id: b['id'] as String,
                color: _parseColor(b['color'] as String),
                row: b['row'] as int,
                col: b['col'] as int,
                beadCount: b['beadCount'] as int,
              ))
          .toList(),
      containers: (json['containers'] as List<dynamic>? ?? [])
          .map((c) => ContainerModel(
                id: c['id'] as String,
                color: _parseColor(c['color'] as String),
                capacity: c['capacity'] as int,
                currentCount: 0,
                position: c['position'] as int? ?? 0,
              ))
          .toList(),
      conveyorCapacity: json['conveyorCapacity'] as int? ?? 20,
      conveyorSpeed: (json['conveyorSpeed'] as num?)?.toDouble() ?? 1.0,
      targetScore: json['targetScore'] as int? ?? 100,
      starsRequired: json['starsRequired'] as int? ?? 1,
      timeLimitSeconds: json['timeLimitSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'levelNumber': levelNumber,
        'difficulty': difficulty.name,
        'blocks': blocks
            .map((b) => {
                  'id': b.id,
                  'color': b.color.name,
                  'row': b.row,
                  'col': b.col,
                  'beadCount': b.beadCount,
                })
            .toList(),
        'containers': containers
            .map((c) => {
                  'id': c.id,
                  'color': c.color.name,
                  'capacity': c.capacity,
                  'position': c.position,
                })
            .toList(),
        'conveyorCapacity': conveyorCapacity,
        'conveyorSpeed': conveyorSpeed,
        'targetScore': targetScore,
        'starsRequired': starsRequired,
        'timeLimitSeconds': timeLimitSeconds,
      };

  static BeadColor _parseColor(String name) {
    return BeadColor.values.firstWhere(
      (c) => c.name == name,
      orElse: () => BeadColor.red,
    );
  }

  @override
  List<Object?> get props => [
        id,
        levelNumber,
        difficulty,
        blocks,
        containers,
        conveyorCapacity,
        conveyorSpeed,
        targetScore,
      ];
}
