enum LevelDifficulty {
  easy,
  medium,
  hard,
  expert,
}

extension LevelDifficultyExtension on LevelDifficulty {
  String get displayName {
    return switch (this) {
      LevelDifficulty.easy => 'Easy',
      LevelDifficulty.medium => 'Medium',
      LevelDifficulty.hard => 'Hard',
      LevelDifficulty.expert => 'Expert',
    };
  }

  double get speedMultiplier {
    return switch (this) {
      LevelDifficulty.easy => 0.8,
      LevelDifficulty.medium => 1.0,
      LevelDifficulty.hard => 1.3,
      LevelDifficulty.expert => 1.6,
    };
  }
}
