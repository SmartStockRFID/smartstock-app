// ignore_for_file: avoid_classes_with_only_static_members, prefer_function_declarations_over_variables

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef GetPref<T> = Future<T> Function();
typedef SetPref<T> = Future<void> Function(T value);
typedef VoidSetPref = Future<void> Function();
typedef DeletePref = Future<void> Function();

Future<SharedPreferences> getPrefs() async {
  return await SharedPreferences.getInstance();
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

class SavedLoginsStorage {
  static const _savedLoginsKey = 'saved_logins';

  static final SetPref<String> saveValue = (String username) async {
    final prefs = await getPrefs();

    final savedLogins = prefs.getStringList(_savedLoginsKey) ?? [];

    savedLogins.addOrUpdate(username);

    await prefs.setStringList(_savedLoginsKey, savedLogins);
  };

  static final GetPref<List<String>?> getValues = () async {
    final prefs = await getPrefs();

    final savedLogins = prefs.getStringList(_savedLoginsKey);

    return savedLogins;
  };

  // For development, only
  static final DeletePref $deleteValues = () async {
    if (!kDebugMode) {
      return;
    }

    final prefs = await getPrefs();

    await prefs.remove(_savedLoginsKey);
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

    bool? firsrTime = prefs.getBool(_firstTimeOnTheApp);

    if (firsrTime == null) {
      firsrTime = true;
      await prefs.setBool(_firstTimeOnTheApp, firsrTime);
    }

    return firsrTime;
  };

  // For development, only
  static final DeletePref $deleteValue = () async {
    if (!kDebugMode) {
      return;
    }

    final prefs = await getPrefs();

    await prefs.remove(_firstTimeOnTheApp);
  };
}

class CurrentSessionTimestampProvider {
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

  // For development, only
  static final DeletePref $deleteValue = () async {
    if (!kDebugMode) {
      return;
    }

    final prefs = await getPrefs();

    await prefs.remove(_currentUserSessionTimestampKey);
  };
}
