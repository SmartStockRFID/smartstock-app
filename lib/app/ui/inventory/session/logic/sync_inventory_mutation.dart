import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';

final syncInventoryMutation = Mutation<void>();

Future<void> Function(MutationTransaction tsx) syncInventoryRun(
  BuildContext context,
  WidgetRef ref,
) {
  return (tsx) async {
    try {
      await tsx.get(inventoryManagerProvider.notifier).syncInventory();
    } catch (err) {
      if (!context.mounted) {
        return;
      }
      if (err is OfflineException) {
        showFToast(
          context: context,
          alignment: FToastAlignment.topCenter,
          title: const Text('Sem conexão com a internet', style: TextStyle(color: Colors.red)),
          icon: const Icon(FIcons.wifiOff, color: Colors.red),
        );
      } else {
        showFToast(
          context: context,
          alignment: FToastAlignment.topCenter,
          description: const Text(
            'Por favor tente novamente mais tarde.',
            style: TextStyle(color: Colors.red),
          ),
          title: const Text('Erro na requisição.', style: TextStyle(color: Colors.red)),
          icon: const Icon(FIcons.circleX, color: Colors.red),
        );
      }
      rethrow;
    }

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  };
}
