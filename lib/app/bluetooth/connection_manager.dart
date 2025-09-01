import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/utils/logger.dart';

class ConnectionManager {
  BluetoothDevice? connectedPistol;
  ScanResult? lastScanResult;

  void dispose() {
    connectedPistol?.disconnect().catchError(
      (e) => logger.w('Error disconnecting: $e'),
    );
    connectedPistol = null;
    lastScanResult = null;
  }

  bool get isConnected => connectedPistol != null;

  String? get connectedDeviceName => connectedPistol?.name;
}

final connectionManager = ConnectionManager();
