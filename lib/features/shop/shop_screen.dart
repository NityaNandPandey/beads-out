import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  static const _items = [
    (title: 'Coin Pack S', price: '₹49', coins: '500', colors: PremiumDesign.goldGradient),
    (title: 'Gem Pack M', price: '₹99', coins: '120', colors: PremiumDesign.gemGradient),
    (title: 'No Ads', price: '₹199', coins: 'Forever', colors: PremiumDesign.playGradient),
    (title: 'Booster Pack', price: '₹79', coins: '3x', colors: [PremiumDesign.coralPink, Color(0xFFE11D48)]),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumScreenShell(
      title: 'Shop',
      showCurrency: true,
      coins: 120,
      gems: 45,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ScaleTap(
            onTap: () {},
            child: GlassPanel(
              rainbowBorder: true,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(colors: item.colors),
                      boxShadow: PremiumDesign.glow(item.colors.first, blur: 12),
                    ),
                    child: Icon(
                      index == 1 ? Icons.diamond_rounded : Icons.monetization_on_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const Spacer(),
                  Text(item.title, style: PremiumDesign.heading(size: 15)),
                  Text(item.coins, style: PremiumDesign.body(size: 13)),
                  const SizedBox(height: 8),
                  PremiumButton(
                    label: item.price,
                    onTap: () {},
                    height: 40,
                    colors: item.colors,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
