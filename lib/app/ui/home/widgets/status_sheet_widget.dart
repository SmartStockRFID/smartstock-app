import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/domain/status_color.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/modal_content.dart';
import 'package:smart_stock/app/ui/_core/widgets/update_stock_btn.dart';

Future<void> showStatusSheet(BuildContext context) async {
  return showFSheet(
    style: getModalBlurStyle(context).call,
    context: context,
    side: FLayout.btt,
    builder: (context) => ModalContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Conexões',
              style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Material(
                child: DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: <Widget>[
                      const BleListTile(),
                      const StockListTile(),
                      UpdateStockButton(),
                    ],
                  ),
                ),
              ),
            ),
            FButton(
              style: createLargeStyle(
                context: context,
                backgroundColor: context.theme.colors.primary,
                foregroundColor: context.theme.colors.primaryForeground,
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
      ),
    ),
  );
}

class BleListTile extends ConsumerWidget {
  const BleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final bleStatusColor = getBleStatusColor(bleState);

    final connectedDevice = bleState.manager.connectedPistol;

    String bleStatusText = '';

    if (bleStatusColor == StatusColors.ERROR.color) {
      bleStatusText = 'Erro na conexão';
    } else if (bleStatusColor == StatusColors.LOADING.color) {
      bleStatusText = 'Buscando dispositivos...';
    } else if (bleStatusColor == StatusColors.OK.color) {
      bleStatusText = connectedDevice?.remoteId.str ?? 'Conectado';
    }

    return ListTile(
      title: Text(bleStatusText, textAlign: TextAlign.start),
      leading: SvgPicture.asset(Assets.scannerIcon, height: 36, color: bleStatusColor),
      trailing: const Icon(FIcons.chevronRight, size: 18),
      onTap: () {
        context.router.push(const DevicesRoute());
      },
    );
  }
}

class StockListTile extends ConsumerWidget {
  const StockListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final stockStatusColor = getStockStatusColor(
      stockState,
      ref.watch(stockProvider.notifier).updatedAt,
    );

    return ListTile(
      title: Row(children: [const SizedBox(width: 3), _buildLastUpdateInfo(context, ref)]),
      leading: SvgPicture.asset(Assets.stockIcon, height: 32, color: stockStatusColor),
    );
  }

  Widget _buildLastUpdateInfo(BuildContext context, WidgetRef ref) {
    final updatedAt = ref.watch(stockProvider.notifier).updatedAt;

    if (updatedAt == null) {
      return const Text('Estoque ainda não atualizado');
    }

    final dateFormat = DateFormat('dd/MM').format(updatedAt);
    final timeFormat = DateFormat('HH:mm').format(updatedAt);

    final text = DateTime.now().difference(updatedAt).inDays < 1
        ? timeFormat
        : '$timeFormat, $dateFormat';
    return Text('Atualizado às $text', textAlign: TextAlign.start);
  }
}
