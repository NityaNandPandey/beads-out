import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  const SettingsModel({
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.hapticsEnabled = true,
    this.notificationsEnabled = true,
    this.musicVolume = 0.8,
    this.sfxVolume = 1.0,
  });

  final bool musicEnabled;
  final bool sfxEnabled;
  final bool hapticsEnabled;
  final bool notificationsEnabled;
  final double musicVolume;
  final double sfxVolume;

  SettingsModel copyWith({
    bool? musicEnabled,
    bool? sfxEnabled,
    bool? hapticsEnabled,
    bool? notificationsEnabled,
    double? musicVolume,
    double? sfxVolume,
  }) {
    return SettingsModel(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      sfxEnabled: json['sfxEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      musicVolume: (json['musicVolume'] as num?)?.toDouble() ?? 0.8,
      sfxVolume: (json['sfxVolume'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'musicEnabled': musicEnabled,
        'sfxEnabled': sfxEnabled,
        'hapticsEnabled': hapticsEnabled,
        'notificationsEnabled': notificationsEnabled,
        'musicVolume': musicVolume,
        'sfxVolume': sfxVolume,
      };

  @override
  List<Object?> get props => [
        musicEnabled,
        sfxEnabled,
        hapticsEnabled,
        notificationsEnabled,
        musicVolume,
        sfxVolume,
      ];
}
