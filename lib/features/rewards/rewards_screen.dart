import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_dialog.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spin;
  bool _spinning = false;
  String? _result;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  Future<void> _doSpin() async {
    if (_spinning) return;
    setState(() {
      _spinning = true;
      _result = null;
    });
    _spin.reset();
    await _spin.forward();
    if (!mounted) return;
    setState(() {
      _spinning = false;
      _result = ['50 Coins', '5 Gems', 'Booster', '100 Coins', 'Jackpot!', '2 Gems'][
          Random().nextInt(6)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PremiumScreenShell(
          title: 'Lucky Spin',
          showCurrency: true,
          coins: 240,
          gems: 30,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Spin to win!', style: PremiumDesign.display(size: 28, color: Colors.white)),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _spin,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spin.value * pi * 8,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: PremiumDesign.rainbowBorder,
                        boxShadow: PremiumDesign.glow(PremiumDesign.royalPurple, blur: 24),
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: CustomPaint(painter: _WheelPainter()),
                    ),
                  ),
                  const SizedBox(height: 32),
                  PremiumButton(
                    label: _spinning ? 'Spinning…' : 'SPIN FREE',
                    icon: Icons.casino_rounded,
                    onTap: _doSpin,
                    expand: true,
                    colors: const [PremiumDesign.sunsetOrange, PremiumDesign.goldenYellow],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_result != null)
          PremiumOverlay(
            child: PremiumDialog(
              title: 'You won!',
              subtitle: _result!,
              icon: Icons.celebration_rounded,
              iconColors: PremiumDesign.goldGradient,
              showConfetti: true,
              collectCoins: true,
              primaryLabel: 'Collect',
              onPrimary: () => setState(() => _result = null),
            ),
          ),
      ],
    );
  }
}

class _WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    const segments = 6;
    const colors = [
      PremiumDesign.cyanGlow,
      PremiumDesign.goldenYellow,
      PremiumDesign.coralPink,
      PremiumDesign.mintGreen,
      PremiumDesign.royalPurple,
      PremiumDesign.sunsetOrange,
    ];

    for (var i = 0; i < segments; i++) {
      final paint = Paint()..color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * 2 * pi / segments,
        2 * pi / segments,
        true,
        paint,
      );
    }
    canvas.drawCircle(center, 18, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
