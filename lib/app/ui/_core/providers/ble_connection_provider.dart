import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/checking_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connection_manager.dart';
import 'package:smart_stock/app/bluetooth/fsm_manager.dart';
import 'package:smart_stock/app/config/env.dart';

part 'ble_connection_provider.g.dart';

final Guid rfidServiceUUID = Guid(Enviroment.rfidServiceUUID());

@Riverpod(keepAlive: true)
class BleConnection extends _$BleConnection {
  StreamSubscription<BleState>? _stateSubscription;
  BleFSM? _fsm;

  @override
  BleConnectionState build() {
    ref.onDispose(() {
      _stateSubscription?.cancel();
      _fsm?.dispose();
    });

    final initialState = _initState();

    return BleConnectionState(currentState: initialState);
  }

  void changeFsmState(BleState newState) {
    _fsm?.dispose();
    _stateSubscription?.cancel();
    state = state.copyWith(currentState: _initState(initialState: newState));
  }

  BleState _initState({BleState? initialState}) {
    _fsm = BleFSM();
    final manager = ConnectionManager();

    initialState = initialState ?? CheckingBleState(manager: manager);

    _fsm?.start(initialState);

    _stateSubscription = _fsm?.stateStream.listen((newState) {
      state = state.copyWith(currentState: newState);
    });

    return initialState;
  }
}

@immutable
class BleConnectionState {
  final BleState currentState;

  const BleConnectionState({required this.currentState});

  BleConnectionState copyWith({BleState? currentState}) {
    return BleConnectionState(currentState: currentState ?? this.currentState);
  }
}
