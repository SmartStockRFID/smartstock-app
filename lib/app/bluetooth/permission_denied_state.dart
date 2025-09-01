import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_on_state.dart';
import 'package:smart_stock/app/utils/logger.dart';

class PermissionDeniedState extends NormalBleState {
  StreamSubscription<BluetoothAdapterState>? btSubscription;

  @override
  Future<BleState> processState() async {
    logger.d('Processando PermissionDeniedState.');

    final promise = Completer<BluetoothAdapterState>();

    btSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on ||
          state == BluetoothAdapterState.off) {
        if (!promise.isCompleted) {
          logger.d(
            'Estado do adaptador definido para $state, completando a promise.',
          );
          promise.complete(state);
        }
      }
    });

    final finalState = await promise.future;

    await btSubscription?.cancel();
    btSubscription = null;

    // Decide which state to go to AFTER the await has finished
    if (finalState == BluetoothAdapterState.on) {
      logger.d('Promise completa, transicionando para BluetoothOnState.');
      return BluetoothOnState();
    } else {
      logger.d('Promise completa, transicionando para BluetoothOffState.');
      return BluetoothOffState();
    }
  }

  @override
  void dispose() {
    logger.d('Descartando PermissionDeniedState.');
    btSubscription?.cancel();
    btSubscription = null;
    super.dispose();
  }
}
