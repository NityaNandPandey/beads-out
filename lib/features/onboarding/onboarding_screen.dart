import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_theme.dart';
import '../../app/dependency_injection.dart';
import '../../core/constants/route_constants.dart';
import '../../shared/widgets/game_ui_components.dart';
import '../../shared/widgets/pastel_background.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const _steps = [
    (
      icon: Icons.touch_app_rounded,
      colors: [AppTheme.primaryColor, AppTheme.pinkColor],
      title: 'Tap the blocks',
      subtitle: 'Release colorful beads from the blocks above.',
    ),
    (
      icon: Icons.swap_horiz_rounded,
      colors: [AppTheme.secondaryColor, AppTheme.skyColor],
      title: 'Watch the conveyor',
      subtitle: 'Beads roll along the belt toward the boxes.',
    ),
    (
      icon: Icons.inbox_rounded,
      colors: [AppTheme.orangeColor, AppTheme.goldColor],
      title: 'Sort by color',
      subtitle: 'Match each bead before the belt overflows!',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PastelBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const GradientTitle(text: 'How to Play', fontSize: 32),
                const SizedBox(height: 8),
                const Text(
                  'Master the belt in 3 easy steps',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 28),
                for (var i = 0; i < _steps.length; i++) ...[
                  _TutorialStep(
                    step: i + 1,
                    icon: _steps[i].icon,
                    colors: _steps[i].colors,
                    title: _steps[i].title,
                    subtitle: _steps[i].subtitle,
                  ),
                  if (i < _steps.length - 1) const SizedBox(height: 16),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: GameButton3D(
                    label: 'Let\'s Play!',
                    icon: Icons.play_arrow_rounded,
                    onTap: () async {
                      await ref
                          .read(playerProgressProvider.notifier)
                          .completeOnboarding();
                      if (context.mounted) context.go(RouteConstants.home);
                    },
                    expand: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialStep extends StatelessWidget {
  const _TutorialStep({
    required this.step,
    required this.icon,
    required this.colors,
    required this.title,
    required this.subtitle,
  });

  final int step;
  final IconData icon;
  final List<Color> colors;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(colors: colors),
        boxShadow: AppTheme.glowShadow(colors.first),
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.glowShadow(colors.first),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$step. $title',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
