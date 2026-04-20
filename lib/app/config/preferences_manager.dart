// ignore_for_file: avoid_classes_with_only_static_members, prefer_function_declarations_over_variables

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getPrefs() async {
  return SharedPreferences.getInstance();
}

typedef DeletePref = Future<void> Function();
typedef GetPref<T> = Future<T> Function();
typedef SetPref<T> = Future<void> Function(T value);
typedef VoidSetPref = Future<void> Function();

class BackendApiUrlStorage {
  static const _backendApiUrlKey = 'backend_api_url';

  static final GetPref<String?> getValue = () async {
    final prefs = await getPrefs();

    return prefs.getString(_backendApiUrlKey);
  };

  static final SetPref<String> setValue = (url) async {
    final prefs = await getPrefs();

    await prefs.setString(_backendApiUrlKey, url);
  };
}

class CurrentSessionTimestampStorage {
  static const _currentUserSessionTimestampKey = 'current_user_timestamp';

  static final GetPref<DateTime?> getValue = () async {
    final prefs = await getPrefs();

    final timestamp = prefs.getString(_currentUserSessionTimestampKey);

    if (timestamp == null) {
      return null;
    }

    return DateTime.parse(timestamp);
  };

  static final VoidSetPref setValue = () async {
    final prefs = await getPrefs();

    await prefs.setString(_currentUserSessionTimestampKey, DateTime.now().toIso8601String());
  };
}

class CurrentUserStorage {
  static const _currentUserKey = 'current_user';

  static final GetPref<String?> getValue = () async {
    final prefs = await getPrefs();

    return prefs.getString(_currentUserKey);
  };

  static final SetPref<String> setValue = (username) async {
    final prefs = await getPrefs();

    await prefs.setString(_currentUserKey, username);
  };

  static final DeletePref deleteValue = () async {
    final prefs = await getPrefs();

    await prefs.remove(_currentUserKey);
  };
}

class FirmwareUpdateUrlStorage {
  static const _firmwareUpdateUrlKey = 'firmware_update_url';

  static final GetPref<String?> getValue = () async {
    final prefs = await getPrefs();

    return prefs.getString(_firmwareUpdateUrlKey);
  };

  static final SetPref<String> setValue = (url) async {
    final prefs = await getPrefs();

    await prefs.setString(_firmwareUpdateUrlKey, url);
  };
}

class FirstTimeOnAppStorage {
  static const _firstTimeOnTheApp = 'first_time_on_app';

  static final VoidSetPref setNegative = () async {
    final prefs = await getPrefs();

    await prefs.setBool(_firstTimeOnTheApp, false);
  };

  static final GetPref getValue = () async {
    final prefs = await getPrefs();

    bool? firstTime = prefs.getBool(_firstTimeOnTheApp);

    if (firstTime == null) {
      firstTime = true;
      await prefs.setBool(_firstTimeOnTheApp, firstTime);
    }

    return firstTime;
  };
}

class SavedLoginsStorage {
  static const _savedLoginsKey = 'saved_logins';

  static final GetPref<List<String>?> getValues = () async {
    final prefs = await getPrefs();

    final savedLogins = prefs.getStringList(_savedLoginsKey);

    return savedLogins;
  };

  static final SetPref<String> saveValue = (String username) async {
    final prefs = await getPrefs();

    final savedLogins = prefs.getStringList(_savedLoginsKey) ?? [];

    savedLogins.addOrUpdate(username);

    await prefs.setStringList(_savedLoginsKey, savedLogins);
  };
}
