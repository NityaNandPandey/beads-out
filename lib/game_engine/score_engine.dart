class ScoreEngine {
  ScoreEngine({required this.targetScore});

  final int targetScore;
  int score = 0;

  bool get isTargetReached => score >= targetScore;

  int addScore(int basePoints, int comboMultiplier) {
    final multiplier = 1 + (comboMultiplier * 0.1);
    final points = (basePoints * multiplier).round();
    score += points;
    return points;
  }
}
