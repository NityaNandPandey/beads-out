import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.levelNumber,
    required this.score,
    required this.sortedBeads,
    required this.totalBeads,
    required this.conveyorFill,
    this.onPause,
    this.onBack,
  });

  final int levelNumber;
  final int score;
  final int sortedBeads;
  final int totalBeads;
  final double conveyorFill;
  final VoidCallback? onPause;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppTheme.panelBorderGradient,
        boxShadow: AppTheme.glowShadow(AppTheme.primaryColor),
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppTheme.hudGradient,
          borderRadius: BorderRadius.circular(21),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _HudIconButton(icon: Icons.arrow_back_ios_new, onTap: onBack),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'LEVEL $levelNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '✨ Sort all the beads!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _HudIconButton(icon: Icons.pause_rounded, onTap: onPause),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatPill(
                  icon: Icons.grain,
                  label: '$sortedBeads/$totalBeads',
                  colors: const [AppTheme.secondaryColor, AppTheme.skyColor],
                ),
                const SizedBox(width: 8),
                _StatPill(
                  icon: Icons.star_rounded,
                  label: '$score',
                  colors: const [AppTheme.goldColor, AppTheme.orangeColor],
                ),
                const Spacer(),
                SizedBox(
                  width: 88,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Belt',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: conveyorFill.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: conveyorFill > 0.8
                                      ? [AppTheme.warningColor, AppTheme.dangerColor]
                                      : conveyorFill > 0.5
                                          ? [AppTheme.goldColor, AppTheme.warningColor]
                                          : [AppTheme.secondaryColor, AppTheme.playButtonColor],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HudIconButton extends StatelessWidget {
  const _HudIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
