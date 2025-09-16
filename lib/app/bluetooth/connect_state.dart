import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/utils/logger.dart';

class ConnectState extends RetryState {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  ConnectState({required super.manager}) : super(origin: ErrorOrigin.connect);

  @override
  Future<BleState> processState() async {
    final scanResult = manager.lastScanResult;
    if (scanResult == null) {
      throw FSMException('ConnectState chamado sem scanResult!');
    }

    final device = scanResult.device;
    logger.d('Conectando ao dispositivo: ${device.name}');
    final promise = Completer<BleState>();

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off && !promise.isCompleted) {
        logger.w('Bluetooth foi desligado durante a conexão.');
        promise.complete(BluetoothOffState(manager: manager));
      } else if (state == BluetoothAdapterState.unauthorized && !promise.isCompleted) {
        logger.e('Permissão de Bluetooth revogada enquanto estava conectado.');
        promise.complete(PermissionDeniedState(manager: manager));
      }
    });

    try {
      await device.connect(autoConnect: false, timeout: const Duration(seconds: 15));
      if (device.isConnected && !promise.isCompleted) {
        logger.d('Dispositivo conectado com sucesso.');
        manager.connectedPistol = device;
        promise.complete(ConnectedState(connectedPistol: device, manager: manager));
      }
    } catch (e) {
      logger.e('Falha ao conectar: $e');
      if (!promise.isCompleted) {
        // Let RetryState handle the error
        rethrow;
      }
    } finally {
      await _adapterStateSubscription?.cancel();
    }

    return promise.future;
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    super.dispose();
  }
}
