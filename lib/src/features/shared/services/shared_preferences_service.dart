import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

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

  // TODO: Add Wallet when created, or just use saveSetting?
  // when there are new wallets created,
  // add them to the visibility settings, default to true
  static Future<bool> addWalletVisibilitySettings(
      String walletId, bool visibility) async {
    final SharedPreferences prefs = await _prefs;
    final String visibilitySettingsString =
        prefs.getString('visibility_settings') ?? '{}';
    final Map<String, bool> visibilitySettings =
        Map<String, bool>.from(jsonDecode(visibilitySettingsString));
    visibilitySettings[walletId] = visibility;
    return prefs.setString(
        'visibility_settings', jsonEncode(visibilitySettings));
  }

  static Future<bool> deleteWalletVisibilitySettings() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove('visibility_settings');
  }

  SharedPreferencesService._();
}

// ? NOT USED