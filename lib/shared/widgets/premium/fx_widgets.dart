import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/enums/bead_color.dart';

/// Short-lived burst particles when beads are collected.
class ParticleBurstLayer extends StatefulWidget {
  const ParticleBurstLayer({
    super.key,
    required this.particles,
  });

  final List<BurstParticle> particles;

  @override
  State<ParticleBurstLayer> createState() => _ParticleBurstLayerState();
}

class _ParticleBurstLayerState extends State<ParticleBurstLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<BurstParticle> _active;

  @override
  void initState() {
    super.initState();
    _active = List.of(widget.particles);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void didUpdateWidget(ParticleBurstLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.particles.length > oldWidget.particles.length) {
      _active.addAll(widget.particles.skip(oldWidget.particles.length));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _BurstPainter(_active, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class BurstParticle {
  BurstParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
  });

  final double x;
  final double y;
  final Color color;
  final double angle;
  final double speed;
  final double size;

  factory BurstParticle.fromSort(double x, double y, BeadColor beadColor) {
    final random = Random();
    return BurstParticle(
      x: x,
      y: y,
      color: beadColor.color,
      angle: random.nextDouble() * pi * 2,
      speed: 40 + random.nextDouble() * 80,
      size: 4 + random.nextDouble() * 6,
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.particles, this.t);

  final List<BurstParticle> particles;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final fade = (1 - t).clamp(0.0, 1.0);
    for (final p in particles) {
      final dx = cos(p.angle) * p.speed * t;
      final dy = sin(p.angle) * p.speed * t - 20 * t;
      final paint = Paint()..color = p.color.withValues(alpha: fade);
      canvas.drawCircle(Offset(p.x + dx, p.y + dy), p.size * fade, paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}

/// Animates coins flying toward a target (e.g. currency bar).
class CoinFlyOverlay extends StatefulWidget {
  const CoinFlyOverlay({
    super.key,
    required this.start,
    required this.end,
    required this.onComplete,
    this.count = 8,
  });

  final Offset start;
  final Offset end;
  final VoidCallback onComplete;
  final int count;

  @override
  State<CoinFlyOverlay> createState() => _CoinFlyOverlayState();
}

class _CoinFlyOverlayState extends State<CoinFlyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _CoinFlyPainter(
            t: Curves.easeInOutCubic.transform(_controller.value),
            start: widget.start,
            end: widget.end,
            count: widget.count,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CoinFlyPainter extends CustomPainter {
  _CoinFlyPainter({
    required this.t,
    required this.start,
    required this.end,
    required this.count,
  });

  final double t;
  final Offset start;
  final Offset end;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(3);
    for (var i = 0; i < count; i++) {
      final stagger = (i / count) * 0.25;
      final localT = ((t - stagger) / (1 - stagger)).clamp(0.0, 1.0);
      if (localT <= 0) continue;

      final control = Offset(
        (start.dx + end.dx) / 2 + random.nextDouble() * 60 - 30,
        min(start.dy, end.dy) - 80 - i * 8,
      );
      final pos = _quadratic(start, control, end, localT);
      canvas.drawCircle(
        pos,
        8 * (1 - localT * 0.3),
        Paint()..color = const Color(0xFFFFD93D).withValues(alpha: 1 - localT * 0.2),
      );
    }
  }

  Offset _quadratic(Offset a, Offset b, Offset c, double t) {
    final x = pow(1 - t, 2) * a.dx + 2 * (1 - t) * t * b.dx + pow(t, 2) * c.dx;
    final y = pow(1 - t, 2) * a.dy + 2 * (1 - t) * t * b.dy + pow(t, 2) * c.dy;
    return Offset(x.toDouble(), y.toDouble());
  }

  @override
  bool shouldRepaint(_CoinFlyPainter old) => old.t != t;
}
