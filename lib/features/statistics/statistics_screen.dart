import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/dependency_injection.dart';
import '../../shared/widgets/feature_placeholder.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);

    return FeaturePlaceholder(
      title: 'Statistics',
      description: 'Total score: ${progress.totalScore}\nLevels completed: ${progress.levelStars.length}',
      icon: Icons.bar_chart,
    );
  }
}
