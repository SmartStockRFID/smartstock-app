import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';
import 'package:smart_stock/app/ui/inventory/check/logic/future_providers.dart';

class InventoryStatus extends ConsumerWidget {
  const InventoryStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryActiveInventory = ref.watch(getActiveInventoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    return CustomCard(
      title: const Text('Status do inventário'),
      child: Column(
        children: [
          currentUser.when(
            data: (username) => queryActiveInventory.when(
              data: (inventory) {
                String feedback;

                if (inventory == null) {
                  feedback = 'Nenhum inventário em andamento';
                } else if (inventory.employeeUsername == username) {
                  feedback = 'Retomar inventário #${inventory.id}?';
                } else {
                  feedback =
                      '${inventory.employeeUsername} está realizando o inventário #${inventory.id}';
                }

                return buildTextFeeback(context, feedback);
              },
              error: (e, st) =>
                  buildTextFeeback(context, 'Erro ao carregar dados do servidor', error: true),
              loading: () => const LoadingWidget(),
            ),
            error: (err, trace) =>
                buildTextFeeback(context, 'Erro ao carregar usuário logado', error: true),
            loading: () => const LoadingWidget(),
          ),
        ],
      ),
    );
  }

  Text buildTextFeeback(BuildContext context, String message, {bool error = false}) {
    return Text(
      message,
      style: context.theme.typography.xl2.copyWith(color: error ? Colors.red : Colors.black),
      textAlign: TextAlign.center,
    );
  }
}
