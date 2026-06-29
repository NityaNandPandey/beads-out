import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/dependency_injection.dart';
import '../../models/settings_model.dart';
import '../../shared/design/premium_design.dart';
import '../../shared/widgets/premium/premium_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return PremiumScreenShell(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingCard(
            title: 'Music',
            subtitle: 'Background soundtrack',
            icon: Icons.music_note_rounded,
            colors: const [PremiumDesign.royalPurple, PremiumDesign.violetDeep],
            value: settings.musicEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(musicEnabled: v)),
          ),
          _SettingCard(
            title: 'Sound FX',
            subtitle: 'Taps, beads, and celebrations',
            icon: Icons.volume_up_rounded,
            colors: const [PremiumDesign.oceanBlue, PremiumDesign.cyanGlow],
            value: settings.sfxEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(sfxEnabled: v)),
          ),
          _SettingCard(
            title: 'Haptics',
            subtitle: 'Vibration on interactions',
            icon: Icons.vibration_rounded,
            colors: PremiumDesign.goldGradient,
            value: settings.hapticsEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(hapticsEnabled: v)),
          ),
          _SettingCard(
            title: 'Notifications',
            subtitle: 'Daily rewards & events',
            icon: Icons.notifications_active_rounded,
            colors: const [PremiumDesign.coralPink, Color(0xFFE11D48)],
            value: settings.notificationsEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(notificationsEnabled: v)),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, SettingsModel settings) {
    ref.read(settingsProvider.notifier).updateSettings(settings);
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: colors),
                boxShadow: PremiumDesign.glow(colors.first, blur: 10),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: PremiumDesign.heading(size: 16)),
                  Text(subtitle, style: PremiumDesign.body(size: 12)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              activeTrackColor: colors.first,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
