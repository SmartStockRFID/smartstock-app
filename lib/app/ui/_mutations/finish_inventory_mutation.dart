import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';

final finishInventoryMutation = Mutation<void>();

Future<void> Function(MutationTransaction tsx) finishInventoryRun(
  BuildContext context,
  WidgetRef ref,
) {
  return (tsx) async {
    try {
      await tsx.get(inventoryManagerProvider.notifier).finishInventory();
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

    final resetState = ref.read(inventoryManagerProvider.notifier).resetState;

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();

    showFDialog(
      context: context,
      barrierDismissible: false,
      builder: (context, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        title: const Text('Inventário concluído com sucesso!'),
        actions: [
          FButton(
            onPress: () async {
              await context.router.replaceAll([const HomeRoute()]);
              await Future.delayed(const Duration(milliseconds: 500));
              resetState();
            },
            style: createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.secondary,
              foregroundColor: context.theme.colors.secondaryForeground,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  };
}
