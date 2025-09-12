import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

class StockStatusWidget extends ConsumerWidget {
  const StockStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    return Column(
      children: [
        stockState.when(
          data: (parts) {
            return Text('Estoque com ${parts.length} peças');
          },
          error: (e, stackTrace) {
            logger.e('Erro durante busca do estoque. $e, $stackTrace');
            return const Text('Erro durante busca do estoque.');
          },
          loading: () {
            return const Text('Buscando dados do estoque...');
          },
        ),
      ],
    );
  }
}
