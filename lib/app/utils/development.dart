//For development, only
import 'package:flutter/foundation.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';

Future<void> clearSharedPreferences() async {
  if (!kDebugMode) {
    return;
  }

  await CurrentUserStorage.deleteValue();
  await TokenStorage.deleteTokens();
  await FirstTimeOnAppStorage.$deleteValue();
  await SavedLoginsStorage.$deleteValues();
  await CurrentSessionTimestampProvider.$deleteValue();
}
