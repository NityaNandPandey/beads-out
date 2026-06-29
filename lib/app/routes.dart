import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/route_constants.dart';
import '../features/achievements/achievements_screen.dart';
import '../features/daily_challenge/daily_challenge_screen.dart';
import '../features/gameplay/gameplay_screen.dart';
import '../features/home/home_screen.dart';
import '../features/leaderboard/leaderboard_screen.dart';
import '../features/levels/levels_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/rewards/rewards_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shop/shop_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/statistics/statistics_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.splash,
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteConstants.gameplay,
        builder: (context, state) {
          final levelNumber =
              int.tryParse(state.uri.queryParameters['level'] ?? '1') ?? 1;
          return GameplayScreen(levelNumber: levelNumber);
        },
      ),
      GoRoute(
        path: RouteConstants.levels,
        builder: (context, state) => const LevelsScreen(),
      ),
      GoRoute(
        path: RouteConstants.dailyChallenge,
        builder: (context, state) => const DailyChallengeScreen(),
      ),
      GoRoute(
        path: RouteConstants.rewards,
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: RouteConstants.achievements,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: RouteConstants.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteConstants.shop,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: RouteConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteConstants.statistics,
        builder: (context, state) => const StatisticsScreen(),
      ),
    ],
  );
});
