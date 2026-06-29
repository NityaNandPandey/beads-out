import 'package:equatable/equatable.dart';

import '../core/enums/bead_color.dart';

class BeadModel extends Equatable {
  const BeadModel({
    required this.id,
    required this.color,
    required this.x,
    required this.y,
    this.velocityX = 0,
    this.velocityY = 0,
    this.isOnConveyor = false,
    this.isSorted = false,
  });

  final String id;
  final BeadColor color;
  final double x;
  final double y;
  final double velocityX;
  final double velocityY;
  final bool isOnConveyor;
  final bool isSorted;

  BeadModel copyWith({
    String? id,
    BeadColor? color,
    double? x,
    double? y,
    double? velocityX,
    double? velocityY,
    bool? isOnConveyor,
    bool? isSorted,
  }) {
    return BeadModel(
      id: id ?? this.id,
      color: color ?? this.color,
      x: x ?? this.x,
      y: y ?? this.y,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
      isOnConveyor: isOnConveyor ?? this.isOnConveyor,
      isSorted: isSorted ?? this.isSorted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        color,
        x,
        y,
        velocityX,
        velocityY,
        isOnConveyor,
        isSorted,
      ];
}
