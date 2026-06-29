import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_theme.dart';
import '../../app/dependency_injection.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../shared/widgets/game_ui_components.dart';
import '../../shared/widgets/pastel_background.dart';

class LevelsScreen extends ConsumerWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Levels (${AppConstants.totalLevels})'),
      ),
      body: PastelBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _ProgressChip(
                    icon: Icons.flag_rounded,
                    label: 'Current: ${progress.currentLevel}',
                    colors: const [AppTheme.playButtonLight, AppTheme.playButtonDark],
                  ),
                  const SizedBox(width: 8),
                  _ProgressChip(
                    icon: Icons.lock_open_rounded,
                    label: 'Unlocked: ${progress.highestLevelUnlocked}',
                    colors: const [AppTheme.primaryColor, AppTheme.skyColor],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: AppConstants.totalLevels,
                itemBuilder: (context, index) {
                  final levelNumber = index + 1;
                  final isLocked = levelNumber > progress.highestLevelUnlocked;
                  final stars = progress.levelStars[levelNumber] ?? 0;
                  final isCurrent = levelNumber == progress.currentLevel;

                  return GestureDetector(
                    onTap: isLocked
                        ? null
                        : () => context.push(
                              '${RouteConstants.gameplay}?level=$levelNumber',
                            ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isLocked
                            ? null
                            : isCurrent
                                ? AppTheme.playButtonGradient
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      AppTheme.rainbow[levelNumber % AppTheme.rainbow.length]
                                          .withValues(alpha: 0.25),
                                    ],
                                  ),
                        color: isLocked ? Colors.grey.shade300 : null,
                        border: Border.all(
                          color: isLocked
                              ? Colors.grey.shade400
                              : isCurrent
                                  ? AppTheme.playButtonDark
                                  : AppTheme.rainbow[levelNumber % AppTheme.rainbow.length],
                          width: 2.5,
                        ),
                        boxShadow: isLocked
                            ? null
                            : AppTheme.glowShadow(
                                isCurrent
                                    ? AppTheme.playButtonColor
                                    : AppTheme.rainbow[levelNumber % AppTheme.rainbow.length],
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLocked)
                            Icon(
                              Icons.lock_rounded,
                              size: 16,
                              color: Colors.grey.shade500,
                            )
                          else ...[
                            Text(
                              '$levelNumber',
                              style: TextStyle(
                                fontSize: levelNumber >= 100 ? 11 : 14,
                                fontWeight: FontWeight.w900,
                                color: isCurrent ? Colors.white : AppTheme.textPrimary,
                              ),
                            ),
                            if (stars > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  stars.clamp(0, 3),
                                  (_) => Icon(
                                    Icons.star_rounded,
                                    size: 8,
                                    color: isCurrent ? Colors.white70 : AppTheme.goldColor,
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ColorfulChip(icon: icon, label: label, colors: colors),
    );
  }
}
