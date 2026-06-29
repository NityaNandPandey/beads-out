import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/helpers/progress_merge_helper.dart';
import '../models/player_progress.dart';
import '../models/settings_model.dart';
import '../repositories/firebase_repository.dart';
import '../repositories/game_repository.dart';
import '../repositories/progress_repository.dart';
import '../repositories/settings_repository.dart';
import '../services/ads_service.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';
import '../services/save_service.dart';
import '../services/vibration_service.dart';

// Services
final saveServiceProvider = Provider<SaveService>((ref) => SaveService());

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  final service = FirebaseService();
  ref.onDispose(() {});
  return service;
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.watch(firebaseServiceProvider));
});

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());
final vibrationServiceProvider =
    Provider<VibrationService>((ref) => VibrationService());
final adsServiceProvider = Provider<AdsService>((ref) => AdsService());
final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

// Repositories
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(saveServiceProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(saveServiceProvider));
});

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  return FirebaseRepository(ref.watch(firebaseServiceProvider));
});

// State
final playerProgressProvider =
    StateNotifierProvider<PlayerProgressNotifier, PlayerProgress>((ref) {
  return PlayerProgressNotifier(
    ref.watch(progressRepositoryProvider),
    ref.watch(firebaseRepositoryProvider),
    ref.watch(firebaseServiceProvider),
  );
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  return SettingsNotifier(
    ref.watch(settingsRepositoryProvider),
    ref.watch(firebaseRepositoryProvider),
    ref.watch(firebaseServiceProvider),
  );
});

class PlayerProgressNotifier extends StateNotifier<PlayerProgress> {
  PlayerProgressNotifier(
    this._repository,
    this._firebaseRepository,
    this._firebaseService,
  ) : super(const PlayerProgress()) {
    _load();
  }

  final ProgressRepository _repository;
  final FirebaseRepository _firebaseRepository;
  final FirebaseService _firebaseService;

  Future<void> _load() async {
    await _repository.load();
    state = _repository.progress;
  }

  Future<void> syncFromCloud() async {
    final uid = _firebaseService.userId;
    if (uid == null) return;

    final cloudProgress = await _firebaseRepository.fetchProgress(uid);
    if (cloudProgress == null) return;

    final merged = ProgressMergeHelper.merge(state, cloudProgress);
    state = merged;
    await _repository.save(merged);
  }

  Future<void> completeLevel(int levelNumber, int stars, int score) async {
    await _repository.completeLevel(levelNumber, stars, score);
    state = _repository.progress;
    await _syncToCloud();
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(hasCompletedOnboarding: true);
    await _repository.save(state);
    await _syncToCloud();
  }

  Future<void> _syncToCloud() async {
    final uid = _firebaseService.userId;
    if (uid == null) return;
    await _firebaseRepository.syncProgress(uid, state);
  }
}

class SettingsNotifier extends StateNotifier<SettingsModel> {
  SettingsNotifier(
    this._repository,
    this._firebaseRepository,
    this._firebaseService,
  ) : super(const SettingsModel()) {
    _load();
  }

  final SettingsRepository _repository;
  final FirebaseRepository _firebaseRepository;
  final FirebaseService _firebaseService;

  Future<void> _load() async {
    await _repository.load();
    state = _repository.settings;
  }

  Future<void> syncFromCloud() async {
    final uid = _firebaseService.userId;
    if (uid == null) return;

    final cloudSettings = await _firebaseRepository.fetchSettings(uid);
    if (cloudSettings == null) return;

    state = cloudSettings;
    await _repository.save(cloudSettings);
  }

  Future<void> updateSettings(SettingsModel settings) async {
    state = settings;
    await _repository.save(settings);

    final uid = _firebaseService.userId;
    if (uid != null) {
      await _firebaseRepository.syncSettings(uid, settings);
    }
  }
}
