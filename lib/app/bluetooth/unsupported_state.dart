import 'package:smart_stock/app/bluetooth/base_ble_state.dart';

class UnsupportedState extends NormalBleState {
  UnsupportedState({required super.manager});

  @override
  Future<BleState> processState() async {
    throw FSMException("UnsupportedState shouldn't be processed!");
  }
}
