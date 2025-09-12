import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:logger/logger.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/ui/shared/base_list_widget.dart';
import 'package:intl/intl.dart';

class ReadingHistoryWidget extends StatelessWidget {
  final ConferenceManagerState confState;

  const ReadingHistoryWidget({required this.confState});

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
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
                          const Text('Produto desconhecido'),
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
