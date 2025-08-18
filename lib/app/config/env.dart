import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_stock/app/config/exceptions.dart';

abstract final class Enviroment {
  static rfidServiceUUID() => dotenv.env['RFID_SERVICE_UUID'];

  static void validate() {
    final List<String?> envs = [rfidServiceUUID()];
    for (String? env in envs) {
      if (env == null) {
        throw InternalSystemException(
          "Please set all enviroments on .env.example!",
        );
      }
    }
  }
}
