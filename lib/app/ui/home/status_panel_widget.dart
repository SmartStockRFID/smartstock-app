import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/checking_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connect_state.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/bluetooth/scan_state.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/custom_card.dart';

class StatusPanelWidget extends ConsumerWidget {
  const StatusPanelWidget({super.key});

  // Função para mapear o estado do BLE para a UI
  ({IconData icon, Color color, String text}) _getBleStatus(BleState? currentState) {
    if (currentState is ConnectedState) {
      return (icon: FIcons.bluetoothConnected, color: Colors.green, text: 'Pistola Conectada');
    }
    if (currentState is CheckingBleState ||
        currentState is ScanState ||
        currentState is ConnectState) {
      return (icon: FIcons.bluetoothSearching, color: Colors.orange, text: 'Procurando Pistola...');
    }
    if (currentState is BluetoothOffState ||
        currentState is PermissionDeniedState ||
        currentState is ErrorState) {
      return (icon: FIcons.bluetoothOff, color: Colors.red, text: 'Atenção Necessária');
    }
    // Estado padrão/inicial
    return (icon: FIcons.bluetooth, color: Colors.grey, text: 'Verificando Bluetooth...');
  }

  // Função para mapear o estado do Backend para a UI
  ({IconData icon, Color color, String text}) _getStockStatus(AsyncValue stockState) {
    if (stockState.hasValue && !stockState.isLoading) {
      return (icon: FIcons.clipboardList, color: Colors.green, text: 'Estoque Sincronizado');
    }
    if (stockState.isLoading || stockState.isRefreshing) {
      return (icon: FIcons.clipboardList, color: Colors.orange, text: 'Sincronizando Estoque...');
    }
    if (stockState.hasError) {
      return (icon: FIcons.clipboardList, color: Colors.red, text: 'Erro de Sincronização');
    }
    return (icon: FIcons.clipboardList, color: Colors.grey, text: 'Aguardando Sincronia');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider);
    final stockState = ref.watch(stockProvider);
    final stockNotifier = ref.read(stockProvider.notifier);

    final bleStatus = _getBleStatus(bleState.currentState);
    final stockStatus = _getStockStatus(stockState);

    final typography = context.theme.typography;

    return CustomCard(
      title: Text(
              "Status da conexão",
              style: typography.base.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
      child: Column(
        children: [
          _StatusItem(color: bleStatus.color, icon: bleStatus.icon, text: bleStatus.text),
          const Divider(height: 24, thickness: 1, indent: 8, endIndent: 8),
          _StatusItem(color: stockStatus.color, icon: stockStatus.icon, text: stockStatus.text),
          const SizedBox(height: 20),
          FButton(
            style: FButtonStyle.primary(),
            onPress: stockState.isLoading || stockState.isRefreshing
                ? null
                : () => stockNotifier.refresh(),
            child: const Text('Sincronizar Novamente'),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({required this.color, required this.icon, required this.text});

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: typography.bodyLarge?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
