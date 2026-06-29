import 'package:flutter/material.dart';

import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const _entries = [
    (rank: 1, name: 'BeadQueen', score: 98420, colors: PremiumDesign.goldGradient),
    (rank: 2, name: 'SortMaster', score: 87210, colors: [Color(0xFFC0C0C0), Color(0xFF9CA3AF)]),
    (rank: 3, name: 'TrayHero', score: 76500, colors: [Color(0xFFCD7F32), Color(0xFFB45309)]),
    (rank: 4, name: 'You', score: 54200, colors: PremiumDesign.gemGradient),
    (rank: 5, name: 'BeltRunner', score: 49800, colors: [PremiumDesign.royalPurple, PremiumDesign.violetDeep]),
  ];

  @override
  Widget build(BuildContext context) {
    return PremiumScreenShell(
      title: 'Leaderboard',
      showCurrency: true,
      coins: 240,
      gems: 30,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          final isYou = entry.name == 'You';

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassPanel(
              rainbowBorder: isYou,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: entry.colors),
                    ),
                    child: Text(
                      '${entry.rank}',
                      style: PremiumDesign.button(size: 14),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style: PremiumDesign.heading(
                            size: 16,
                            color: isYou ? PremiumDesign.royalPurple : PremiumDesign.textDark,
                          ),
                        ),
                        Text('${entry.score} pts', style: PremiumDesign.body(size: 12)),
                      ],
                    ),
                  ),
                  if (entry.rank <= 3)
                    Icon(Icons.emoji_events_rounded, color: entry.colors.first, size: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
