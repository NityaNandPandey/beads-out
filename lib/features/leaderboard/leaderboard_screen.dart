import 'package:flutter/material.dart';

import '../../shared/widgets/feature_placeholder.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Leaderboard',
      description: 'Compete with players worldwide.',
      icon: Icons.leaderboard,
    );
  }
}
