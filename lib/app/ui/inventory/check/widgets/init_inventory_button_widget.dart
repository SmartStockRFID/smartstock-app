import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';
import 'package:smart_stock/app/ui/inventory/check/logic/future_providers.dart';
import 'package:smart_stock/app/ui/inventory/check/logic/init_inventory_mutation.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class InitInventoryButton extends HookConsumerWidget with _ConsumerState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final btnCanBeClicked =
        currentUser(ref).hasValue &&
        !currentUser(ref).isLoading &&
        !queryActiveInventory(ref).isLoading &&
        !queryActiveInventory(ref).hasError &&
        stockState(ref).hasValue &&
        isInitIdle(ref);

    return FButton(
      style: primaryLargeButton(context, disabled: !btnCanBeClicked),
      onPress: () async {
        if (!btnCanBeClicked) {
          if (!stockState(ref).hasValue) {
            showFToast(
              context: context,
              alignment: FToastAlignment.topCenter,
              title: const Text('Produtos não carregados', style: TextStyle(color: Colors.red)),
              icon: const Icon(FIcons.packageSearch, color: Colors.red),
            );
          }
          return;
        }

        final activeInventory = queryActiveInventory(ref).value;

        if (activeInventory != null) {
          ref.read(inventoryManagerProvider.notifier).setInventoryFromServer(activeInventory);
          Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
          context.router.replaceAll([const HomeRoute(), const InventorySessionRoute()]);
        } else if (isInitIdle(ref)) {
          initInventoryMutation.run(ref, initInventoryRun(context, ref));
        }
      },
      child: currentUser(ref).when(
        data: (loggedUsername) => queryActiveInventory(ref).when(
          data: (inventory) {
            String btnLabel;
            if (inventory == null) {
              btnLabel = 'INICIAR AGORA';
            } else if (inventory.employeeUsername == loggedUsername) {
              btnLabel = 'CONTINUAR AGORA';
            } else {
              btnLabel = 'ENTRAR NA SESSÃO';
            }
            return Text(
              btnLabel,
              style: context.theme.typography.xl2.copyWith(color: Colors.white),
            );
          },
          error: (e, st) =>
              Text('ERRO', style: context.theme.typography.xl2.copyWith(color: Colors.white)),
          loading: () => const LoadingWidget(color: Colors.white),
        ),
        error: (err, trace) => const Text('INAUTORIZADO'),
        loading: () => const LoadingWidget(color: Colors.white),
      ),
    );
  }
}

mixin class _ConsumerState {
  AsyncValue<String> currentUser(WidgetRef ref) => ref.watch(currentUserProvider);
  bool isInitIdle(WidgetRef ref) =>
      ref.watch(initInventoryMutation.select((state) => state is MutationIdle));
  AsyncValue<InventorySummary?> queryActiveInventory(WidgetRef ref) =>
      ref.watch(getActiveInventoryProvider);
  AsyncValue<List<Product>> stockState(WidgetRef ref) => ref.watch(stockProvider);
}
