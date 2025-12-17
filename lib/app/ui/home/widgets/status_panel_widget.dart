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
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/_core/widgets/update_stock_btn.dart';

class ModalContent extends ConsumerWidget {
  final Widget child;

  const ModalContent({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: FToaster(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.colors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          border: Border.symmetric(vertical: BorderSide(color: context.theme.colors.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
          child: SafeArea(child: child),
        ),
      ),
    ),
  );
}

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final stockState = ref.watch(stockProvider);

    final bleStatusColor = _getBleStatusColor(bleState);
    final lastStockUpdate = ref.watch(stockProvider.notifier).updatedAt;
    final stockStatusColor = _getStockStatusColor(stockState, lastStockUpdate);

    final stockFresh = lastStockUpdate != null && isStockFresh(lastStockUpdate);

    final typography = context.theme.typography;

    return InkWell(
      onTap: () {
        showFSheet(
          context: context,
          builder: (BuildContext context) {
            return ModalContent(
              child: Column(
                children: [
                  Text(
                    'Status da conexão',
                    style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.w600),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: SvgPicture.asset(Assets.scannerIcon, height: 28, color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: SvgPicture.asset(Assets.stockIcon, height: 26, color: Colors.black),
                    ),
                  ),
                  FButton(
                    style: createLargeStyle(
                      context: context,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.lightGreen,
                    ),
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'VOLTAR',
                      style: context.theme.typography.xl2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          side: FLayout.btt,
        );
        // context.router.push(const DevicesRoute());
      },
      child: CustomCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status da conexão',
                  textAlign: TextAlign.start,
                  style: typography.base.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    _StatusItem(color: bleStatusColor, height: 36, svgPath: Assets.scannerIcon),
                    _StatusItem(svgPath: Assets.stockIcon, height: 32, color: stockStatusColor),
                    const SizedBox(width: 2),
                    const Icon(FIcons.chevronRight, size: 18),
                  ],
                ),
              ],
            ),
            if (stockFresh)
              const Center()
            else ...[
              const SizedBox(height: 20),
              UpdateStockButton(),
            ],
          ],
        ),
      ),
    );
  }

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
          : (isStockFresh(updatedAt) ? StatusColors.OK.color : StatusColors.OUTDATED.color),
      error: (err, trace) => StatusColors.ERROR.color,
      loading: () => StatusColors.LOADING.color,
    );
  }
}

class _StatusItem extends StatelessWidget {
  final Color color;

  final double height;
  final String? svgPath;
  const _StatusItem({required this.color, this.svgPath, required this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(svgPath!, height: height, color: color);
  }
}
