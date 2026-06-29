import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_theme.dart';
import '../../app/dependency_injection.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class LevelsScreen extends ConsumerWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    final gems = (progress.coins ~/ 10) + 25;

    return PremiumScreenShell(
      title: 'Levels',
      showCurrency: true,
      coins: progress.coins,
      gems: gems,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GlassPanel(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Current: Level ${progress.currentLevel}',
                      style: PremiumDesign.heading(size: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GlassPanel(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Unlocked: ${progress.highestLevelUnlocked}',
                      style: PremiumDesign.heading(size: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: AppConstants.totalLevels,
              itemBuilder: (context, index) {
                final levelNumber = index + 1;
                final isLocked = levelNumber > progress.highestLevelUnlocked;
                final stars = progress.levelStars[levelNumber] ?? 0;
                final isCurrent = levelNumber == progress.currentLevel;
                final accent = AppTheme.rainbow[levelNumber % AppTheme.rainbow.length];

                return ScaleTap(
                  onTap: isLocked
                      ? null
                      : () => context.push(
                            '${RouteConstants.gameplay}?level=$levelNumber',
                          ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isLocked
                          ? null
                          : isCurrent
                              ? const LinearGradient(colors: PremiumDesign.playGradient)
                              : LinearGradient(
                                  colors: [Colors.white, accent.withValues(alpha: 0.35)],
                                ),
                      color: isLocked ? Colors.white24 : null,
                      border: Border.all(
                        color: isLocked ? Colors.white30 : accent,
                        width: 2.5,
                      ),
                      boxShadow: isLocked ? null : PremiumDesign.glow(accent, blur: 10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLocked)
                          const Icon(Icons.lock_rounded, color: Colors.white54, size: 18)
                        else ...[
                          Text(
                            '$levelNumber',
                            style: PremiumDesign.button(
                              size: levelNumber >= 100 ? 11 : 14,
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
                                  color: isCurrent ? Colors.white70 : PremiumDesign.goldenYellow,
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
    );
  }
}
