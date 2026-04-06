import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_stock/app/config/exceptions.dart';

// ignore: avoid_classes_with_only_static_members
abstract final class Enviroment {
  static String backendBaseURL() => dotenv.env['BACKEND_BASE_URL']!;
  static String firmwareUpdateListURL() => dotenv.env['FIRMWARE_UPDATE_LIST_URL']!;
  static String firmwareVersionCharacteristicUUID() =>
      dotenv.env['FIRMWARE_VERSION_CHARACTERISTIC_UUID']!;
  static String rfidCharacteristicUUID() => dotenv.env['RFID_CHARACTERISTIC_UUID']!;
  static String rfidServiceUUID() => dotenv.env['RFID_SERVICE_UUID']!;
  static ThemeMode themeMode() {
    final theme = dotenv.env['THEME_MODE'];
    if (theme == 'newland') {
      return ThemeMode.NEWLAND;
    }
    return ThemeMode.APP;
  }

  static void validate() {
    final List<String?> requiredEnvs = [
      backendBaseURL(),
      firmwareUpdateListURL(),
      firmwareVersionCharacteristicUUID(),
      rfidCharacteristicUUID(),
      rfidServiceUUID(),
    ];
    for (final String? env in requiredEnvs) {
      if (env == null) {
        throw const InternalSystemException('Please set all enviroments on .env.example!');
      }
    }
    if (Uri.tryParse(backendBaseURL())?.host.isEmpty ?? true) {
      throw const InternalSystemException('BACKEND_BASE_URL should be a valid URL!');
    }
  }
}

enum ThemeMode { APP, NEWLAND }
