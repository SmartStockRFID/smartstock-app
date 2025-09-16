import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';
import 'package:smart_stock/app/utils/logger.dart';

class BackendStatusWidget extends ConsumerWidget {
  const BackendStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final stockManager = ref.read(stockProvider.notifier);

    return Builder(
      builder: (context) {
        // Determinar cor e texto baseado no estado atual
        late Color color;
        late String statusText;
        late IconData icon;

        if (stockState.hasValue) {
          color = Colors.blue;
          statusText = 'Atualizado';
          icon = FIcons.clipboardList;
        } else if (stockState.isLoading) {
          color = Colors.orange;
          statusText = 'Buscando...';
          icon = FIcons.clipboardList;
        } else if (stockState.isRefreshing) {
          color = Colors.orange;
          statusText = 'Atualizando...';
          icon = FIcons.clipboardList;
        } else if (stockState.hasError) {
          color = Colors.red;
          statusText = 'Erro';
          icon = FIcons.clipboardList;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 48.0, color: color),
                      const SizedBox(height: 8),
                      Text(
                        statusText,
                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8, width: 16),
                  FButton(
                    style: (stockState.isLoading || stockState.isRefreshing)
                        ? createDisabledButtonStyle(context)
                        : FButtonStyle.primary(),
                    onPress: () async {
                      if (stockState.isLoading) {
                        return;
                      }
                      logger.d('Reatualizando estoque...');
                      try {
                        await stockManager.refresh();
                        logger.d('Estoque reatualizado!');
                      } catch (error) {
                        logger.e('Erro ao reatualizar estoque!');
                      }
                    },
                    child: stockState.isRefreshing
                        ? const Text('Atualizando...')
                        : const Text('Atualizar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
