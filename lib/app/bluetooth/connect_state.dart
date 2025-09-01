import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/connection_manager.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';

class ConnectState extends RetryState {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  ConnectState() : super(origin: ErrorOrigin.connect);

  @override
  Future<BleState> processState() async {
    final scanResult = connectionManager.lastScanResult;
    if (scanResult == null) {
      throw FSMException('ConnectState chamado sem scanResult!');
    }

    final device = scanResult.device;
    logger.d('Conectando ao dispositivo: ${device.name}');
    final promise = Completer<BleState>();

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off && !promise.isCompleted) {
        logger.w('Bluetooth foi desligado durante a conexão.');
        promise.complete(BluetoothOffState());
      } else if (state == BluetoothAdapterState.unauthorized &&
          !promise.isCompleted) {
        logger.e('Permissão de Bluetooth revogada enquanto estava conectado.');
        promise.complete(PermissionDeniedState());
      }
    });

    try {
      await device.connect(
        autoConnect: false,
        timeout: const Duration(seconds: 15),
      );
      if (device.isConnected && !promise.isCompleted) {
        logger.d('Dispositivo conectado com sucesso.');
        connectionManager.connectedPistol = device;
        promise.complete(ConnectedState(connectedPistol: device));
      }
    } catch (e) {
      logger.e('Falha ao conectar: $e');
      if (!promise.isCompleted) {
        // Let RetryState handle the error
        throw e;
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
