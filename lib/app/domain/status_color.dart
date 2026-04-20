import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/checking_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connect_state.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/bluetooth/scan_state.dart';
import 'package:smart_stock/app/domain/stock.dart';

enum StatusColors {
  OK(Colors.green),
  LOADING(Colors.blue),
  OUTDATED(Colors.orange),
  ERROR(Colors.red),
  DEFAULT(Colors.grey);

  final Color color;
  const StatusColors(this.color);
}

Color getBleStatusColor(BleState? currentState) {
  if (currentState is ConnectedState) {
    return StatusColors.OK.color;
  }
  if (currentState is CheckingBleState ||
      currentState is ScanState ||
      currentState is ConnectState) {
    return StatusColors.LOADING.color;
  }
  if (currentState is BluetoothOffState ||
      currentState is PermissionDeniedState ||
      currentState is ErrorState) {
    return StatusColors.ERROR.color;
  }
  return StatusColors.DEFAULT.color;
}

Color getStockStatusColor(AsyncValue stockState, DateTime? updatedAt) {
  return stockState.when(
    data: (_) => updatedAt == null
        ? Colors.pinkAccent
        : (isStockFresh(updatedAt) ? StatusColors.OK.color : StatusColors.OUTDATED.color),
    error: (err, trace) => StatusColors.ERROR.color,
    loading: () => StatusColors.LOADING.color,
  );
}
