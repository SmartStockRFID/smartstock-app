import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connect_state.dart';
import 'package:smart_stock/app/bluetooth/scan_state.dart';

enum ErrorOrigin { scan, connect, connected }

class ErrorState extends NormalBleState {
  final ErrorOrigin previousState;

  ErrorState({required this.previousState, required super.manager});

  @override
  Future<BleState> processState() async {
    switch (previousState) {
      case ErrorOrigin.scan:
        return ScanState(manager: manager);
      case ErrorOrigin.connect:
      case ErrorOrigin.connected:
        return ConnectState(manager: manager);
    }
  }
}
