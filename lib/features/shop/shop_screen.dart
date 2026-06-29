import 'package:flutter/material.dart';

import '../../shared/widgets/feature_placeholder.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Shop',
      description: 'Buy skins, power-ups, and more.',
      icon: Icons.store,
    );
  }
}
