import '../../core/enums/bead_color.dart';

/// Visual/audio burst emitted when a bead is sorted into a tray.
class SortEvent {
  const SortEvent({
    required this.x,
    required this.y,
    required this.color,
  });

  final double x;
  final double y;
  final BeadColor color;
}
