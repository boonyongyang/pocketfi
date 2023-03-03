import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<Map<String, bool>> getVisibilitySettings() async {
    final SharedPreferences prefs = await _prefs;
    final String visibilitySettingsString =
        prefs.getString('visibility_settings') ?? '{}';
    return Map<String, bool>.from(jsonDecode(visibilitySettingsString));
  }

  static Future<bool> saveVisibilitySettings(
      Map<String, bool> visibilitySettings) async {
    final SharedPreferences prefs = await _prefs;
    final String visibilitySettingsString = jsonEncode(visibilitySettings);
    return prefs.setString('visibility_settings', visibilitySettingsString);
  }

  static Future<bool> deleteVisibilitySettings() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove('visibility_settings');
  }
}

// ? NOT USED 