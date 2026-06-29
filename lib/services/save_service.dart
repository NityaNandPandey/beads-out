import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/logger/app_logger.dart';

class SaveService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('SaveService initialized');
  }

  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }

  Future<void> saveMap(String key, Map<String, dynamic> value) async {
    await _prefs?.setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    final raw = _prefs?.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
