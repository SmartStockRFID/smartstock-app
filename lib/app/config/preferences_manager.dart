import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class PreferencesManager {
  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static const _currentUserKey = 'current_user';
  static const _currentUserSessionTimestampKey = 'current_user_timestamp';

  static Future<void> setCurrentUser(String username) async {
    final prefs = await getPrefs();

    await prefs.setString(_currentUserKey, username);
    await prefs.setString(_currentUserSessionTimestampKey, DateTime.now().toIso8601String());
  }

  static Future<void> deleteCurrentUser() async {
    final prefs = await getPrefs();

    await prefs.remove(_currentUserKey);
  }

  static Future<String?> getCurrentUser() async {
    final prefs = await getPrefs();

    final username = prefs.getString(_currentUserKey);

    return username;
  }

  static Future<DateTime?> getCurrentUserSessionTimestamp() async {
    final prefs = await getPrefs();

    final timestamp = prefs.getString(_currentUserSessionTimestampKey);

    if (timestamp == null) {
      return null;
    }

    return DateTime.parse(timestamp);
  }

  static const _savedLoginsKey = 'saved_logins';

  static Future<void> saveLogin(String username) async {
    final prefs = await getPrefs();

    final savedLogins = prefs.getStringList(_savedLoginsKey) ?? [];

    savedLogins.addOrUpdate(username);

    await prefs.setStringList(_savedLoginsKey, savedLogins);
  }

  static Future<List<String>?> getSavedLogins() async {
    final prefs = await getPrefs();

    final savedLogins = prefs.getStringList(_savedLoginsKey);

    return savedLogins;
  }

  static const _firstTimeOnTheApp = 'first_time_on_app';

  static Future<void> setNotFirstTimeOnTheApp() async {
    final prefs = await getPrefs();

    await prefs.setBool(_firstTimeOnTheApp, false);
  }

  static Future<bool> getFirstTimeOnTheApp() async {
    final prefs = await getPrefs();

    bool? firsrTime = prefs.getBool(_firstTimeOnTheApp);

    if (firsrTime == null) {
      firsrTime = true;
      await prefs.setBool(_firstTimeOnTheApp, firsrTime);
    }

    return firsrTime;
  }
}
