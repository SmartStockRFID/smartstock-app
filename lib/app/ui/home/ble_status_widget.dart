import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_on_state.dart';
import 'package:smart_stock/app/bluetooth/checking_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connect_state.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/bluetooth/scan_state.dart';
import 'package:smart_stock/app/bluetooth/unsupported_state.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

class BleStatusWidget extends ConsumerWidget {
  const BleStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider);
    final currentState = bleState.currentState;

    return Builder(
      builder: (context) {
        // Determinar cor e texto baseado no estado atual
        late Color color;
        late String statusText;
        late IconData icon;

        if (currentState is BluetoothOffState) {
          color = Colors.red;
          statusText = 'Bluetooth Desligado';
          icon = FIcons.bluetoothOff;
        } else if (currentState is CheckingBleState) {
          color = Colors.orange;
          statusText = 'Verificando...';
          icon = FIcons.bluetooth;
        } else if (currentState is PermissionDeniedState) {
          color = Colors.red;
          statusText = 'Sem Permissão';
          icon = FIcons.bluetoothOff;
        } else if (currentState is ErrorState) {
          color = Colors.red;
          statusText = 'Erro';
          icon = FIcons.bluetoothOff;
        } else if (currentState is UnsupportedState) {
          color = Colors.black;
          statusText = 'Não Suportado';
          icon = FIcons.bluetoothOff;
        } else if (currentState is BluetoothOnState) {
          color = Colors.blue;
          statusText = 'Bluetooth Ligado';
          icon = FIcons.bluetooth;
        } else if (currentState is ScanState) {
          color = Colors.purple;
          statusText = 'Procurando...';
          icon = FIcons.bluetoothSearching;
        } else if (currentState is ConnectState) {
          color = Colors.orange;
          statusText = 'Conectando...';
          icon = FIcons.bluetoothConnected;
        } else if (currentState is ConnectedState) {
          color = Colors.green;
          statusText = 'Conectado';
          icon = FIcons.bluetoothConnected;
        } else {
          // Estado desconhecido
          color = Colors.grey;
          statusText = 'Estado: ${currentState.runtimeType}';
          icon = FIcons.circleQuestionMark;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 48.0, color: color),
                      const SizedBox(height: 16),
                      Text(
                        statusText,
                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8, width: 16),
                  ElevatedButton(
                    onPressed: () {
                      logger.d('${currentState.runtimeType}: $statusText');
                    },
                    child: const Text('Ver Estado'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
