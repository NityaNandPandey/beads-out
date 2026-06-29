class ComboEngine {
  ComboEngine({required this.windowMs});

  final int windowMs;
  int currentCombo = 0;
  DateTime? _lastSortTime;

  int registerSort() {
    final now = DateTime.now();
    if (_lastSortTime != null &&
        now.difference(_lastSortTime!).inMilliseconds <= windowMs) {
      currentCombo++;
    } else {
      currentCombo = 1;
    }
    _lastSortTime = now;
    return currentCombo;
  }

  void reset() {
    currentCombo = 0;
    _lastSortTime = null;
  }
}
