import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/checking_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connection_manager.dart';
import 'package:smart_stock/app/bluetooth/fsm_manager.dart';
import 'package:smart_stock/app/config/env.dart';

part 'ble_connection_provider.g.dart';

final Guid rfidServiceUUID = Guid(Enviroment.rfidServiceUUID()!);

class BleConnectionState {
  final BleFSM fsm;
  final BleState currentState;
  final ConnectionManager manager;

  BleConnectionState({required this.fsm, required this.currentState, required this.manager});

  BleConnectionState copyWith({BleState? currentState}) {
    return BleConnectionState(
      fsm: fsm,
      currentState: currentState ?? this.currentState,
      manager: manager,
    );
  }
}

@Riverpod(keepAlive: true)
class BleConnection extends _$BleConnection {
  StreamSubscription<BleState>? _stateSubscription;
  bool _disposed = false;

  @override
  BleConnectionState build() {
    final fsm = BleFSM();
    final manager = ConnectionManager();
    final initialState = CheckingBleState(manager: manager);

    _stateSubscription = fsm.stateStream.listen((newState) {
      if (!_disposed) {
        state = state.copyWith(currentState: newState);
      }
    });

    fsm.start(initialState);

    ref.onDispose(() {
      _disposed = true;
      _stateSubscription?.cancel();
      fsm.dispose();
    });

    return BleConnectionState(fsm: fsm, currentState: initialState, manager: manager);
  }
}
