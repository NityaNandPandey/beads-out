import 'dart:math';

import 'package:flutter/material.dart';

import '../../design/premium_design.dart';

/// Custom vector-style game icons (original artwork, not copied).
class GameIcons {
  GameIcons._();

  static Widget coin({double size = 24}) => CustomPaint(
        size: Size(size, size),
        painter: _CoinPainter(),
      );

  static Widget gem({double size = 24}) => CustomPaint(
        size: Size(size, size),
        painter: _GemPainter(),
      );

  static Widget heart({double size = 24}) => CustomPaint(
        size: Size(size, size),
        painter: _HeartPainter(),
      );

  static Widget star({double size = 24, bool filled = true}) => CustomPaint(
        size: Size(size, size),
        painter: _StarPainter(filled: filled),
      );

  static Widget play({double size = 24}) => CustomPaint(
        size: Size(size, size),
        painter: _PlayPainter(),
      );
}

class _CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFF176), PremiumDesign.goldenYellow, PremiumDesign.sunsetOrange],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
    canvas.drawCircle(center, r, Paint()..color = PremiumDesign.sunsetOrange..style = PaintingStyle.stroke..strokeWidth = 1.5);
    final text = TextPainter(
      text: TextSpan(text: '\$', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: r * 0.9)),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset(center.dx - text.width / 2, center.dy - text.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.38)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.38)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [PremiumDesign.cyanGlow, PremiumDesign.oceanBlue, PremiumDesign.royalPurple],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.5)..style = PaintingStyle.stroke..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, h * 0.88)
      ..cubicTo(w * 0.1, h * 0.55, 0, h * 0.25, w * 0.25, h * 0.12)
      ..cubicTo(w * 0.4, h * 0.02, w * 0.5, h * 0.15, w * 0.5, h * 0.22)
      ..cubicTo(w * 0.5, h * 0.15, w * 0.6, h * 0.02, w * 0.75, h * 0.12)
      ..cubicTo(w, h * 0.25, w * 0.9, h * 0.55, w * 0.5, h * 0.88)
      ..close();
    canvas.drawPath(path, Paint()..color = PremiumDesign.coralPink);
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.filled});

  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _starPath(size);
    canvas.drawPath(
      path,
      Paint()
        ..color = filled ? PremiumDesign.goldenYellow : Colors.transparent
        ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    if (!filled) {
      canvas.drawPath(path, Paint()..color = PremiumDesign.goldenYellow..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  Path _starPath(Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    for (var i = 0; i < 5; i++) {
      final angle = -pi / 2 + i * 4 * pi / 5;
      final point = Offset(cx + cos(angle) * r, cy + sin(angle) * r);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.filled != filled;
}

class _PlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.28, size.height * 0.15)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.28, size.height * 0.85)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
