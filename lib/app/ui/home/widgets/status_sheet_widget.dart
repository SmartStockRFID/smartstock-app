import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/domain/status_color.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/inventory_modals_widgets.dart';

Future<void> showStatusSheet(
  BuildContext context, {
  required BluetoothDevice? connectedDevice,
  required Color bleStatusColor,
  required Color stockStatusColor,
}) async {
  String bleStatusText = '';

  if (bleStatusColor == StatusColors.ERROR.color) {
    bleStatusText = 'Erro na conexão';
  } else if (bleStatusColor == StatusColors.LOADING.color) {
    bleStatusText = 'Buscando dispositivos...';
  } else if (bleStatusColor == StatusColors.OK.color) {
    bleStatusText = connectedDevice?.platformName ?? 'Conectado';
  }

  const String stockStatusText = '';

  return showFSheet(
    style: getModalBlurStyle(context).call,
    context: context,
    side: FLayout.btt,
    builder: (context) => ModalContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Status da conexão',
              style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Material(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    ListTile(
                      title: Text(bleStatusText, textAlign: TextAlign.start),
                      leading: SvgPicture.asset(
                        Assets.scannerIcon,
                        height: 36,
                        color: bleStatusColor,
                      ),
                      trailing: const Icon(FIcons.chevronRight, size: 18),
                      onTap: () {
                        context.router.push(const DevicesRoute());
                      },
                    ),
                    ListTile(
                      title: const Text('Entry A', textAlign: TextAlign.start),
                      leading: SvgPicture.asset(
                        Assets.stockIcon,
                        height: 32,
                        color: stockStatusColor,
                      ),
                    ),
                  ],
                ),
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
      ),
    ),
  );
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
