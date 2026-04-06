import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/domain/status_color.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/home/widgets/status_sheet_widget.dart';

class StatusPanelWidget extends ConsumerWidget {
  const StatusPanelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final bleStatusColor = getBleStatusColor(bleState);

    final stockState = ref.watch(stockProvider);
    final stockStatusColor = getStockStatusColor(
      stockState,
      ref.watch(stockProvider.notifier).updatedAt,
    );

    final typography = context.theme.typography;

    return InkWell(
      onTap: () {
        showStatusSheet(context);
      },
      child: CustomCard(
        child: Row(
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
                const SizedBox(width: 2),
                const Icon(FIcons.chevronRight, size: 18),
              ],
            ),
          ],
        ),
      ),
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
