import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ota/ota_package.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/domain/firmware/change_mode_command.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:version/version.dart';

final Guid firmwareVersionCharacteristicUUID = Guid(
  Enviroment.firmwareVersionCharacteristicUUID(),
);
final Guid rfidCharacteristicUUID = Guid(Enviroment.rfidCharacteristicUUID());
final Guid rfidServiceUUID = Guid(Enviroment.rfidServiceUUID());

class ConnectionManager {
  BluetoothDevice? connectedPistol;
  BluetoothDevice? lastScannedDevice;
  Stream<int>? otaProgress;

  final _rfidDataController = StreamController<String>.broadcast();

  ConnectionManager({this.lastScannedDevice, this.connectedPistol});
  String? get connectedDeviceName => connectedPistol?.platformName;

  bool get isConnected => connectedPistol != null;

  Stream<String> get rfidDataStream => _rfidDataController.stream;

  void dispose() {
    connectedPistol?.disconnect().catchError((e) => logger.w('Error disconnecting: $e'));
    otaProgress = null;
    connectedPistol = null;
    lastScannedDevice = null;
  }

  Future<void> enterOnReadMode() async {
    if (connectedPistol == null) {
      return;
    }
    logger.d('Trying to enter on ReadMOde on ConnectionManager!');
    final List<BluetoothService> services = await connectedPistol!.discoverServices();

    final rfidService = services.singleWhere((service) => service.uuid == rfidServiceUUID);
    final rfidCharacteristic = rfidService.characteristics.singleWhere(
      (characteristic) =>
          characteristic.uuid == rfidCharacteristicUUID && characteristic.properties.write,
    );

    bool success = false;
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        await rfidCharacteristic.write(
          jsonEncode(ChangeOperationModeCommand.read).codeUnits,
          withoutResponse: false,
        );
        logger.d('Change mode to Read successfully');
        success = true;
        break;
      } catch (e) {
        logger.e('Write to ReadMOde failed (attempt $attempt/3): $e');
      }
    }
    if (!success) {
      throw Exception('Failed to enter on mode ReadData. Please try again.');
    }
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Future<Version?> getCurrentVersion() async {
    if (connectedPistol == null) {
      return null;
    }

    logger.d('Trying to read Version');

    try {
      final List<BluetoothService> services = await connectedPistol!.discoverServices();

      final rfidService = services.singleWhere((service) => service.uuid == rfidServiceUUID);
      final versionCharacteristic = rfidService.characteristics.singleWhere(
        (characteristic) =>
            characteristic.uuid == firmwareVersionCharacteristicUUID &&
            characteristic.properties.read,
      );

      for (int attempt = 1; attempt <= 3; attempt++) {
        try {
          final versionStr = utf8.decode(await versionCharacteristic.read());
          final version = Version.parse(versionStr);

          await Future.delayed(const Duration(milliseconds: 50));

          return version;
        } catch (e) {
          logger.e('Write failed (attempt $attempt/3): $e');
        }
      }
      throw Exception('Failed to transfer data. Please try again.');
    } catch (e) {
      logger.e('Failed to read characteristic: $e');
    }

    return null;
  }

  Future<void> readCharacteristic() async {
    logger.i('Trying to readCharacteristic');

    if (connectedPistol == null) {
      return;
    }

    final List<BluetoothService> services = await connectedPistol?.discoverServices() ?? [];

    final rfidService = services.singleWhere((service) => service.uuid == rfidServiceUUID);
    final rfidCharacteristic = rfidService.characteristics.singleWhere(
      (characteristic) =>
          characteristic.uuid == rfidCharacteristicUUID && characteristic.properties.notify,
    );

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        await rfidCharacteristic.setNotifyValue(
          true,
        ); // TODO: Adicionar forceIndications deu bug, mas era o correto a se fazer
        rfidCharacteristic.onValueReceived.listen((value) {
          final data = utf8.decode(value);
          _rfidDataController.add(data);
          logger.d('Data read successfully: $data');
        });

        await Future.delayed(const Duration(milliseconds: 50));
        return;
      } catch (e) {
        logger.e('Write failed (attempt $attempt/3): $e');
      }
    }

    throw const BleException('Failed to readCharacteristic. Please try again.');
  }

  Future<void> upgrade(Uri url) async {
    logger.i('Trying to upgrade vei');

    if (connectedPistol == null) {
      return;
    }
    logger.i('Inicnado');

    final List<BluetoothService> services = await connectedPistol?.discoverServices() ?? [];
    final otaService = services.singleWhere((service) => service.uuid == Guid(OtaUuids.service));
    final writeChar = otaService.characteristics.singleWhere(
      (char) =>
          char.uuid == Guid(OtaUuids.rxCharacteristic) && char.properties.writeWithoutResponse,
    );
    final notifyChar = otaService.characteristics.singleWhere(
      (char) => char.uuid == Guid(OtaUuids.txCharacteristic) && char.properties.notify,
    );

    logger.i('Achei tudo q eu queria no leitor');

    final otaPackage = Esp32OtaPackage(notifyChar, writeChar);
    logger.i('Ceomcando update...');

    otaProgress = otaPackage.percentageStream;

    try {
      await otaPackage.updateFirmware(
        connectedPistol!,
        2, // Arduino based
        3, //Send firmwareType = 3 for url
        otaService,
        notifyChar,
        writeChar,
        url: url.toString(),
      );
    } catch (err) {
      logger.e(err);
      rethrow;
    }

    logger.i('Terimou update...');

    if (otaPackage.firmwareUpdate) {
      // Firmware update was successful

      logger.i('Firmware update was successful');
    } else {
      // Firmware update failed
      logger.e('Firmware update failed');
    }
  }

  Future<void> writeCharacteristic(String productOEM) async {
    if (connectedPistol == null) {
      return;
    }
    logger.d('Trying to writeData on ConnectionManager!');
    final List<BluetoothService> services = await connectedPistol!.discoverServices();

    final rfidService = services.singleWhere((service) => service.uuid == rfidServiceUUID);
    final rfidCharacteristic = rfidService.characteristics.singleWhere(
      (characteristic) =>
          characteristic.uuid == rfidCharacteristicUUID && characteristic.properties.write,
    );

    bool success = false;
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        await rfidCharacteristic.write(
          jsonEncode(ChangeOperationModeCommand.write).codeUnits,
          withoutResponse: false,
        );
        logger.d('Change mode written successfully');

        final writeData = {'type': 'writeData', 'content': productOEM};
        await rfidCharacteristic.write(jsonEncode(writeData).codeUnits, withoutResponse: false);
        logger.d('Command written successfully: $writeData');
        success = true;
        break;
      } catch (e) {
        logger.e('Write failed (attempt $attempt/3): $e');
      }
    }
    if (!success) {
      throw const BleException('Failed to write data. Please try again.');
    }

    await Future.delayed(const Duration(milliseconds: 50));
  }
}

class OtaUuids {
  static const String service = 'fb1e4001-54ae-4a28-9f74-dfccb248601d';
  static const String rxCharacteristic = 'fb1e4002-54ae-4a28-9f74-dfccb248601d'; // Escrita (Write)
  static const String txCharacteristic =
      'fb1e4003-54ae-4a28-9f74-dfccb248601d'; // Notificação (Notify)
}
