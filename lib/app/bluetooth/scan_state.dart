import 'dart:async';
import 'package:flutter/services.dart'; // Importe para usar PlatformException
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/connect_state.dart';
import 'package:smart_stock/app/bluetooth/connection_manager.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/config/env.dart';

final Guid rfidServiceUUID = Guid(Enviroment.rfidServiceUUID());

class ScanState extends RetryState {
  StreamSubscription? _scanSubscription;
  StreamSubscription? _adapterStateSubscription;

  ScanState() : super(origin: ErrorOrigin.scan);

  @override
  Future<BleState> processState() async {
    logger.d('Starting BLE scan');

    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    final promise = Completer<BleState>();

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off && !promise.isCompleted) {
        logger.w('Bluetooth foi desligado durante o scan.');
        promise.complete(BluetoothOffState());
      } else if (state == BluetoothAdapterState.unauthorized &&
          !promise.isCompleted) {
        logger.e('Permissão de Bluetooth revogada durante o scan.');
        promise.complete(PermissionDeniedState());
      }
    });

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty && !promise.isCompleted) {
        final scannedPistol = results.first;
        logger.d('Dispositivo encontrado: ${scannedPistol.device.name}');
        connectionManager.lastScanResult = scannedPistol;
        promise.complete(ConnectState());
      }
    });

    try {
      await FlutterBluePlus.startScan(
        withServices: [rfidServiceUUID],
        timeout: const Duration(seconds: 15),
      );

      final nextState = await promise.future.timeout(
        const Duration(seconds: 16),
        onTimeout: () {
          logger.w('Scan timeout - nenhum dispositivo encontrado.');
          return ErrorState(previousState: ErrorOrigin.scan);
        },
      );

      return nextState;
    } on PlatformException catch (e) {
      if (e.message?.contains('Bluetooth must be turned on') ?? false) {
        logger.e(
          'Scan falhou pois o Bluetooth não está pronto. Indo para BluetoothOffState.',
        );
        return BluetoothOffState();
      }
      rethrow;
    } catch (e) {
      logger.e('Erro ao iniciar o scan: $e');
      rethrow;
    } finally {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
      await _scanSubscription?.cancel();
      await _adapterStateSubscription?.cancel();
    }
  }

  @override
  void dispose() {
    logger.d('Disposing ScanState');
    _scanSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    super.dispose();
  }
}
