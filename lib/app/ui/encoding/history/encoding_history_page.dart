import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/ui/_core/widgets/app_bar.dart';
import 'package:smart_stock/app/ui/_core/widgets/base_list_widget.dart';
import 'package:smart_stock/app/ui/encoding/logic/encoding_history_saver.dart';

final historyProvider = FutureProvider.autoDispose<List<EncodingRecord>>((ref) async {
  return getEncodingHistory();
});

@RoutePage()
class EncodingHistoryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    final operations = history.asData?.value ?? [];

    final dateFormat = DateFormat('dd/MM');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: baseAppBar(title: 'Histórico'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(historyProvider, asReload: true);
                },
                child: BaseList(
                  isLoading: history.isLoading,
                  emptyMessage: 'Nenhuma gravação registrada no histórico.',
                  data: operations,
                  itemBuilder: (operation) => Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          backgroundColor: operation.productCode != null
                              ? Colors.blue[900]
                              : Colors.grey[600],
                          child: Icon(
                            operation.productCode != null ? FIcons.pen : FIcons.eraser,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${operation.quantity} ${operation.productCode != null ? 'gravadas' : 'limpas'}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: context.theme.typography.base.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              ...(operation.productCode != null
                                  ? [
                                      Text(
                                        operation.productCode!,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: context.theme.typography.sm.copyWith(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ]
                                  : []),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              timeFormat.format(operation.lastEncodingAt),
                              style: context.theme.typography.xs.copyWith(color: Colors.black54),
                            ),
                            ...(dateFormat.format(DateTime.now()) ==
                                    dateFormat.format(operation.lastEncodingAt)
                                ? []
                                : [
                                    Text(
                                      dateFormat.format(operation.lastEncodingAt),
                                      style: context.theme.typography.xs.copyWith(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  heightPercentage: 0.8,
                  widthPercentage: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
