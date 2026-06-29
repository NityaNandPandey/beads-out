import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/dependency_injection.dart';
import '../../shared/widgets/feature_placeholder.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);

    return FeaturePlaceholder(
      title: 'Profile',
      description: 'Level ${progress.currentLevel} • ${progress.totalStars} stars • ${progress.totalScore} pts',
      icon: Icons.person,
    );
  }
}
