import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_on_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/bluetooth/unsupported_state.dart';
import 'package:smart_stock/app/utils/logger.dart';

class CheckingBleState extends NormalBleState {
  StreamSubscription<BluetoothAdapterState>? _btSubscription;

  CheckingBleState({required super.manager});
  @override
  Future<BleState> processState() async {
    if (await FlutterBluePlus.isSupported == false) {
      return UnsupportedState(manager: manager);
    }

    final currentState = FlutterBluePlus.adapterStateNow;

    switch (currentState) {
      case BluetoothAdapterState.on:
        return BluetoothOnState(manager: manager);
      case BluetoothAdapterState.off:
        return BluetoothOffState(manager: manager);
      case BluetoothAdapterState.unauthorized:
        return PermissionDeniedState(manager: manager);
      default:
        return _waitForNextState();
    }
  }

  Future<BleState> _waitForNextState() async {
    logger.d('Aguardando por um estado definitivo do Bluetooth...');
    final promise = Completer<BluetoothAdapterState>();

    _btSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (!promise.isCompleted) {
        switch (state) {
          case BluetoothAdapterState.on:
          case BluetoothAdapterState.off:
          case BluetoothAdapterState.unauthorized:
            logger.d('Estado do adaptador definido para $state, completando a promise.');
            promise.complete(state);
            break;
          default:
            break;
        }
      }
    });

    final finalState = await promise.future;
    await _btSubscription?.cancel();
    _btSubscription = null;

    logger.d('Promise completa, decidindo para qual estado ir.');
    switch (finalState) {
      case BluetoothAdapterState.on:
        return BluetoothOnState(manager: manager);
      case BluetoothAdapterState.off:
        return BluetoothOffState(manager: manager);
      case BluetoothAdapterState.unauthorized:
        return PermissionDeniedState(manager: manager);
      default:
        // Fallback, but should'nt happen
        return ErrorState(previousState: ErrorOrigin.scan, manager: manager);
    }
  }

  @override
  void dispose() {
    _btSubscription?.cancel();
    _btSubscription = null;
    super.dispose();
  }
}
