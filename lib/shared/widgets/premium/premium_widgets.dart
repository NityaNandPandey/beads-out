import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/dependency_injection.dart';
import '../../design/premium_design.dart';
import '../../../core/enums/bead_color.dart';
import '../game_ui_components.dart';
import 'game_icons.dart';

/// Animated premium sky background with floating beads and sparkles.
class PremiumBackground extends StatefulWidget {
  const PremiumBackground({super.key, required this.child});

  final Widget child;

  @override
  State<PremiumBackground> createState() => _PremiumBackgroundState();
}

class _PremiumBackgroundState extends State<PremiumBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
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
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.8 + _controller.value * 0.3, -1),
              end: Alignment(1, 1 + _controller.value * 0.2),
              colors: PremiumDesign.skyGradient +
                  [PremiumDesign.cyanGlow.withValues(alpha: 0.3)],
            ),
          ),
          child: Stack(
            children: [
              ..._floatingOrbs(_controller.value),
              Positioned.fill(child: CustomPaint(painter: _SparkleFieldPainter(_controller.value))),
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  List<Widget> _floatingOrbs(double t) {
    return List.generate(6, (i) {
      final angle = t * 2 * pi + i * 1.1;
      final dx = cos(angle) * (30 + i * 8);
      final dy = sin(angle * 0.7) * (20 + i * 6);
      return Positioned(
        top: 80.0 + i * 110 + dy,
        left: i.isEven ? 20 + dx : null,
        right: i.isOdd ? 24 - dx : null,
        child: Opacity(
          opacity: 0.35 + (sin(t * pi * 2 + i) + 1) * 0.2,
          child: BeadSphere(
            color: BeadColor.values[i % BeadColor.values.length],
            size: 14 + i * 3.0,
          ),
        ),
      );
    });
  }
}

class _SparkleFieldPainter extends CustomPainter {
  _SparkleFieldPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.4);
    final random = Random(7);
    for (var i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final pulse = (sin(t * pi * 2 + i) + 1) / 2;
      canvas.drawCircle(Offset(x, y), 1 + pulse * 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(_SparkleFieldPainter old) => old.t != t;
}

/// Frosted glass panel with rainbow edge glow.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 28,
    this.rainbowBorder = false,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool rainbowBorder;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final inner = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius - 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: PremiumDesign.glassGradient,
            borderRadius: BorderRadius.circular(borderRadius - 2),
            border: Border.all(color: PremiumDesign.glassBorder, width: 1.5),
            boxShadow: PremiumDesign.cardDepth,
          ),
          child: child,
        ),
      ),
    );

    if (!rainbowBorder) {
      return Padding(padding: margin ?? EdgeInsets.zero, child: inner);
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: PremiumDesign.rainbowBorder,
        boxShadow: PremiumDesign.glow(PremiumDesign.royalPurple, blur: 18),
      ),
      padding: const EdgeInsets.all(2.5),
      child: inner,
    );
  }
}

/// Scale + haptic tap wrapper for premium interactions.
class ScaleTap extends ConsumerStatefulWidget {
  const ScaleTap({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.94,
    this.feedback = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool feedback;

  @override
  ConsumerState<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends ConsumerState<ScaleTap> {
  bool _pressed = false;

  void _handleTap() {
    if (widget.feedback) {
      ref.read(feedbackServiceProvider).tap();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _pressed = false);
              _handleTap();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Premium gradient pill button with glow and bounce.
class PremiumButton extends StatelessWidget {
  const PremiumButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.colors = PremiumDesign.playGradient,
    this.height = 56,
    this.expand = false,
    this.glowColor,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final List<Color> colors;
  final double height;
  final bool expand;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final glow = glowColor ?? colors.first;

    return ScaleTap(
      onTap: onTap,
      child: Container(
        height: height,
        width: expand ? double.infinity : null,
        constraints: BoxConstraints(minWidth: expand ? 0 : 130),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(colors.first, Colors.white, 0.25)!,
              colors.length > 1 ? colors[1] : colors.first,
              colors.length > 2 ? colors.last : Color.lerp(colors.first, Colors.black, 0.15)!,
            ],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.65), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Color.lerp(colors.last, Colors.black, 0.2)!.withValues(alpha: 0.5),
              blurRadius: 0,
              offset: const Offset(0, 5),
            ),
            ...PremiumDesign.glow(glow, blur: 16),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 10),
            ],
            Text(label, style: PremiumDesign.button()),
          ],
        ),
      ),
    );
  }
}

/// Top currency bar: coins, gems, lives.
class CurrencyBar extends StatelessWidget {
  const CurrencyBar({
    super.key,
    required this.coins,
    required this.gems,
    required this.lives,
    this.onSettings,
    this.avatarLabel = 'P',
  });

  final int coins;
  final int gems;
  final int lives;
  final VoidCallback? onSettings;
  final String avatarLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CurrencyPill(
          icon: Icons.monetization_on_rounded,
          value: '$coins',
          colors: PremiumDesign.goldGradient,
        ),
        const SizedBox(width: 8),
        _CurrencyPill(
          icon: Icons.diamond_rounded,
          value: '$gems',
          colors: PremiumDesign.gemGradient,
        ),
        const SizedBox(width: 8),
        _CurrencyPill(
          icon: Icons.favorite_rounded,
          value: '$lives',
          colors: const [PremiumDesign.coralPink, Color(0xFFE11D48)],
        ),
        const Spacer(),
        if (onSettings != null)
          ScaleTap(
            onTap: onSettings,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [PremiumDesign.oceanBlue, PremiumDesign.royalPurple],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                boxShadow: PremiumDesign.glow(PremiumDesign.royalPurple, blur: 12),
              ),
              child: const Icon(Icons.settings_rounded, color: Colors.white, size: 22),
            ),
          ),
      ],
    );
  }
}

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({
    required this.icon,
    required this.value,
    required this.colors,
  });

  final IconData icon;
  final String value;
  final List<Color> colors;

  Widget _iconForType(IconData data, double size) {
    if (data == Icons.monetization_on_rounded) return GameIcons.coin(size: size);
    if (data == Icons.diamond_rounded) return GameIcons.gem(size: size);
    if (data == Icons.favorite_rounded) return GameIcons.heart(size: size);
    return Icon(data, color: Colors.white, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1.5),
        boxShadow: PremiumDesign.glow(colors.first, blur: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconForType(icon, 18),
          const SizedBox(width: 5),
          Text(value, style: PremiumDesign.currency(color: Colors.white)),
        ],
      ),
    );
  }
}

/// Circular home menu orb button.
class MenuOrb extends StatelessWidget {
  const MenuOrb({
    super.key,
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleTap(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors,
                    ),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 2.5),
                    boxShadow: PremiumDesign.glow(colors.first, blur: 14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: PremiumDesign.coralPink,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        badge!,
                        style: PremiumDesign.body(size: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: PremiumDesign.body(size: 11, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Large pulsing play button for home screen.
class PlayOrb extends StatefulWidget {
  const PlayOrb({super.key, required this.level, required this.onTap});

  final int level;
  final VoidCallback onTap;

  @override
  State<PlayOrb> createState() => _PlayOrbState();
}

class _PlayOrbState extends State<PlayOrb> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + _pulse.value * 0.04,
          child: child,
        );
      },
      child: ScaleTap(
        onTap: widget.onTap,
        scale: 0.92,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    PremiumDesign.mintGreen.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: 168,
              height: 168,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: PremiumDesign.playGradient,
                ),
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: PremiumDesign.glow(PremiumDesign.mintGreen, blur: 28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 56),
                  ),
                  const SizedBox(height: 4),
                  Text('LEVEL ${widget.level}', style: PremiumDesign.button(size: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium screen scaffold with background + optional top bar.
class PremiumScreenShell extends StatelessWidget {
  const PremiumScreenShell({
    super.key,
    required this.child,
    this.title,
    this.leading,
    this.trailing,
    this.showCurrency = false,
    this.coins = 0,
    this.gems = 0,
    this.lives = 5,
  });

  final Widget child;
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final bool showCurrency;
  final int coins;
  final int gems;
  final int lives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PremiumBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    leading ??
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                          ),
                        ),
                    if (title != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title!,
                          style: PremiumDesign.heading(size: 20, color: Colors.white),
                        ),
                      ),
                    ] else
                      const Spacer(),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
              if (showCurrency)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: CurrencyBar(coins: coins, gems: gems, lives: lives),
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
