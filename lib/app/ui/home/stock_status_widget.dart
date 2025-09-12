import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';

class StockStatusWidget extends ConsumerWidget {
  const StockStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    int productsCount = 0;

    if (stockState.reqStatus == RequestStatus.success) {
      productsCount = stockState.parts?.length ?? 0;
    }

    switch (stockState.reqStatus) {
      case RequestStatus.idle:
        return const Text('Requisição não iniciada!');
      case RequestStatus.loading:
        return const Text('Buscando dados do estoque...');
      case RequestStatus.success:
        return Text('Estoque com $productsCount peças');
      case RequestStatus.error:
        return Text(stockState.errorMessage ?? 'Erro durante busca do estoque.');
    }
  }
}
