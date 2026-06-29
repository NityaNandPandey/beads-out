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
import '../../shared/widgets/game_hud.dart';
import '../../shared/widgets/game_ui_components.dart';
import '../../shared/widgets/pastel_background.dart';
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
        body: PastelBackground(
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
      );
    }

    final engine = _engine!;
    final isEnded = engine.state == GameState.gameOver ||
        engine.state == GameState.levelComplete;

    return Scaffold(
      body: PastelBackground(
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
                _PauseOverlay(
                  onResume: () => setState(engine.resume),
                ),
              if (isEnded)
                _EndOverlay(
                  engine: engine,
                  levelNumber: widget.levelNumber,
                  onRetry: _loadLevel,
                  onExit: () => context.pop(),
                  onNext: () => context.pushReplacement(
                    '${RouteConstants.gameplay}?level=${widget.levelNumber + 1}',
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

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay({required this.onResume});

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      alignment: Alignment.center,
      child: GamePanel(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pause_circle_filled_rounded, size: 64, color: AppTheme.primaryColor),
            const SizedBox(height: 12),
            const Text(
              'Paused',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: GameButton3D(
                label: 'Resume',
                icon: Icons.play_arrow_rounded,
                onTap: onResume,
                expand: true,
              ),
            ),
          ],
        ),
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

    return Container(
      color: Colors.black45,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: GamePanel(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isWin)
                  const GradientTitle(text: 'Level Complete!', fontSize: 28)
                else
                  const GradientTitle(text: 'Belt Overflow!', fontSize: 28),
                const SizedBox(height: 10),
                Text(
                  isWin
                      ? 'All beads sorted perfectly!'
                      : 'Too many beads on the belt. Try again!',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isWin) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < stars
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: AppTheme.goldColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Score: ${engine.score}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GameButton3D(
                        label: 'Retry',
                        color: AppTheme.accentColor,
                        onTap: onRetry,
                        height: 50,
                        expand: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: isWin && levelNumber < AppConstants.totalLevels
                          ? GameButton3D(
                              label: 'Next',
                              onTap: onNext,
                              height: 50,
                              expand: true,
                            )
                          : isWin
                              ? GameButton3D(
                                  label: 'Home',
                                  onTap: onExit,
                                  height: 50,
                                  expand: true,
                                )
                              : GameButton3D(
                                  label: 'Exit',
                                  color: AppTheme.primaryColor,
                                  onTap: onExit,
                                  height: 50,
                                  expand: true,
                                ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
