import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_theme.dart';
import '../../app/dependency_injection.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/bead_color.dart';
import '../../core/logger/app_logger.dart';
import '../../shared/widgets/game_ui_components.dart';
import '../../shared/widgets/pastel_background.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await ref.read(audioServiceProvider).init();
    await ref.read(adsServiceProvider).init();

    final firebase = ref.read(firebaseServiceProvider);
    if (firebase.isInitialized) {
      try {
        final uid = await firebase.signInAnonymously();
        if (uid != null) {
          await ref.read(firebaseRepositoryProvider).ensureUserDocuments(uid);
          await ref.read(analyticsServiceProvider).setUserId(uid);
          await Future.wait([
            ref.read(playerProgressProvider.notifier).syncFromCloud(),
            ref.read(settingsProvider.notifier).syncFromCloud(),
          ]);
        }
      } catch (error) {
        AppLogger.warning(
          'Cloud sync skipped — continuing with local save: $error',
        );
      }
    }

    await Future.delayed(AppConstants.splashDuration);
    if (!mounted) return;

    final progress = ref.read(playerProgressProvider);
    if (progress.hasCompletedOnboarding) {
      context.go(RouteConstants.home);
    } else {
      context.go(RouteConstants.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PastelBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _controller.value * 0.08,
                    child: child,
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.goldColor.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.hudGradient,
                        boxShadow: AppTheme.glowShadow(AppTheme.primaryColor),
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                      child: const Icon(Icons.grain, size: 62, color: Colors.white),
                    ),
                    for (var i = 0; i < 6; i++)
                      Transform.rotate(
                        angle: _controller.value * 6.28 + i * 1.05,
                        child: Transform.translate(
                          offset: const Offset(0, -78),
                          child: BeadSphere(
                            color: BeadColor.values[i],
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const GradientTitle(
                text: AppConstants.appName,
                fontSize: 42,
                letterSpacing: 2,
              ),
              const SizedBox(height: 12),
              const Text(
                'Sort the beads, beat the belt!',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 52),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: AppTheme.primaryColor,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
