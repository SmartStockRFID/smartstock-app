import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/scan_state.dart';

class BluetoothOnState extends NormalBleState {
  BluetoothOnState({required super.manager});

  @override
  Future<BleState> processState() async {
    return ScanState(manager: manager);
  }
}
