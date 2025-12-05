import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';
import 'package:smart_stock/app/utils/internet.dart';

mixin class UpdateStockState {
  bool stockIsLoading(WidgetRef ref) =>
      ref.watch(stockProvider.select((state) => state.isLoading || state.isRefreshing));
}

mixin class UpdateStockEvent {
  Future<bool> refetchStock(WidgetRef ref) => ref.read(stockProvider.notifier).refresh();
}

class UpdateStockButton extends ConsumerWidget with UpdateStockState, UpdateStockEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FButton(
      style: FButtonStyle.outline(),
      onPress: () async {
        if (stockIsLoading(ref)) {
          return;
        }

        if (await appIsOffline() && context.mounted) {
          showFToast(
            context: context,
            alignment: FToastAlignment.topCenter,
            title: const Text('Sem conexão com a internet', style: TextStyle(color: Colors.red)),
            icon: const Icon(FIcons.wifiOff, color: Colors.red),
          );
          return;
        }

        final refreshed = await refetchStock(ref);

        if (!refreshed && context.mounted) {
          showFToast(
            context: context,
            alignment: FToastAlignment.topCenter,
            title: const Text('Erro ao atualizar estoque!', style: TextStyle(color: Colors.red)),
            icon: const Icon(FIcons.circleX, color: Colors.red),
          );
        }
      },
      child: Text(
        stockIsLoading(ref) ? 'Atualizando...' : 'Atualizar Estoque',
        style: context.theme.typography.lg,
      ),
    );
  }
}
