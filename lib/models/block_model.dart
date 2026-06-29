import 'package:equatable/equatable.dart';

import '../core/enums/bead_color.dart';

class BlockModel extends Equatable {
  const BlockModel({
    required this.id,
    required this.color,
    required this.row,
    required this.col,
    required this.beadCount,
    this.isBroken = false,
    this.health = 1,
  });

  final String id;
  final BeadColor color;
  final int row;
  final int col;
  final int beadCount;
  final bool isBroken;
  final int health;

  BlockModel copyWith({
    String? id,
    BeadColor? color,
    int? row,
    int? col,
    int? beadCount,
    bool? isBroken,
    int? health,
  }) {
    return BlockModel(
      id: id ?? this.id,
      color: color ?? this.color,
      row: row ?? this.row,
      col: col ?? this.col,
      beadCount: beadCount ?? this.beadCount,
      isBroken: isBroken ?? this.isBroken,
      health: health ?? this.health,
    );
  }

  @override
  List<Object?> get props => [id, color, row, col, beadCount, isBroken, health];
}
