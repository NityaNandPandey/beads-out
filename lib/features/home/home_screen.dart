import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependency_injection.dart';
import '../../core/constants/route_constants.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(playerProgressProvider);
    final gems = (progress.coins ~/ 10) + 25;
    final lives = 5;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PremiumBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _entrance, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                  .animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  children: [
                    CurrencyBar(
                      coins: progress.coins,
                      gems: gems,
                      lives: lives,
                      onSettings: () => context.push(RouteConstants.settings),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _AvatarOrb(label: '${progress.currentLevel}'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Beads Out',
                                style: PremiumDesign.display(size: 26, color: Colors.white),
                              ),
                              Text(
                                'Level ${progress.currentLevel} • ${progress.totalStars} ★',
                                style: PremiumDesign.body(size: 13, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        ScaleTap(
                          onTap: () => context.push(RouteConstants.leaderboard),
                          child: _QuickIcon(Icons.leaderboard_rounded, PremiumDesign.goldGradient),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    PlayOrb(
                      level: progress.currentLevel,
                      onTap: () => context.push(
                        '${RouteConstants.gameplay}?level=${progress.currentLevel}',
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        MenuOrb(
                          icon: Icons.grid_view_rounded,
                          label: 'Levels',
                          colors: const [PremiumDesign.royalPurple, PremiumDesign.violetDeep],
                          onTap: () => context.push(RouteConstants.levels),
                        ),
                        MenuOrb(
                          icon: Icons.calendar_month_rounded,
                          label: 'Daily',
                          colors: const [PremiumDesign.oceanBlue, PremiumDesign.cyanGlow],
                          onTap: () => context.push(RouteConstants.dailyChallenge),
                          badge: '!',
                        ),
                        MenuOrb(
                          icon: Icons.casino_rounded,
                          label: 'Spin',
                          colors: const [PremiumDesign.sunsetOrange, PremiumDesign.goldenYellow],
                          onTap: () => context.push(RouteConstants.rewards),
                        ),
                        MenuOrb(
                          icon: Icons.storefront_rounded,
                          label: 'Shop',
                          colors: const [PremiumDesign.coralPink, Color(0xFFE11D48)],
                          onTap: () => context.push(RouteConstants.shop),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ScaleTap(
                      onTap: () => context.push(RouteConstants.profile),
                      child: GlassPanel(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.emoji_events_rounded, color: PremiumDesign.goldenYellow, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Season Event — Collect beads, earn rewards!',
                                style: PremiumDesign.body(size: 13, color: PremiumDesign.textDark),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: PremiumDesign.textMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarOrb extends StatelessWidget {
  const _AvatarOrb({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: PremiumDesign.gemGradient),
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: PremiumDesign.glow(PremiumDesign.cyanGlow, blur: 12),
      ),
      alignment: Alignment.center,
      child: Text(label, style: PremiumDesign.button(size: 18)),
    );
  }
}

class _QuickIcon extends StatelessWidget {
  const _QuickIcon(this.icon, this.colors);

  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 2),
        boxShadow: PremiumDesign.glow(colors.first, blur: 10),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
