import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/dependency_injection.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    final gems = (progress.coins ~/ 10) + 25;

    return PremiumScreenShell(
      title: 'Profile',
      showCurrency: true,
      coins: progress.coins,
      gems: gems,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassPanel(
            rainbowBorder: true,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: PremiumDesign.gemGradient),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: PremiumDesign.glow(PremiumDesign.cyanGlow),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${progress.currentLevel}',
                    style: PremiumDesign.display(size: 32, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Beads Master', style: PremiumDesign.heading(size: 22)),
                Text(
                  'Level ${progress.currentLevel} player',
                  style: PremiumDesign.body(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _StatCard(
            label: 'Total Stars',
            value: '${progress.totalStars}',
            colors: PremiumDesign.goldGradient,
            icon: Icons.star_rounded,
          ),
          _StatCard(
            label: 'High Score',
            value: '${progress.totalScore}',
            colors: const [PremiumDesign.oceanBlue, PremiumDesign.cyanGlow],
            icon: Icons.bolt_rounded,
          ),
          _StatCard(
            label: 'Levels Unlocked',
            value: '${progress.highestLevelUnlocked}',
            colors: PremiumDesign.playGradient,
            icon: Icons.flag_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.colors,
    required this.icon,
  });

  final String label;
  final String value;
  final List<Color> colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: colors),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: PremiumDesign.heading(size: 15))),
            Text(value, style: PremiumDesign.display(size: 22)),
          ],
        ),
      ),
    );
  }
}
