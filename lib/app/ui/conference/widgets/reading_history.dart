import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/base_list_widget.dart';

class ReadingHistoryWidget extends ConsumerWidget {
  final ConferenceManagerState confState;

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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              stockState.when(
                                data: (parts) {
                                  final productIndex = parts.indexWhere(
                                    (prod) => prod.productCode == reading.productOEM,
                                  );
                                  return Text(
                                    productIndex != -1 ? parts[productIndex].name : 'Desconhecido',
                                  );
                                },
                                error: (Object error, StackTrace stackTrace) {
                                  return const Text('Desconhecido');
                                },
                                loading: () {
                                  return const Text('Procurando...');
                                },
                              ),
                            ],
                          ),

                          Text('OEM: ${reading.productOEM}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(reading.tagCount.toString()),
                          const SizedBox(width: 16),
                          Text(DateFormat.Hm().format(reading.readTags.last.readTimestamp)),
                        ],
                      ),
                    ],
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
