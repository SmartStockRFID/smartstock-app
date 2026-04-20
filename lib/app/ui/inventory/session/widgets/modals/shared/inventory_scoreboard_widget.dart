import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';
import 'package:smart_stock/app/domain/reading.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/utils/reading.dart';

class Scoreboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final validReadings = stockState.value != null
        ? ref
              .watch(inventoryManagerProvider.select((state) => state.readings))
              .where((reading) => isProductReadingsValid(reading, stockState.value!))
              .toList()
        : <ProductReadings>[];
    final validReadingsCount = getProductReadingsTagsCount(validReadings);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ScoreboardItem(count: validReadings.length, label: 'Produtos Únicos'),
            const VerticalDivider(width: 20, color: Colors.grey),
            _ScoreboardItem(count: validReadingsCount, label: 'Etiquetas Lidas'),
          ],
        ),
      ],
    );
  }
}

class _ScoreboardItem extends StatelessWidget {
  final int count;
  final String label;
  const _ScoreboardItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          count.toString(),
          style: context.theme.typography.xl6.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: context.theme.typography.sm.copyWith(
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
    );
  }
}
