import '../core/constants/game_layout_constants.dart';
import '../models/bead_model.dart';
import '../models/conveyor_model.dart';

class ConveyorEngine {
  ConveyorEngine({
    required this.capacity,
    required this.speed,
  }) : conveyor = ConveyorModel(capacity: capacity, speed: speed, beadIds: []);

  final int capacity;
  final double speed;
  ConveyorModel conveyor;

  bool get isOverflowing => conveyor.isOverflowing;

  List<BeadModel> updatePhysics(double dt, List<BeadModel> beads) {
    final updated = <BeadModel>[];
    final onConveyorIds = <String>[];

    for (final bead in beads) {
      if (bead.isSorted) {
        updated.add(bead);
        continue;
      }

      if (!bead.isOnConveyor) {
        final newVy = bead.velocityY + GameLayoutConstants.gravity * dt;
        var newY = bead.y + newVy * dt;
        var newX = bead.x + bead.velocityX * dt;

        if (newY >= GameLayoutConstants.conveyorY) {
          updated.add(
            bead.copyWith(
              x: newX.clamp(20, GameLayoutConstants.boardWidth - 20),
              y: GameLayoutConstants.conveyorY,
              velocityY: 0,
              velocityX: 0,
              isOnConveyor: true,
            ),
          );
          onConveyorIds.add(bead.id);
        } else {
          updated.add(
            bead.copyWith(x: newX, y: newY, velocityY: newVy),
          );
        }
      } else {
        final newX = bead.x + speed * 60 * dt;
        updated.add(bead.copyWith(x: newX));
        onConveyorIds.add(bead.id);
      }
    }

    final overflow = onConveyorIds.length > capacity;
    conveyor = conveyor.copyWith(
      beadIds: onConveyorIds,
      isOverflowing: overflow,
    );

    return updated;
  }
}
