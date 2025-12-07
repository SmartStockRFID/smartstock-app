import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_stock/app/config/exceptions.dart';

// ignore: avoid_classes_with_only_static_members
abstract final class Enviroment {
  static String? backendBaseURL() => dotenv.env['BACKEND_BASE_URL'];
  static String? rfidCharacteristicUUID() => dotenv.env['RFID_CHARACTERISTIC_UUID'];
  static String? rfidServiceUUID() => dotenv.env['RFID_SERVICE_UUID'];
  static ThemeMode themeMode() {
    final theme = dotenv.env['THEME_MODE'];
    if (theme == 'newland') {
      return ThemeMode.NEWLAND;
    }
    return ThemeMode.APP;
  }

  static void validate() {
    final List<String?> requiredEnvs = [
      rfidServiceUUID(),
      backendBaseURL(),
      rfidCharacteristicUUID(),
    ];
    for (final String? env in requiredEnvs) {
      if (env == null) {
        throw const InternalSystemException('Please set all enviroments on .env.example!');
      }
    }
  }
}

enum ThemeMode { APP, NEWLAND }
