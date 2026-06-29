import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/enums/bead_color.dart';

/// Glossy sand/bead sphere used across gameplay.
class BeadSphere extends StatelessWidget {
  const BeadSphere({
    super.key,
    required this.color,
    this.size = 18,
  });

  final BeadColor color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.45),
          radius: 0.9,
          colors: [
            Colors.white,
            color.color,
            color.darkColor,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.darkColor.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: color.color.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: -1,
          ),
        ],
      ),
    );
  }
}

/// White elevated game board panel with rainbow border.
class GamePanel extends StatelessWidget {
  const GamePanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: AppTheme.panelBorderGradient,
        boxShadow: AppTheme.glowShadow(AppTheme.primaryColor),
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.boardColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Gradient title text widget.
class GradientTitle extends StatelessWidget {
  const GradientTitle({
    super.key,
    required this.text,
    this.fontSize = 28,
    this.letterSpacing = 1.5,
  });

  final String text;
  final double fontSize;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppTheme.titleGradient.createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}

/// Colorful stat chip with gradient fill.
class ColorfulChip extends StatelessWidget {
  const ColorfulChip({
    super.key,
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.glowShadow(colors.last),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3D pill button for menus.
class GameButton3D extends StatelessWidget {
  const GameButton3D({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.icon,
    this.height = 52,
    this.expand = false,
    this.minWidth = 120,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;
  final double height;
  final bool expand;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final base = color ?? AppTheme.playButtonColor;
    final dark = Color.lerp(base, Colors.black, 0.2)!;
    final light = Color.lerp(base, Colors.white, 0.25)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        constraints: BoxConstraints(minWidth: minWidth),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [light, base, dark],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 2),
          boxShadow: [
            BoxShadow(color: dark, blurRadius: 0, offset: const Offset(0, 5)),
            BoxShadow(color: base.withValues(alpha: 0.45), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
