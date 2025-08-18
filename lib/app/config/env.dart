import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_stock/app/config/exceptions.dart';

abstract final class Enviroment {
  static rfidServiceUUID() => dotenv.env['RFID_SERVICE_UUID'];
  static backendBaseURL() => dotenv.env['BACKEND_BASE_URL'];

  static void validate() {
    final List<String?> requiredEnvs = [rfidServiceUUID(), backendBaseURL()];
    for (String? env in requiredEnvs) {
      if (env == null) {
        throw InternalSystemException(
          "Please set all enviroments on .env.example!",
        );
      }
    }
  }
}
