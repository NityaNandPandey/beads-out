import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/enums/bead_color.dart';
import '../../models/container_model.dart';
import 'game_ui_components.dart';

class CollectionBox extends StatelessWidget {
  const CollectionBox({super.key, required this.container});

  final ContainerModel container;

  @override
  Widget build(BuildContext context) {
    final fill = container.fillPercentage.clamp(0.0, 1.0);
    final c = container.color;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: _TrayPainter(color: c, fill: fill),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (container.isFull)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: c.darkColor,
                            size: 20,
                          ),
                        ),
                      ),
                    if (fill > 0.05)
                      Positioned(
                        bottom: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            min(container.currentCount, 5),
                            (_) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: BeadSphere(color: c, size: 10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: c.darkColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrayPainter extends CustomPainter {
  _TrayPainter({required this.color, required this.fill});

  final BeadColor color;
  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(4, 8)
      ..lineTo(4, size.height - 12)
      ..quadraticBezierTo(4, size.height - 4, 12, size.height - 4)
      ..lineTo(size.width - 12, size.height - 4)
      ..quadraticBezierTo(size.width - 4, size.height - 4, size.width - 4, size.height - 12)
      ..lineTo(size.width - 4, 8)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    if (fill > 0) {
      final fillPath = Path()
        ..moveTo(8, size.height - 8)
        ..lineTo(8, size.height - 8 - (size.height - 20) * fill)
        ..lineTo(size.width - 8, size.height - 8 - (size.height - 20) * fill)
        ..lineTo(size.width - 8, size.height - 8)
        ..close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.color.withValues(alpha: 0.6),
              color.color,
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color.darkColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Rim highlight
    canvas.drawLine(
      const Offset(6, 10),
      Offset(size.width - 6, 10),
      Paint()
        ..color = color.color.withValues(alpha: 0.5)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TrayPainter old) =>
      old.fill != fill || old.color != color;
}
