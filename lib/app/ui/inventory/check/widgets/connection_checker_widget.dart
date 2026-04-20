import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/domain/stock.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/_core/widgets/update_stock_btn.dart';

class ConnectionChecker extends ConsumerWidget {
  const ConnectionChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final stockLastUpdate = ref.watch(stockProvider.notifier).updatedAt;
    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));

    return CustomCard(
      title: const Text('Checklist de Prontidão'),
      child: Column(
        spacing: 12,
        children: [
          _StatusItem(isReady: bleState is ConnectedState, text: 'Leitor conectado'),
          stockState.when(
            data: (_) => _StatusItem(
              isReady: true,
              text: 'Produtos carregados',
              isFresh: !(stockLastUpdate != null) || isStockFresh(stockLastUpdate),
            ),
            error: (e, st) => const _StatusItem(isReady: false, text: 'Erro ao carregar produtos'),
            loading: () =>
                const _StatusItem(isReady: false, isLoading: true, text: 'Carregando produtos...'),
          ),
          if (stockState.hasError || (stockLastUpdate != null && !isStockFresh(stockLastUpdate)))
            UpdateStockButton()
          else
            const Center(),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final bool isReady;
  final bool? isLoading;
  final bool? isFresh;
  final String text;
  const _StatusItem({required this.isReady, required this.text, this.isLoading, this.isFresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (true && isLoading != null && isLoading!)
          const CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        else
          Icon(
            (isFresh ?? true)
                ? (isReady ? FIcons.circleCheck : FIcons.circleX)
                : FIcons.circleAlert,
            color: isReady ? ((isFresh ?? true) ? Colors.green : Colors.orange) : Colors.red,
            size: 24,
          ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
