import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/inventory/session/logic/sync_inventory_mutation.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals_content_widgets.dart';
import 'package:smart_stock/app/utils/fortunes.dart';

class FinishButton extends ConsumerWidget with InventoryModalInterruptState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool btnDisabled =
        finishState(ref) is MutationSuccess ||
        finishState(ref) is MutationPending ||
        currentInventory(ref) == null;

    return FButton(
      prefix: finishState(ref) is MutationPending
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
        finishState(ref) is MutationPending ? 'SINCRONIZANDO...' : 'SINCRONIZAR',
        style: context.theme.typography.xl.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class InventoryModalFinish extends ConsumerWidget
    with InventoryModalInterruptState, InventoryModalInterruptEvent {
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
                        'Sincronizar o inventário?',
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
                  Column(
                    spacing: 8,
                    children: [
                      FinishButton(),
                      FButton(
                        style: createLargeStyle(
                          context: context,
                          backgroundColor: context.theme.colors.secondary,
                          foregroundColor: context.theme.colors.secondaryForeground,
                        ),
                        onPress: () {
                          if (finishState(ref) is MutationPending) {
                            return;
                          }

                          resumeInventory(ref);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'VOLTAR',
                          style: context.theme.typography.xl.copyWith(
                            fontWeight: FontWeight.bold,
                            color: finishState(ref) is MutationPending ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ],
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

mixin class InventoryModalInterruptEvent {
  void Function() pauseInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).pauseInventory;
  void Function() resumeInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).resumeInventory;
}

mixin class InventoryModalInterruptState {
  InventorySummary? currentInventory(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory));

  MutationState finishState(WidgetRef ref) => ref.watch(syncInventoryMutation);
}

class InventoryModalPaused extends ConsumerWidget
    with InventoryModalInterruptState, InventoryModalInterruptEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FButton(
      style: secondaryLargeButton(context),
      prefix: const Icon(FIcons.pause, size: 20, color: Colors.black),
      child: Text('PAUSAR', style: context.theme.typography.xl2.copyWith(color: Colors.black)),
      onPress: () {
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
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Inventário pausado',
                        style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                      ),

                      TimeInfo(),
                    ],
                  ),
                  Scoreboard(),
                  Column(
                    spacing: 4,
                    children: [
                      Text(
                        getRandomFortune(),
                        style: context.theme.typography.xs.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      FButton(
                        style: createLargeStyle(
                          context: context,
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.lightGreen,
                        ),
                        onPress: () {
                          resumeInventory(ref);
                          Navigator.of(context).pop();
                        },
                        prefix: const Icon(FIcons.play, size: 20, color: Colors.white),

                        child: Text(
                          'RETOMAR',
                          style: context.theme.typography.xl2.copyWith(
                            color: Colors.white,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

class ModalContent extends ConsumerWidget {
  final Widget child;

  const ModalContent({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FToaster(
    child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.symmetric(vertical: BorderSide(color: context.theme.colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
        child: SafeArea(child: child),
      ),
    ),
  );
}
