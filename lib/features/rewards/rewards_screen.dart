import 'package:flutter/material.dart';

import '../../shared/widgets/feature_placeholder.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Rewards',
      description: 'Collect coins, stars, and special items.',
      icon: Icons.emoji_events,
    );
  }
}
