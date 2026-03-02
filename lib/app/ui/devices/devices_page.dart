import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/app_bar.dart';
import 'package:smart_stock/app/ui/_core/widgets/base_list_widget.dart';
import 'package:smart_stock/app/ui/devices/logic/connect_ble_mutation.dart';
import 'package:smart_stock/app/ui/shell/app_shell_page.dart';

final Guid rfidServiceUUID = Guid(Enviroment.rfidServiceUUID());

class DevicesList extends HookConsumerWidget with DevicesState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstPistol = onBuildConnectedPistol(ref);
    final devices = useState<List<BluetoothDevice>>(firstPistol != null ? [firstPistol] : []);
    final deviceConnectingId = useState<String?>(null);

    void startScanning() async {
      await FlutterBluePlus.stopScan();
      await FlutterBluePlus.startScan(
        withServices: [rfidServiceUUID],
        timeout: const Duration(seconds: 15),
      );
      FlutterBluePlus.onScanResults.listen((results) {
        for (final ScanResult result in results) {
          if (!devices.value.contains(result.device)) {
            devices.value = [...devices.value, result.device];
          }
        }
      });
    }

    useEffect(() {
      startScanning();
      return () {
        FlutterBluePlus.stopScan();
      };
    }, []);

    return BaseList(
      isLoading: false,
      emptyMessage: 'Nenhum leitor em alcance',
      data: devices.value,
      itemBuilder: (device) {
        final alreadyConnected = device.isConnected;
        return Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(3.0),
          child: Row(
            spacing: 10,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black87,
                child: SvgPicture.asset(Assets.scannerIcon, height: 24, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.platformName.isNotEmpty ? device.platformName : '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.theme.typography.base.copyWith(
                        fontWeight: FontWeight.w600,
                        color: alreadyConnected ? Colors.black54 : Colors.black,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      device.remoteId.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.theme.typography.base.copyWith(
                        fontWeight: FontWeight.w600,
                        color: alreadyConnected ? Colors.black54 : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              FButton(
                style: alreadyConnected || connectBleMutation(ref) is MutationPending
                    ? createDisabledButtonStyle(context)
                    : FButtonStyle.primary(),
                onPress: () async {
                  if (alreadyConnected) {
                    return;
                  }
                  deviceConnectingId.value = device.remoteId.toString();

                  await connectBleMutation.run(ref, connectBleRun(context, ref, pistol: device));

                  deviceConnectingId.value = null;
                },
                child:
                    connectBleState(ref) is MutationPending &&
                        deviceConnectingId.value == device.remoteId.toString()
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(height: 14, width: 14, child: CircularProgressIndicator()),
                      )
                    : Text(
                        alreadyConnected ? 'Em uso' : 'Conectar',
                        style: context.theme.typography.sm.copyWith(
                          color: alreadyConnected ? Colors.black87 : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
      heightPercentage: 0.8,
      widthPercentage: 1,
    );
  }
}

@RoutePage()
class DevicesPage extends HookConsumerWidget with DevicesState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: baseAppBar(title: 'Leitores'),
      backgroundColor: Colors.white,
      body: ToastRunner(child: DevicesList()),
    );
  }
}

mixin class DevicesState {
  MutationState connectBleState(WidgetRef ref) => ref.watch(connectBleMutation);
  BluetoothDevice? onBuildConnectedPistol(WidgetRef ref) =>
      ref.read(bleConnectionProvider.select((state) => state.currentState.manager.connectedPistol));
  BluetoothDevice? watchedConnectedPistol(WidgetRef ref) => ref.watch(
    bleConnectionProvider.select((state) => state.currentState.manager.connectedPistol),
  );
}
