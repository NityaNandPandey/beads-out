import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/enums/bead_color.dart';
import 'game_ui_components.dart';

class PastelBackground extends StatelessWidget {
  const PastelBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Stack(
        children: [
          ..._backgroundDecorations(),
          child,
        ],
      ),
    );
  }

  List<Widget> _backgroundDecorations() {
    const blobs = [
      (top: -70.0, left: null, right: -50.0, bottom: null, color: AppTheme.accentColor, size: 200.0, alpha: 0.22),
      (top: 100.0, left: -60.0, right: null, bottom: null, color: AppTheme.secondaryColor, size: 160.0, alpha: 0.18),
      (top: null, left: null, right: 10.0, bottom: 120.0, color: AppTheme.primaryColor, size: 130.0, alpha: 0.16),
      (top: null, left: 30.0, right: null, bottom: -40.0, color: AppTheme.goldColor, size: 150.0, alpha: 0.2),
      (top: 280.0, left: null, right: -20.0, bottom: null, color: AppTheme.skyColor, size: 90.0, alpha: 0.15),
      (top: 400.0, left: -30.0, right: null, bottom: null, color: AppTheme.pinkColor, size: 110.0, alpha: 0.14),
    ];

    return [
      for (final blob in blobs)
        Positioned(
          top: blob.top,
          left: blob.left,
          right: blob.right,
          bottom: blob.bottom,
          child: _GlowBlob(
            color: blob.color.withValues(alpha: blob.alpha),
            size: blob.size,
          ),
        ),
      for (var i = 0; i < 8; i++)
        Positioned(
          top: 60.0 + i * 90,
          left: i.isEven ? 12.0 : null,
          right: i.isOdd ? 16.0 : null,
          child: BeadSphere(
            color: BeadColor.values[i % BeadColor.values.length],
            size: 10 + (i % 3) * 4.0,
          ),
        ),
      Positioned.fill(
        child: CustomPaint(
          painter: _SparklePainter(),
        ),
      ),
    ];
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.35);
    final random = Random(42);

    for (var i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final r = 1.0 + random.nextDouble() * 2;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
