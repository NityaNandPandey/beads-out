import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/enums/bead_color.dart';
import '../../game_engine/engine.dart';

class BeadsOutGame extends FlameGame {
  BeadsOutGame({required this.engine});

  final GameEngine engine;

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    engine.update(dt);
  }

  void onBlockTapped() {
    // Particle effects will be added in Phase 5
  }
}

class BeadComponent extends CircleComponent {
  BeadComponent({required BeadColor color, required Vector2 position})
      : super(
          radius: 6,
          paint: Paint()..color = Color(color.colorValue),
          position: position,
        );
}
