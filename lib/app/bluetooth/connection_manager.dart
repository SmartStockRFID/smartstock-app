import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/domain/firmware/change_mode_command.dart';
import 'package:smart_stock/app/utils/logger.dart';

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
