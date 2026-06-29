import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependency_injection.dart';
import '../../core/constants/route_constants.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const _steps = [
    (icon: Icons.touch_app_rounded, colors: [PremiumDesign.royalPurple, PremiumDesign.coralPink], title: 'Tap blocks', subtitle: 'Release colorful beads from jars above.'),
    (icon: Icons.sync_alt_rounded, colors: [PremiumDesign.oceanBlue, PremiumDesign.cyanGlow], title: 'Watch the belt', subtitle: 'Beads travel along the conveyor automatically.'),
    (icon: Icons.inbox_rounded, colors: [PremiumDesign.sunsetOrange, PremiumDesign.goldenYellow], title: 'Sort by color', subtitle: 'Fill the matching trays before the belt overflows!'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumScreenShell(
      title: 'How to Play',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Master the belt\nin 3 easy steps',
              textAlign: TextAlign.center,
              style: PremiumDesign.display(size: 26, color: Colors.white),
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < _steps.length; i++) ...[
              GlassPanel(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(colors: _steps[i].colors),
                        boxShadow: PremiumDesign.glow(_steps[i].colors.first, blur: 10),
                      ),
                      child: Icon(_steps[i].icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${i + 1}. ${_steps[i].title}', style: PremiumDesign.heading(size: 16)),
                          Text(_steps[i].subtitle, style: PremiumDesign.body(size: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (i < _steps.length - 1) const SizedBox(height: 12),
            ],
            const Spacer(),
            PremiumButton(
              label: 'Let\'s Play!',
              icon: Icons.play_arrow_rounded,
              onTap: () async {
                await ref.read(playerProgressProvider.notifier).completeOnboarding();
                if (context.mounted) context.go(RouteConstants.home);
              },
              expand: true,
            ),
          ],
        ),
      ),
    );
  }
}
