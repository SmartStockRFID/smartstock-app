import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/modal_content.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals/shared/inventory_scoreboard_widget.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals/shared/inventory_time_info_widget.dart';
import 'package:smart_stock/app/utils/fortunes.dart';

class InventoryPauseModal extends ConsumerWidget with _ConsumerEvent {
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

mixin class _ConsumerEvent {
  void Function() pauseInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).pauseInventory;
  void Function() resumeInventory(WidgetRef ref) =>
      ref.read(inventoryManagerProvider.notifier).resumeInventory;
}
