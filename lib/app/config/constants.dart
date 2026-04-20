// ignore_for_file: avoid_classes_with_only_static_members

import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';

const String emptyTagOEM = '';

abstract final class AppConfig {
  static final useNewlandTheme = Enviroment.themeMode() == ThemeMode.NEWLAND;
  static Future<String> getBackUrl() async {
    return await BackendApiUrlStorage.getValue() ?? Enviroment.backendBaseURL();
  }
}
