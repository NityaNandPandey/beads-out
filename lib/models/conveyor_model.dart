import 'package:equatable/equatable.dart';

class ConveyorModel extends Equatable {
  const ConveyorModel({
    required this.capacity,
    required this.speed,
    required this.beadIds,
    this.isOverflowing = false,
  });

  final int capacity;
  final double speed;
  final List<String> beadIds;
  final bool isOverflowing;

  int get currentCount => beadIds.length;
  double get fillPercentage => beadIds.length / capacity;

  ConveyorModel copyWith({
    int? capacity,
    double? speed,
    List<String>? beadIds,
    bool? isOverflowing,
  }) {
    return ConveyorModel(
      capacity: capacity ?? this.capacity,
      speed: speed ?? this.speed,
      beadIds: beadIds ?? this.beadIds,
      isOverflowing: isOverflowing ?? this.isOverflowing,
    );
  }

  @override
  List<Object?> get props => [capacity, speed, beadIds, isOverflowing];
}
