import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/dependency_injection.dart';
import '../../design/premium_design.dart';
import 'fx_widgets.dart';
import 'game_icons.dart';
import 'premium_widgets.dart';

/// Animated premium dialog shell for win / lose / pause / rewards.
class PremiumDialog extends ConsumerStatefulWidget {
  const PremiumDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.icon,
    this.iconColors = PremiumDesign.playGradient,
    this.showStars,
    this.starCount = 0,
    this.extra,
    this.showConfetti = false,
    this.collectCoins = false,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? icon;
  final List<Color> iconColors;
  final bool? showStars;
  final int starCount;
  final Widget? extra;
  final bool showConfetti;
  final bool collectCoins;

  @override
  ConsumerState<PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends ConsumerState<PremiumDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _entry;
  bool _flyingCoins = false;
  Offset? _coinStart;
  Offset? _coinEnd;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();

    if (widget.showConfetti) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(feedbackServiceProvider).celebrate();
      });
    }
  }

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  void _handlePrimary() {
    if (widget.collectCoins) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final center = box.localToGlobal(box.size.center(Offset.zero));
        setState(() {
          _flyingCoins = true;
          _coinStart = center;
          _coinEnd = Offset(MediaQuery.sizeOf(context).width - 48, 48);
        });
        ref.read(feedbackServiceProvider).success();
        return;
      }
    }
    widget.onPrimary();
  }

  void _onCoinsComplete() {
    setState(() => _flyingCoins = false);
    widget.onPrimary();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _entry, curve: Curves.elasticOut);
    final fade = CurvedAnimation(parent: _entry, curve: Curves.easeOut);

    return Stack(
      alignment: Alignment.center,
      children: [
        FadeTransition(
          opacity: fade,
          child: Container(color: Colors.black.withValues(alpha: 0.55)),
        ),
        if (widget.showConfetti)
          Positioned.fill(child: _ConfettiLayer(progress: _entry)),
        if (_flyingCoins && _coinStart != null && _coinEnd != null)
          CoinFlyOverlay(
            start: _coinStart!,
            end: _coinEnd!,
            onComplete: _onCoinsComplete,
          ),
        ScaleTransition(
          scale: curve,
          child: FadeTransition(
            opacity: fade,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: GlassPanel(
                  rainbowBorder: true,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null)
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: widget.iconColors),
                            boxShadow: PremiumDesign.glow(widget.iconColors.first),
                          ),
                          child: widget.icon == Icons.star_rounded
                              ? Center(child: GameIcons.star(size: 36))
                              : Icon(widget.icon, color: Colors.white, size: 38),
                        ),
                      if (widget.icon != null) const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (b) => LinearGradient(
                          colors: widget.iconColors,
                        ).createShader(b),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: PremiumDesign.display(size: 28, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: PremiumDesign.body(size: 14, color: PremiumDesign.textMuted),
                      ),
                      if (widget.showStars == true) ...[
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GameIcons.star(
                                size: 38,
                                filled: i < widget.starCount,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget.extra != null) ...[
                        const SizedBox(height: 12),
                        widget.extra!,
                      ],
                      const SizedBox(height: 24),
                      PremiumButton(
                        label: widget.primaryLabel,
                        onTap: _handlePrimary,
                        expand: true,
                        colors: widget.iconColors,
                      ),
                      if (widget.secondaryLabel != null && widget.onSecondary != null) ...[
                        const SizedBox(height: 12),
                        PremiumButton(
                          label: widget.secondaryLabel!,
                          onTap: widget.onSecondary!,
                          expand: true,
                          colors: const [PremiumDesign.coralPink, Color(0xFFE11D48)],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiLayer extends StatelessWidget {
  const _ConfettiLayer({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConfettiPainter(progress.value),
      size: Size.infinite,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t);

  final double t;
  static final _colors = [
    PremiumDesign.cyanGlow,
    PremiumDesign.goldenYellow,
    PremiumDesign.coralPink,
    PremiumDesign.mintGreen,
    PremiumDesign.royalPurple,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(12);
    for (var i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height * 0.4;
      final y = baseY + t * size.height * (0.5 + random.nextDouble());
      final paint = Paint()..color = _colors[i % _colors.length].withValues(alpha: 0.85);
      canvas.save();
      canvas.translate(x, y % size.height);
      canvas.rotate(random.nextDouble() * pi * 2 * t);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, 8, 12), const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

/// Full-screen overlay wrapper for dialogs.
class PremiumOverlay extends StatelessWidget {
  const PremiumOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: child);
  }
}
