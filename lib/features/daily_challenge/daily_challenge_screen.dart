import 'package:flutter/material.dart';

import '../../shared/widgets/feature_placeholder.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Daily Challenge',
      description: 'Complete today\'s unique puzzle for bonus rewards.',
      icon: Icons.calendar_today,
    );
  }
}
