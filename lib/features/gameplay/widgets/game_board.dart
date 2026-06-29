import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_theme.dart';
import '../../../app/dependency_injection.dart';
import '../../../core/constants/game_layout_constants.dart';
import '../../../core/enums/game_state.dart';
import '../../../game_engine/engine.dart';
import '../../../models/bead_model.dart';
import '../../../models/block_model.dart';
import '../../../shared/widgets/collection_box.dart';
import '../../../shared/widgets/color_block.dart';
import '../../../shared/widgets/game_ui_components.dart';
import '../../../shared/widgets/premium/fx_widgets.dart';

class GameBoard extends ConsumerStatefulWidget {
  const GameBoard({
    super.key,
    required this.engine,
    required this.onStateChanged,
  });

  final GameEngine engine;
  final VoidCallback onStateChanged;

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends ConsumerState<GameBoard>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  late Ticker _beltTicker;
  Duration _lastElapsed = Duration.zero;
  double _beltOffset = 0;
  double _scaleX = 1;
  double _scaleY = 1;
  final _blockKeys = <String, GlobalKey>{};
  final _particles = <BurstParticle>[];
  int _particleGeneration = 0;

  @override
  void initState() {
    super.initState();
    for (final block in widget.engine.blocks) {
      _blockKeys[block.id] = GlobalKey();
    }
    _ticker = createTicker(_onTick)..start();
    _beltTicker = createTicker((elapsed) {
      setState(() => _beltOffset = elapsed.inMilliseconds / 40.0);
    })..start();
  }

  void _onTick(Duration elapsed) {
    if (widget.engine.state != GameState.playing) {
      _lastElapsed = elapsed;
      return;
    }

    final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    if (dt <= 0 || dt > 0.05) return;

    widget.engine.update(dt);

    final events = widget.engine.drainSortEvents();
    if (events.isNotEmpty) {
      for (final event in events) {
        for (var i = 0; i < 10; i++) {
          _particles.add(BurstParticle.fromSort(
            event.x * _scaleX,
            event.y * _scaleY,
            event.color,
          ));
        }
      }
      _particleGeneration++;
      ref.read(feedbackServiceProvider).tap();
    }

    widget.onStateChanged();
    if (events.isNotEmpty) setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    _beltTicker.dispose();
    super.dispose();
  }

  void _tapBlock(String blockId) {
    ref.read(feedbackServiceProvider).tap();

    final key = _blockKeys[blockId];
    final box = key?.currentContext?.findRenderObject() as RenderBox?;
    var spawnX = GameLayoutConstants.boardWidth / 2;

    if (box != null) {
      final boardBox = context.findRenderObject() as RenderBox?;
      if (boardBox != null) {
        final blockCenter = box.localToGlobal(box.size.center(Offset.zero));
        final boardOrigin = boardBox.localToGlobal(Offset.zero);
        spawnX =
            (blockCenter.dx - boardOrigin.dx) / boardBox.size.width *
            GameLayoutConstants.boardWidth;
      }
    }

    widget.engine.tapBlock(
      blockId,
      spawnX.clamp(24, GameLayoutConstants.boardWidth - 24),
    );
    widget.onStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    final engine = widget.engine;

    return GamePanel(
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _scaleX = constraints.maxWidth / GameLayoutConstants.boardWidth;
          _scaleY = constraints.maxHeight / GameLayoutConstants.boardHeight;

          return Column(
            children: [
              _BlockShelf(
                blocks: engine.blocks,
                blockKeys: _blockKeys,
                onTap: _tapBlock,
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ConveyorScenePainter(
                          fill: engine.conveyorFill,
                          beltOffset: _beltOffset,
                        ),
                      ),
                    ),
                    ...engine.beads.where((b) => !b.isSorted).map(
                          (bead) => _BeadOnBoard(
                            bead: bead,
                            scaleX: _scaleX,
                            scaleY: _scaleY,
                          ),
                        ),
                    if (_particles.isNotEmpty)
                      Positioned.fill(
                        child: ParticleBurstLayer(
                          key: ValueKey(_particleGeneration),
                          particles: _particles,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 88,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: engine.containers
                      .map((c) => CollectionBox(container: c))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlockShelf extends StatelessWidget {
  const _BlockShelf({
    required this.blocks,
    required this.blockKeys,
    required this.onTap,
  });

  final List<BlockModel> blocks;
  final Map<String, GlobalKey> blockKeys;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final active = blocks.where((b) => !b.isBroken).toList();

    return Container(
      height: active.isEmpty ? 16 : 118,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: AppTheme.panelBorderGradient,
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.boardInner,
              AppTheme.boardInner.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(19),
        ),
        child: active.isEmpty
            ? const SizedBox.shrink()
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: min(4, active.length),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: active.length,
                itemBuilder: (context, index) {
                  final block = active[index];
                  return ColorBlock(
                    key: blockKeys[block.id],
                    block: block,
                    onTap: () => onTap(block.id),
                  );
                },
              ),
      ),
    );
  }
}

class _BeadOnBoard extends StatelessWidget {
  const _BeadOnBoard({
    required this.bead,
    required this.scaleX,
    required this.scaleY,
  });

  final BeadModel bead;
  final double scaleX;
  final double scaleY;

  @override
  Widget build(BuildContext context) {
    final size = GameLayoutConstants.beadRadius * 2.2;
    return Positioned(
      left: bead.x * scaleX - size / 2,
      top: bead.y * scaleY - size / 2,
      child: BeadSphere(color: bead.color, size: size),
    );
  }
}

class _ConveyorScenePainter extends CustomPainter {
  _ConveyorScenePainter({required this.fill, required this.beltOffset});

  final double fill;
  final double beltOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleY = size.height / GameLayoutConstants.boardHeight;
    final beltY = GameLayoutConstants.conveyorY * scaleY - 18;
    const beltH = 48.0;

    final railPaint = Paint()
      ..color = AppTheme.conveyorRail
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(6, beltY - 4), Offset(size.width - 6, beltY - 4), railPaint);
    canvas.drawLine(
      Offset(6, beltY + beltH + 4),
      Offset(size.width - 6, beltY + beltH + 4),
      railPaint,
    );

    final beltRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, beltY, size.width - 20, beltH),
      const Radius.circular(14),
    );

    canvas.drawRRect(
      beltRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.conveyorLight, AppTheme.conveyorColor, AppTheme.conveyorDark],
        ).createShader(Rect.fromLTWH(0, beltY, size.width, beltH)),
    );

    final stripePaint = Paint()..color = Colors.white.withValues(alpha: 0.22);
    for (var x = -20 + beltOffset % 28; x < size.width; x += 28) {
      canvas.drawRect(Rect.fromLTWH(x, beltY + 6, 12, beltH - 12), stripePaint);
    }

    if (fill > 0.45) {
      canvas.drawRRect(
        beltRect,
        Paint()
          ..color = (fill > 0.8 ? AppTheme.dangerColor : AppTheme.warningColor)
              .withValues(alpha: 0.2 + fill * 0.25),
      );
    }

    canvas.drawRRect(
      beltRect,
      Paint()
        ..color = AppTheme.conveyorRail
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final arrowPaint = Paint()
      ..color = AppTheme.conveyorRail.withValues(alpha: 0.5)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (var x = 24.0; x < size.width - 30; x += 36) {
      final cy = beltY + beltH / 2;
      canvas.drawLine(Offset(x, cy - 4), Offset(x + 10, cy), arrowPaint);
      canvas.drawLine(Offset(x + 10, cy), Offset(x, cy + 4), arrowPaint);
    }

    final chutePaint = Paint()
      ..color = AppTheme.conveyorRail.withValues(alpha: 0.25)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.2, beltY + beltH),
      Offset(size.width * 0.15, size.height - 4),
      chutePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, beltY + beltH),
      Offset(size.width * 0.85, size.height - 4),
      chutePaint,
    );
  }

  @override
  bool shouldRepaint(_ConveyorScenePainter old) =>
      old.fill != fill || old.beltOffset != beltOffset;
}
