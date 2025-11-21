import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/domain/firmware/change_mode_command.dart';
import 'package:smart_stock/app/utils/logger.dart';

final Guid rfidCharacteristicUUID = Guid(Enviroment.rfidCharacteristicUUID()!);

class ConnectionManager {
  BluetoothDevice? connectedPistol;
  ScanResult? lastScanResult;
  BluetoothCharacteristic? _targetCharacteristic;

  final _rfidDataController = StreamController<String>.broadcast();
  Stream<String> get rfidDataStream => _rfidDataController.stream;

  void dispose() {
    connectedPistol?.disconnect().catchError((e) => logger.w('Error disconnecting: $e'));
    connectedPistol = null;
    lastScanResult = null;
  }

  bool get isConnected => connectedPistol != null;

  String? get connectedDeviceName => connectedPistol?.name;

  Future<void> readCharacteristic() async {
    if (connectedPistol == null) {
      return;
    }
    logger.d('Trying to readData');
    try {
      final List<BluetoothService> services = await connectedPistol!.discoverServices();
      for (final BluetoothService service in services) {
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == rfidCharacteristicUUID && characteristic.properties.notify) {
            bool success = false;
            for (int attempt = 1; attempt <= 3; attempt++) {
              try {
                _targetCharacteristic = characteristic;
                await characteristic.setNotifyValue(true);
                characteristic.onValueReceived.listen((value) {
                  final data = utf8.decode(value);
                  _rfidDataController.add(data);
                  logger.d('Data read successfully: $data');
                });
                success = true;
                break;
              } catch (e) {
                logger.e('Write failed (attempt $attempt/3): $e');
              }
            }
            if (!success) {
              throw Exception('Failed to transfer data. Please try again.');
            }
            await Future.delayed(const Duration(milliseconds: 50));
          }
        }
      }
    } catch (e) {
      logger.e('Failed to read characteristic: $e');
      throw Exception('Failed to read data from pistol. Please try again.');
    }
  }

  Future<void> enterOnReadMode() async {
    if (connectedPistol == null) {
      return;
    }
    logger.d('Trying to enter on ReadMOde on ConnectionManager!');
    try {
      final List<BluetoothService> services = await connectedPistol!.discoverServices();
      for (final BluetoothService service in services) {
        for (final BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid == rfidCharacteristicUUID && characteristic.properties.write) {
            bool success = false;
            for (int attempt = 1; attempt <= 3; attempt++) {
              try {
                await characteristic.write(
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
        }
      }
    } catch (e) {}
  }

  Future<void> writeCharacteristic(BluetoothDevice? connectedPistol, String productOEM) async {
    if (connectedPistol == null) {
      return;
    }
    logger.d('Trying to writeData on ConnectionManager!');
    try {
      final List<BluetoothService> services = await connectedPistol.discoverServices();
      for (final BluetoothService service in services) {
        for (final BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid == rfidCharacteristicUUID && characteristic.properties.write) {
            bool success = false;
            for (int attempt = 1; attempt <= 3; attempt++) {
              try {
                await characteristic.write(
                  jsonEncode(ChangeOperationModeCommand.write).codeUnits,
                  withoutResponse: false,
                );
                logger.d('Change mode written successfully');

                final writeData = {'type': 'writeData', 'content': productOEM};
                await characteristic.write(jsonEncode(writeData).codeUnits, withoutResponse: false);
                logger.d('Command written successfully: $writeData');
                success = true;
                break;
              } catch (e) {
                logger.e('Write failed (attempt $attempt/3): $e');
              }
            }
            if (!success) {
              throw Exception('Failed to write data. Please try again.');
            }
            await Future.delayed(const Duration(milliseconds: 50));
          }
        }
      }
    } catch (e) {}
  }
}
