import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/dependency_injection.dart';
import '../../models/settings_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Music'),
            value: settings.musicEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(musicEnabled: v)),
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: settings.sfxEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(sfxEnabled: v)),
          ),
          SwitchListTile(
            title: const Text('Haptics'),
            value: settings.hapticsEnabled,
            onChanged: (v) => _update(ref, settings.copyWith(hapticsEnabled: v)),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: settings.notificationsEnabled,
            onChanged: (v) =>
                _update(ref, settings.copyWith(notificationsEnabled: v)),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, SettingsModel settings) {
    ref.read(settingsProvider.notifier).updateSettings(settings);
  }
}
