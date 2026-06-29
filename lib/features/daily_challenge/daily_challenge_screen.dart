import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_constants.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_dialog.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  bool _showReward = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PremiumScreenShell(
          title: 'Daily Challenge',
          showCurrency: true,
          coins: 240,
          gems: 30,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GlassPanel(
                  rainbowBorder: true,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.calendar_month_rounded, size: 56, color: PremiumDesign.cyanGlow),
                      const SizedBox(height: 12),
                      Text('Today\'s Puzzle', style: PremiumDesign.display(size: 24)),
                      const SizedBox(height: 8),
                      Text(
                        'Beat the special level for bonus coins & gems.',
                        style: PremiumDesign.body(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PremiumButton(
                  label: 'Play Daily Level',
                  icon: Icons.play_arrow_rounded,
                  onTap: () => context.push('${RouteConstants.gameplay}?level=1'),
                  expand: true,
                ),
                const SizedBox(height: 12),
                PremiumButton(
                  label: 'Claim Daily Reward',
                  onTap: () => setState(() => _showReward = true),
                  expand: true,
                  colors: PremiumDesign.goldGradient,
                ),
              ],
            ),
          ),
        ),
        if (_showReward)
          PremiumOverlay(
            child: PremiumDialog(
              title: 'Daily Reward!',
              subtitle: '+150 coins added to your balance.',
              icon: Icons.redeem_rounded,
              iconColors: PremiumDesign.goldGradient,
              showConfetti: true,
              collectCoins: true,
              primaryLabel: 'Awesome!',
              onPrimary: () => setState(() => _showReward = false),
            ),
          ),
      ],
    );
  }
}
