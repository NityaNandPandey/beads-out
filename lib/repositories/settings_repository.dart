import '../core/constants/app_constants.dart';
import '../models/settings_model.dart';
import '../services/save_service.dart';

class SettingsRepository {
  SettingsRepository(this._saveService);

  final SaveService _saveService;
  SettingsModel _settings = const SettingsModel();

  SettingsModel get settings => _settings;

  Future<void> load() async {
    final data = await _saveService.getMap(AppConstants.settingsKey);
    if (data != null) {
      _settings = SettingsModel.fromJson(data);
    }
  }

  Future<void> save(SettingsModel settings) async {
    _settings = settings;
    await _saveService.saveMap(AppConstants.settingsKey, settings.toJson());
  }
}
