import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_theme.dart';
import '../../app/dependency_injection.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/bead_color.dart';
import '../../models/player_progress.dart';
import '../../shared/widgets/game_ui_components.dart';
import '../../shared/widgets/pastel_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);

    return Scaffold(
      body: PastelBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                _TopBar(onSettings: () => context.push(RouteConstants.settings)),
                const SizedBox(height: 16),
                _StatsRow(progress: progress),
                const Spacer(flex: 2),
                _LogoArea(),
                const SizedBox(height: 12),
                const GradientTitle(text: 'BEADS OUT', fontSize: 32),
                const Spacer(),
                _MainPlayButton(
                  level: progress.currentLevel,
                  onTap: () => context.push(
                    '${RouteConstants.gameplay}?level=${progress.currentLevel}',
                  ),
                ),
                const SizedBox(height: 24),
                _BottomMenu(
                  onLevels: () => context.push(RouteConstants.levels),
                  onDaily: () => context.push(RouteConstants.dailyChallenge),
                  onRewards: () => context.push(RouteConstants.rewards),
                  onShop: () => context.push(RouteConstants.shop),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: AppTheme.hudGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.glowShadow(AppTheme.primaryColor),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
          ),
          child: const Row(
            children: [
              Icon(Icons.grain, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Beads Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.skyColor, AppTheme.primaryColor],
            ),
            boxShadow: AppTheme.glowShadow(AppTheme.skyColor),
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onSettings,
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(Icons.settings_rounded, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.goldColor.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          for (var i = 0; i < 7; i++)
            Transform.translate(
              offset: Offset(cos(i * 0.9) * 58, sin(i * 0.9) * 38),
              child: BeadSphere(
                color: BeadColor.values[i % BeadColor.values.length],
                size: 18 + (i % 3) * 5.0,
              ),
            ),
          const BeadSphere(color: BeadColor.yellow, size: 36),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.progress});

  final PlayerProgress progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ColorfulChip(
            icon: Icons.star_rounded,
            label: '${progress.totalStars}',
            colors: const [AppTheme.goldColor, AppTheme.orangeColor],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ColorfulChip(
            icon: Icons.monetization_on_rounded,
            label: '${progress.coins}',
            colors: const [AppTheme.accentColor, AppTheme.pinkColor],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ColorfulChip(
            icon: Icons.flag_rounded,
            label: 'Lv.${progress.currentLevel}',
            colors: const [AppTheme.primaryColor, AppTheme.skyColor],
          ),
        ),
      ],
    );
  }
}

class _MainPlayButton extends StatelessWidget {
  const _MainPlayButton({required this.level, required this.onTap});

  final int level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.playButtonColor.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            width: 178,
            height: 178,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.playButtonGradient,
              boxShadow: AppTheme.glowShadow(AppTheme.playButtonColor),
              border: Border.all(color: Colors.white, width: 5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 56),
                ),
                const SizedBox(height: 6),
                Text(
                  'LEVEL $level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: 1.2,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomMenu extends StatelessWidget {
  const _BottomMenu({
    required this.onLevels,
    required this.onDaily,
    required this.onRewards,
    required this.onShop,
  });

  final VoidCallback onLevels;
  final VoidCallback onDaily;
  final VoidCallback onRewards;
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MenuItem(
          icon: Icons.grid_view_rounded,
          label: 'Levels',
          colors: const [AppTheme.primaryColor, AppTheme.pinkColor],
          onTap: onLevels,
        ),
        _MenuItem(
          icon: Icons.calendar_today_rounded,
          label: 'Daily',
          colors: const [AppTheme.secondaryColor, AppTheme.skyColor],
          onTap: onDaily,
        ),
        _MenuItem(
          icon: Icons.emoji_events_rounded,
          label: 'Rewards',
          colors: const [AppTheme.goldColor, AppTheme.orangeColor],
          onTap: onRewards,
        ),
        _MenuItem(
          icon: Icons.storefront_rounded,
          label: 'Shop',
          colors: const [AppTheme.playButtonColor, AppTheme.secondaryColor],
          onTap: onShop,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.glowShadow(colors.first),
                border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  children: [
                    Icon(icon, color: Colors.white, size: 26),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
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
