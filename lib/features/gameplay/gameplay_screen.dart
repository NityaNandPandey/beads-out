import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_theme.dart';
import '../../app/dependency_injection.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/game_state.dart';
import '../../game_engine/engine.dart';
import '../../models/level_model.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_dialog.dart';
import '../../shared/widgets/premium/premium_widgets.dart';
import '../../shared/widgets/game_hud.dart';
import 'widgets/game_board.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key, required this.levelNumber});

  final int levelNumber;

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  LevelModel? _level;
  GameEngine? _engine;
  bool _loading = true;
  bool _completionHandled = false;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  Future<void> _loadLevel() async {
    setState(() => _loading = true);
    final level = await ref.read(gameRepositoryProvider).getLevel(widget.levelNumber);
    if (level == null || !mounted) return;

    setState(() {
      _level = level;
      _engine = GameEngine(level: level)..init();
      _loading = false;
      _completionHandled = false;
    });

    ref.read(analyticsServiceProvider).logLevelStart(widget.levelNumber);
  }

  Future<void> _handleLevelComplete() async {
    if (_completionHandled || _engine == null) return;
    _completionHandled = true;

    final stars = _engine!.calculateStars();
    await ref.read(playerProgressProvider.notifier).completeLevel(
          widget.levelNumber,
          stars,
          _engine!.score,
        );
    ref.read(analyticsServiceProvider).logLevelComplete(
          widget.levelNumber,
          _engine!.score,
          stars,
        );
  }

  void _onEngineUpdate() {
    if (!mounted || _engine == null) return;
    setState(() {});

    if (_engine!.state == GameState.levelComplete) {
      _handleLevelComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _level == null || _engine == null) {
      return Scaffold(
        body: PremiumBackground(
          child: Center(
            child: CircularProgressIndicator(color: PremiumDesign.cyanGlow),
          ),
        ),
      );
    }

    final engine = _engine!;
    final isEnded = engine.state == GameState.gameOver ||
        engine.state == GameState.levelComplete;

    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  GameHud(
                    levelNumber: widget.levelNumber,
                    score: engine.score,
                    sortedBeads: engine.sortedBeads,
                    totalBeads: engine.totalBeads,
                    conveyorFill: engine.conveyorFill,
                    onBack: () => context.pop(),
                    onPause: () {
                      setState(() {
                        if (engine.state == GameState.paused) {
                          engine.resume();
                        } else {
                          engine.pause();
                        }
                      });
                    },
                  ),
                  _ConveyorWarning(fill: engine.conveyorFill),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GameBoard(
                        engine: engine,
                        onStateChanged: _onEngineUpdate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              if (engine.state == GameState.paused)
                PremiumOverlay(
                  child: PremiumDialog(
                    title: 'Paused',
                    subtitle: 'Take a breath — the belt waits for you.',
                    icon: Icons.pause_circle_filled_rounded,
                    iconColors: const [PremiumDesign.oceanBlue, PremiumDesign.royalPurple],
                    primaryLabel: 'Resume',
                    onPrimary: () => setState(engine.resume),
                  ),
                ),
              if (isEnded)
                PremiumOverlay(
                  child: _EndOverlay(
                    engine: engine,
                    levelNumber: widget.levelNumber,
                    onRetry: _loadLevel,
                    onExit: () => context.pop(),
                    onNext: () => context.pushReplacement(
                      '${RouteConstants.gameplay}?level=${widget.levelNumber + 1}',
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

class _ConveyorWarning extends StatelessWidget {
  const _ConveyorWarning({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    if (fill < 0.6) return const SizedBox(height: 4);

    final isDanger = fill > 0.8;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: (isDanger ? AppTheme.dangerColor : AppTheme.warningColor)
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDanger ? AppTheme.dangerColor : AppTheme.warningColor)
              .withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: isDanger ? AppTheme.dangerColor : AppTheme.warningColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isDanger ? 'Belt almost full!' : 'Belt filling up...',
              style: TextStyle(
                color: isDanger ? AppTheme.dangerColor : AppTheme.warningColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EndOverlay extends StatelessWidget {
  const _EndOverlay({
    required this.engine,
    required this.levelNumber,
    required this.onRetry,
    required this.onExit,
    required this.onNext,
  });

  final GameEngine engine;
  final int levelNumber;
  final VoidCallback onRetry;
  final VoidCallback onExit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isWin = engine.state == GameState.levelComplete;
    final stars = engine.calculateStars();

    if (isWin) {
      return PremiumDialog(
        title: 'Level Complete!',
        subtitle: 'All beads sorted perfectly!',
        icon: Icons.emoji_events_rounded,
        iconColors: PremiumDesign.playGradient,
        showStars: true,
        starCount: stars,
        showConfetti: true,
        collectCoins: true,
        extra: Text(
          'Score: ${engine.score}',
          style: PremiumDesign.heading(size: 18, color: PremiumDesign.textDark),
        ),
        primaryLabel: levelNumber < AppConstants.totalLevels ? 'Next Level' : 'Home',
        onPrimary: levelNumber < AppConstants.totalLevels ? onNext : onExit,
        secondaryLabel: 'Retry',
        onSecondary: onRetry,
      );
    }

    return PremiumDialog(
      title: 'Belt Overflow!',
      subtitle: 'Too many beads on the conveyor. Try a new strategy!',
      icon: Icons.warning_amber_rounded,
      iconColors: const [PremiumDesign.sunsetOrange, PremiumDesign.coralPink],
      primaryLabel: 'Retry',
      onPrimary: onRetry,
      secondaryLabel: 'Home',
      onSecondary: onExit,
    );
  }
}
