import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/checking_ble_state.dart';
import 'package:smart_stock/app/bluetooth/connect_state.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/bluetooth/scan_state.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/domain/stock.dart';
import 'package:smart_stock/app/ui/_providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_shared/custom_card.dart';
import 'package:smart_stock/app/ui/_shared/update_stock_btn.dart';

enum StatusColors {
  OK(Colors.green),
  LOADING(Colors.blue),
  OUTDATED(Colors.orange),
  ERROR(Colors.red),
  DEFAULT(Colors.grey);

  final Color color;
  const StatusColors(this.color);
}

class StatusPanelWidget extends ConsumerWidget {
  const StatusPanelWidget({super.key});

  Color _getBleStatusColor(BleState? currentState) {
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

  // Função para mapear o estado do Backend para a UI
  Color _getStockStatusColor(AsyncValue stockState, DateTime? updatedAt) {
    return stockState.when(
      data: (_) => updatedAt == null
          ? Colors.pinkAccent
          : (isStockFresh(updatedAt!) ? StatusColors.OK.color : StatusColors.OUTDATED.color),
      error: (err, trace) => StatusColors.ERROR.color,
      loading: () => StatusColors.LOADING.color,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final stockState = ref.watch(stockProvider);

    final bleStatusColor = _getBleStatusColor(bleState);
    final stockStatusColor = _getStockStatusColor(
      stockState,
      ref.watch(stockProvider.notifier).updatedAt,
    );

    final typography = context.theme.typography;

    return CustomCard(
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status da conexão',
                textAlign: TextAlign.start,
                style: typography.base.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Row(
                spacing: 8,
                children: [
                  _StatusItem(color: bleStatusColor, height: 36, svgPath: Assets.scannerIcon),
                  _StatusItem(svgPath: Assets.stockIcon, height: 32, color: stockStatusColor),
                  // const SizedBox(width: 2),
                  // const Icon(FIcons.chevronRight, size: 18),
                ],
              ),
            ],
          ),
          UpdateStockButton(),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({required this.color, this.svgPath, required this.height});

  final Color color;
  final double height;
  final String? svgPath;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(svgPath!, height: height, color: color);
  }
}
