import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_on_state.dart';
import 'package:smart_stock/app/utils/logger.dart';

class BluetoothOffState extends NormalBleState {
  StreamSubscription<BluetoothAdapterState>? _btSubscription;

  BluetoothOffState({required super.manager});

  @override
  Future<BleState> processState() async {
    bool userRejected = false;
    logger.d('Iniciando processamento do BluetoothOffState.');

    if (!kIsWeb && Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        if (e.toString().contains('user rejected')) {
          userRejected = true;
        }
      }
    }

    if (userRejected) {
      logger.w('Por favor, ative o Bluetooth manualmente.');
    }

    final promise = Completer<void>();

    _btSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        if (!promise.isCompleted) {
          logger.d('Bluetooth foi ligado, completando a promise.');
          promise.complete();
        }
      }
    });

    await promise.future;

    await _btSubscription?.cancel();
    _btSubscription = null;

    logger.d('Promise completa, transicionando para BluetoothOnState.');
    return BluetoothOnState(manager: manager);
  }

  @override
  void dispose() {
    logger.d('Descartando BluetoothOffState.');
    _btSubscription?.cancel();
    _btSubscription = null;
    super.dispose();
  }
}
