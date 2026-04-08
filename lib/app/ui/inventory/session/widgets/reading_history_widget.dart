import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';


class ReadingHistory extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final readings = ref.watch(inventoryManagerProvider.select((state) => state.readings));
    final readingsCount = ref.watch(
      inventoryManagerProvider.select((state) => state.readingsCount),
    );

    if (readings.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Histórico',
            style: context.theme.typography.lg.copyWith(fontWeight: FontWeight.bold),
          ),
          FBadge(
            child: Text(
              '$readingsCount lidos',
              style: context.theme.typography.lg.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: readings.length,
        itemBuilder: (context, index) {
          final reading = readings[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: stockState.when(
              data: (products) {
                final productIndex = products.indexWhere(
                  (p) => p.productCode == reading.productOEM,
                );
                return Text(
                  productIndex != -1 ? products[productIndex].name : 'Desconhecido',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
              error: (e, st) => const Text('Desconhecido'),
              loading: () => const Text('Procurando...'),
            ),
            subtitle: Text('OEM: ${reading.productOEM}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${reading.tagCount} un',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(DateFormat.Hm().format(reading.readTags.last.readTimestamp)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
