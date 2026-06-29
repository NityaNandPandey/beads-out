import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/dependency_injection.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../core/logger/app_logger.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logo;
  late AnimationController _progress;
  double _loadProgress = 0;

  @override
  void initState() {
    super.initState();
    _logo = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _progress = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _initialize();
  }

  @override
  void dispose() {
    _logo.dispose();
    _progress.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _progress.forward();
    _progress.addListener(() => setState(() => _loadProgress = _progress.value));

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
        AppLogger.warning('Cloud sync skipped: $error');
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
      body: PremiumBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _logo,
                builder: (context, child) => Transform.scale(
                  scale: 1 + _logo.value * 0.06,
                  child: child,
                ),
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: PremiumDesign.playGradient,
                    ),
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: PremiumDesign.glow(PremiumDesign.mintGreen, blur: 30),
                  ),
                  child: const Icon(Icons.grain_rounded, color: Colors.white, size: 64),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                AppConstants.appName.toUpperCase(),
                style: PremiumDesign.display(size: 38, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading your puzzle world…',
                style: PremiumDesign.body(size: 15, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: _loadProgress,
                    minHeight: 10,
                    backgroundColor: Colors.white24,
                    color: PremiumDesign.goldenYellow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
