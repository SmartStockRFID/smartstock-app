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
import 'package:smart_stock/app/ui/shared/update_stock_btn.dart';

class StatusPanelWidget extends ConsumerWidget {
  const StatusPanelWidget({super.key});

  // Função para mapear o estado do BLE para a UI
  ({IconData icon, Color color, String text}) _getBleStatus(BleState? currentState) {
    if (currentState is ConnectedState) {
      return (icon: FIcons.bluetoothConnected, color: Colors.green, text: 'Pistola');
    }
    if (currentState is CheckingBleState ||
        currentState is ScanState ||
        currentState is ConnectState) {
      return (icon: FIcons.bluetoothSearching, color: Colors.orange, text: 'Pistola');
    }
    if (currentState is BluetoothOffState ||
        currentState is PermissionDeniedState ||
        currentState is ErrorState) {
      return (icon: FIcons.bluetoothOff, color: Colors.red, text: 'Pistola');
    }
    // Estado padrão/inicial
    return (icon: FIcons.bluetooth, color: Colors.grey, text: 'Pistola');
  }

  // Função para mapear o estado do Backend para a UI
  ({IconData icon, Color color, String text}) _getStockStatus(AsyncValue stockState) {
    if (stockState.hasValue && !stockState.isLoading) {
      return (icon: FIcons.clipboardList, color: Colors.green, text: 'Estoque');
    }
    if (stockState.isLoading || stockState.isRefreshing) {
      return (icon: FIcons.clipboardList, color: Colors.orange, text: 'Estoque');
    }
    if (stockState.hasError) {
      return (icon: FIcons.clipboardList, color: Colors.red, text: 'Estoque');
    }
    return (icon: FIcons.clipboardList, color: Colors.grey, text: 'Estoque');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider);
    final stockState = ref.watch(stockProvider);

    final bleStatus = _getBleStatus(bleState.currentState);
    final stockStatus = _getStockStatus(stockState);

    final typography = context.theme.typography;

    return CustomCard(
      title: Text(
        'Status da conexão',
        style: typography.base.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusItem(color: bleStatus.color, icon: bleStatus.icon, text: bleStatus.text),
              const VerticalDivider(
                thickness: 1,
                indent: 8,
                endIndent: 8,
                width: 12,
                color: Colors.black,
              ),
              _StatusItem(color: stockStatus.color, icon: stockStatus.icon, text: stockStatus.text),
            ],
          ),
          const SizedBox(height: 20),
          UpdateStockButton(),
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
        Text(
          text,
          style: typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey),
        ),
      ],
    );
  }
}
