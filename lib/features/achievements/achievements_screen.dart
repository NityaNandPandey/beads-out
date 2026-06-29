import 'package:flutter/material.dart';

import '../../shared/widgets/feature_placeholder.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Achievements',
      description: 'Track your milestones and unlock badges.',
      icon: Icons.military_tech,
    );
  }
}
