import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connection_manager.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';

final connectBleMutation = Mutation<void>();

Future<void> Function(MutationTransaction tsx) connectBleRun(
  BuildContext context,
  WidgetRef ref, {
  required BluetoothDevice pistol,
}) {
  return (tsx) async {
    FlutterBluePlus.connectedDevices.toList().forEach((device) async => device.disconnect());
    // await ref
    //     .read(bleConnectionProvider.select((state) => state.manager))
    //     .connectedPistol
    //     ?.disconnect();
    // ref
    //     .read(bleConnectionProvider.select((state) => state.fsm))
    //     .start(ConnectState(manager: ConnectionManager(lastScannedDevice: device)));

    await pistol.connect(timeout: const Duration(seconds: 8));

    if (!pistol.isConnected && context.mounted) {
      showFToast(
        context: context,
        title: const Text('Erro ao se conectar com o leitor', style: TextStyle(color: Colors.red)),
        icon: const Icon(FIcons.circleX, color: Colors.red),
      );
    }
    ref
        .read(bleConnectionProvider.notifier)
        .changeFsmState(
          ConnectedState(
            connectedPistol: pistol,
            manager: ConnectionManager(lastScannedDevice: pistol, connectedPistol: pistol),
          ),
        );
  };
}
