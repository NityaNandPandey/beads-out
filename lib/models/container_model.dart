import 'package:equatable/equatable.dart';

import '../core/enums/bead_color.dart';

class ContainerModel extends Equatable {
  const ContainerModel({
    required this.id,
    required this.color,
    required this.capacity,
    required this.currentCount,
    this.position = 0,
  });

  final String id;
  final BeadColor color;
  final int capacity;
  final int currentCount;
  final int position;

  bool get isFull => currentCount >= capacity;
  double get fillPercentage => currentCount / capacity;

  ContainerModel copyWith({
    String? id,
    BeadColor? color,
    int? capacity,
    int? currentCount,
    int? position,
  }) {
    return ContainerModel(
      id: id ?? this.id,
      color: color ?? this.color,
      capacity: capacity ?? this.capacity,
      currentCount: currentCount ?? this.currentCount,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [id, color, capacity, currentCount, position];
}
