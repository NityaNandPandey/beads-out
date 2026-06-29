import '../core/constants/game_layout_constants.dart';
import '../models/bead_model.dart';
import '../models/container_model.dart';

class SortingLogic {
  SortingLogic({required this.containers});

  List<ContainerModel> containers;

  ({List<BeadModel> beads, int sortedCount}) processBeads(List<BeadModel> beads) {
    var sortedCount = 0;
    final updated = <BeadModel>[];

    for (final bead in beads) {
      if (bead.isSorted || !bead.isOnConveyor) {
        updated.add(bead);
        continue;
      }

      if (bead.x < GameLayoutConstants.sortZoneX) {
        updated.add(bead);
        continue;
      }

      final containerIndex = containers.indexWhere(
        (c) => c.color == bead.color && !c.isFull,
      );

      if (containerIndex == -1) {
        updated.add(bead);
        continue;
      }

      containers[containerIndex] = containers[containerIndex].copyWith(
        currentCount: containers[containerIndex].currentCount + 1,
      );
      updated.add(bead.copyWith(isSorted: true, isOnConveyor: false));
      sortedCount++;
    }

    return (beads: updated, sortedCount: sortedCount);
  }
}
