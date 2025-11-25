import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';

class UpdateStockButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final stockNotifier = ref.read(stockProvider.notifier);

    return FButton(
      style: FButtonStyle.outline(),
      onPress: stockState.isLoading || stockState.isRefreshing
          ? null
          : () => stockNotifier.refresh(),
      child: Text(
        stockState.isLoading || stockState.isRefreshing ? 'Atualizando...' : 'Atualizar Estoque',
        style: context.theme.typography.lg,
      ),
    );
  }
}
