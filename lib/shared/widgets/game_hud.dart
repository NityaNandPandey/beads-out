import 'package:flutter/material.dart';

import '../../shared/design/premium_design.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.levelNumber,
    required this.score,
    required this.sortedBeads,
    required this.totalBeads,
    required this.conveyorFill,
    this.onPause,
    this.onBack,
  });

  final int levelNumber;
  final int score;
  final int sortedBeads;
  final int totalBeads;
  final double conveyorFill;
  final VoidCallback? onPause;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: PremiumDesign.rainbowBorder,
        boxShadow: PremiumDesign.glow(PremiumDesign.royalPurple, blur: 16),
      ),
      padding: const EdgeInsets.all(2.5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xCC5B21B6),
              Color(0xCC4FACFE),
              Color(0xCC7B2FF7),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _HudBtn(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'LEVEL $levelNumber',
                        style: PremiumDesign.button(size: 18),
                      ),
                      Text(
                        'Sort the beads!',
                        style: PremiumDesign.body(size: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                _HudBtn(icon: Icons.pause_rounded, onTap: onPause),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Pill(
                  icon: Icons.grain_rounded,
                  label: '$sortedBeads/$totalBeads',
                  colors: const [PremiumDesign.mintGreen, PremiumDesign.emerald],
                ),
                const SizedBox(width: 8),
                _Pill(
                  icon: Icons.star_rounded,
                  label: '$score',
                  colors: PremiumDesign.goldGradient,
                ),
                const Spacer(),
                SizedBox(
                  width: 92,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Belt', style: PremiumDesign.body(size: 10, color: Colors.white70)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 10,
                          child: Stack(
                            children: [
                              Container(color: Colors.white24),
                              FractionallySizedBox(
                                widthFactor: conveyorFill.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: conveyorFill > 0.8
                                          ? [PremiumDesign.sunsetOrange, PremiumDesign.coralPink]
                                          : conveyorFill > 0.5
                                              ? PremiumDesign.goldGradient
                                              : PremiumDesign.playGradient,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HudBtn extends StatelessWidget {
  const _HudBtn({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.colors});

  final IconData icon;
  final String label;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white38),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: PremiumDesign.currency(color: Colors.white)),
        ],
      ),
    );
  }
}
