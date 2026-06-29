import 'package:equatable/equatable.dart';

class PlayerProgress extends Equatable {
  const PlayerProgress({
    this.currentLevel = 1,
    this.highestLevelUnlocked = 1,
    this.totalStars = 0,
    this.totalScore = 0,
    this.levelStars = const {},
    this.coins = 0,
    this.hasCompletedOnboarding = false,
  });

  final int currentLevel;
  final int highestLevelUnlocked;
  final int totalStars;
  final int totalScore;
  final Map<int, int> levelStars;
  final int coins;
  final bool hasCompletedOnboarding;

  PlayerProgress copyWith({
    int? currentLevel,
    int? highestLevelUnlocked,
    int? totalStars,
    int? totalScore,
    Map<int, int>? levelStars,
    int? coins,
    bool? hasCompletedOnboarding,
  }) {
    return PlayerProgress(
      currentLevel: currentLevel ?? this.currentLevel,
      highestLevelUnlocked: highestLevelUnlocked ?? this.highestLevelUnlocked,
      totalStars: totalStars ?? this.totalStars,
      totalScore: totalScore ?? this.totalScore,
      levelStars: levelStars ?? this.levelStars,
      coins: coins ?? this.coins,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      currentLevel: json['currentLevel'] as int? ?? 1,
      highestLevelUnlocked: json['highestLevelUnlocked'] as int? ?? 1,
      totalStars: json['totalStars'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      levelStars: Map<int, int>.from(
        (json['levelStars'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(int.parse(k), v as int)),
      ),
      coins: json['coins'] as int? ?? 0,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentLevel': currentLevel,
        'highestLevelUnlocked': highestLevelUnlocked,
        'totalStars': totalStars,
        'totalScore': totalScore,
        'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
        'coins': coins,
        'hasCompletedOnboarding': hasCompletedOnboarding,
      };

  @override
  List<Object?> get props => [
        currentLevel,
        highestLevelUnlocked,
        totalStars,
        totalScore,
        levelStars,
        coins,
        hasCompletedOnboarding,
      ];
}
