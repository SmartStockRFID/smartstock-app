import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/modal_content.dart';
import 'package:smart_stock/app/ui/inventory/session/logic/sync_inventory_mutation.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals/shared/inventory_scoreboard_widget.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals/shared/inventory_time_info_widget.dart';

class GoBackButton extends ConsumerWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FButton(
      style: createLargeStyle(
        context: context,
        backgroundColor: context.theme.colors.secondary,
        foregroundColor: context.theme.colors.secondaryForeground,
      ),
      onPress: () {
        resumeInventory(ref);
        Navigator.of(context).pop();
      },
      child: Text(
        'VOLTAR',
        style: context.theme.typography.xl.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  void Function() resumeInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).resumeInventory;

  MutationState syncState(WidgetRef ref) => ref.watch(syncInventoryMutation);
}

class InventorySyncModal extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool btnDisabled = currentInventory(ref) == null;

    return IconButton(
      icon: Icon(FIcons.rss, size: 24, color: btnDisabled ? Colors.grey : Colors.white),
      onPressed: () {
        if (btnDisabled) {
          return;
        }

        pauseInventory(ref);

        showFSheet(
          barrierDismissible: false,
          style: getModalBlurStyle(context).call,
          context: context,
          side: FLayout.btt,
          builder: (context) => ModalContent(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Resumo do inventário',
                        style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TimeInfo(),
                      // const Text(
                      //   'A contagem atual será salva como final.',
                      //   style: TextStyle(color: Colors.grey),
                      // ),
                    ],
                  ),
                  Scoreboard(),
                  Column(spacing: 8, children: [SyncButton(), const GoBackButton()]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InventorySummary? currentInventory(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory));

  List<ProductReadings> inventoryReadings(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.readings));

  void Function() pauseInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).pauseInventory;

  void Function() resumeInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).resumeInventory;

  MutationState syncState(WidgetRef ref) => ref.watch(syncInventoryMutation);
}

class SyncButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool btnDisabled =
        inventoryReadings(ref).isEmpty ||
        syncState(ref) is MutationSuccess ||
        syncState(ref) is MutationPending ||
        currentInventory(ref) == null;

    return FButton(
      prefix: syncState(ref) is MutationPending
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : null,
      style: primaryLargeButton(context, disabled: btnDisabled),

      onPress: () async {
        if (btnDisabled) {
          return;
        }

        syncInventoryMutation.run(ref, finishInventoryRun(context, ref));
      },
      child: Text(
        syncState(ref) is MutationPending ? 'SINCRONIZANDO...' : 'SINCRONIZAR',
        style: context.theme.typography.xl.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InventorySummary? currentInventory(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory));

  List<ProductReadings> inventoryReadings(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.readings));

  MutationState syncState(WidgetRef ref) => ref.watch(syncInventoryMutation);
}
