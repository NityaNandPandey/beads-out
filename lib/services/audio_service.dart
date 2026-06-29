import '../core/logger/app_logger.dart';

class AudioService {
  AudioService();

  bool _musicEnabled = true;
  bool _sfxEnabled = true;

  Future<void> init() async {
    AppLogger.info('AudioService initialized');
  }

  Future<void> playBgm(String assetPath) async {
    if (!_musicEnabled) return;
    AppLogger.debug('Playing BGM: $assetPath');
  }

  Future<void> playSfx(String assetPath) async {
    if (!_sfxEnabled) return;
    AppLogger.debug('Playing SFX: $assetPath');
  }

  void setMusicEnabled(bool enabled) => _musicEnabled = enabled;
  void setSfxEnabled(bool enabled) => _sfxEnabled = enabled;
}
