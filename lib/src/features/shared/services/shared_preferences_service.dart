import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> getAuthenticated() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('local_authentication') ?? false;
  }

  static Future<bool> saveAuthenticated(bool authenticated) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setBool('local_authentication', authenticated);
  }

  static Future<Map<String, bool>> getWalletVisibilitySettings() async {
    final SharedPreferences prefs = await _prefs;
    final String visibilitySettingsString =
        prefs.getString('visibility_settings') ?? '{}';
    return Map<String, bool>.from(jsonDecode(visibilitySettingsString));
  }

  static Future<bool> saveWalletVisibilitySettings(
      Map<String, bool> visibilitySettings) async {
    final SharedPreferences prefs = await _prefs;
    final String visibilitySettingsString = jsonEncode(visibilitySettings);
    return prefs.setString('visibility_settings', visibilitySettingsString);
  }

  SharedPreferencesService._();
}

// ? NOT USED