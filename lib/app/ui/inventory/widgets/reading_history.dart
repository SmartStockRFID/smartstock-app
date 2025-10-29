import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/ui/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/base_list_widget.dart';

class ReadingHistoryWidget extends ConsumerWidget {
  final InventoryManagerState confState;

  const ReadingHistoryWidget({required this.confState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final stockState = ref.watch(stockProvider);
    return SizedBox(
      height: 200,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Histórico de Leitura',
                  style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            BaseList(
              isLoading: false,
              emptyMessage: 'Aguardando leituras.',
              data: confState.readings,
              heightPercentage: 0.2,
              widthPercentage: 0.9,
              itemBuilder: (reading) {
                return FCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero, // Remove o padding padrão
                    title: stockState.when(
                      data: (parts) {
                        final productIndex = parts.indexWhere(
                          (prod) => prod.productCode == reading.productOEM,
                        );
                        return Text(
                          productIndex != -1 ? parts[productIndex].name : 'Desconhecido',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      },
                      error: (Object error, StackTrace stackTrace) {
                        return const Text('Desconhecido');
                      },
                      loading: () {
                        return const Text('Procurando...');
                      },
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
