import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_shared/types.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';

class ModalSheetPaused extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasEnded = ref.watch(inventoryManagerProvider.select((state) => state.hasEnded));
    final hasReqPending = ref.watch(
      inventoryManagerProvider.select((state) => state.hasReqPending),
    );

    final bool btnDisabled = hasReqPending || hasEnded;

    final pauseInventory = ref.read(inventoryManagerProvider.notifier).pauseInventory;

    final barrierColor = context.theme.colors.barrier;
    final modalSheetStyle = context.theme.modalSheetStyle;

    final modalStyle = modalSheetStyle.copyWith(
      barrierFilter: (animation) => ImageFilter.compose(
        outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
        inner: ColorFilter.mode(barrierColor, BlendMode.srcOver),
      ),
    );

    final resumeInventory = ref.read(inventoryManagerProvider.notifier).resumeInventory;

    return FButton(
      style: FButtonStyle.secondary(),
      prefix: const Icon(FIcons.pause, size: 16, color: Colors.black),
      child: const Text('PAUSAR', style: TextStyle(height: 2)),
      onPress: () {
        if (btnDisabled) {
          return;
        }
        pauseInventory();
        showFSheet(
          barrierDismissible: false,
          style: modalStyle.call,
          context: context,
          side: FLayout.btt,
          builder: (context) => ModalSheetContent(
            side: FLayout.rtl,
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

                      const Text(
                        'Não se preocupe, seu progresso está salvo.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  _Scoreboard(),
                  FButton(
                    style: createLargeStyle(
                      context: context,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.lightGreen,
                    ),
                    onPress: () {
                      resumeInventory();
                      Navigator.of(context).pop();
                    },
                    prefix: const Icon(FIcons.play, size: 16, color: Colors.white),
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
            ),
          ),
        );
      },
    );
  }
}

class ModalSheetCancel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryManager = ref.read(inventoryManagerProvider.notifier);
    final pauseInventory = ref.read(inventoryManagerProvider.notifier).pauseInventory;

    final barrierColor = context.theme.colors.barrier;
    final modalSheetStyle = context.theme.modalSheetStyle;

    final modalStyle = modalSheetStyle.copyWith(
      barrierFilter: (animation) => ImageFilter.compose(
        outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
        inner: ColorFilter.mode(barrierColor, BlendMode.srcOver),
      ),
    );
    final cancelReqStatus = ref.watch(
      inventoryManagerProvider.select((state) => state.cancelReqStatus),
    );
    final resumeInventory = ref.read(inventoryManagerProvider.notifier).resumeInventory;

    final hasReqPending = ref.watch(
      inventoryManagerProvider.select((state) => state.hasReqPending),
    );
    final hasEnded = ref.watch(inventoryManagerProvider.select((state) => state.hasEnded));

    final bool btnDisabled = hasReqPending || hasEnded;

    return FButton(
      style: FButtonStyle.outline(),
      prefix: const Icon(FIcons.square, size: 16.0, color: Colors.black),
      child: cancelReqStatus == RequestStatus.loading
          ? const Text('CANCELANDO', style: TextStyle(height: 2))
          : const Text('CANCELAR', style: TextStyle(height: 2)),
      onPress: () {
        if (btnDisabled) {
          return;
        }
        pauseInventory();
        showFSheet(
          barrierDismissible: false,
          style: modalStyle.call,
          context: context,
          side: FLayout.btt,
          builder: (context) => ModalSheetContent(
            side: FLayout.rtl,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Você tem certeza?',
                        style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const Text(
                        'Essa ação não pode ser desfeita.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  _Scoreboard(),
                  Column(
                    spacing: 8,
                    children: [
                      FButton(
                        onPress: () {
                          Navigator.of(context).pop();
                          inventoryManager.cancelInventory();
                        },
                        style: createLargeStyle(
                          context: context,
                          backgroundColor: context.theme.colors.destructive,
                          foregroundColor: context.theme.colors.destructiveForeground,
                        ),
                        child: Text(
                          'CANCELAR INVENTÁRIO',

                          style: context.theme.typography.xl.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FButton(
                        style: createLargeStyle(
                          context: context,
                          backgroundColor: context.theme.colors.secondary,
                          foregroundColor: context.theme.colors.secondaryForeground,
                        ),
                        onPress: () {
                          resumeInventory();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'VOLTAR',
                          style: context.theme.typography.xl.copyWith(fontWeight: FontWeight.bold),
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

class ModalSheetFinish extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryManager = ref.read(inventoryManagerProvider.notifier);
    final pauseInventory = ref.read(inventoryManagerProvider.notifier).pauseInventory;

    final hasReqPending = ref.watch(
      inventoryManagerProvider.select((state) => state.hasReqPending),
    );
    final hasEnded = ref.watch(inventoryManagerProvider.select((state) => state.hasEnded));

    final bool btnDisabled = hasReqPending || hasEnded;

    final barrierColor = context.theme.colors.barrier;
    final modalSheetStyle = context.theme.modalSheetStyle;

    final modalStyle = modalSheetStyle.copyWith(
      barrierFilter: (animation) => ImageFilter.compose(
        outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
        inner: ColorFilter.mode(barrierColor, BlendMode.srcOver),
      ),
    );
    final finishReqStatus = ref.watch(
      inventoryManagerProvider.select((state) => state.finishReqStatus),
    );

    final resumeInventory = ref.read(inventoryManagerProvider.notifier).resumeInventory;

    return FButton(
      prefix: const Icon(FIcons.circleCheck, size: 16.0, color: Colors.white),
      style: primaryLargeButton(context, disabled: btnDisabled),
      onPress: () {
        if (btnDisabled) {
          return;
        }

        pauseInventory();
        showFSheet(
          barrierDismissible: false,
          style: modalStyle.call,
          context: context,
          side: FLayout.btt,
          builder: (context) => ModalSheetContent(
            side: FLayout.rtl,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Concluir o inventário?',
                        style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const Text(
                        'A contagem atual será salva como final.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  _Scoreboard(),
                  Column(
                    spacing: 8,
                    children: [
                      FButton(
                        style: primaryLargeButton(context),
                        onPress: () {
                          Navigator.of(context).pop();
                          inventoryManager.finishInventory();
                        },
                        child: Text(
                          'CONCLUIR INVENTÁRIO',
                          style: context.theme.typography.xl.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FButton(
                        style: createLargeStyle(
                          context: context,
                          backgroundColor: context.theme.colors.secondary,
                          foregroundColor: context.theme.colors.secondaryForeground,
                        ),
                        onPress: () {
                          resumeInventory();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'VOLTAR',
                          style: context.theme.typography.xl.copyWith(fontWeight: FontWeight.bold),
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

      child: Text(
        finishReqStatus == RequestStatus.loading
            ? 'CONCLUINDO...'
            : (finishReqStatus == RequestStatus.success ? 'CONCLUÍDA' : 'CONCLUIR'),
        style: context.theme.typography.xl2.copyWith(color: Colors.white),
      ),
    );
  }
}

class ModalSheetContent extends ConsumerWidget {
  final FLayout side;
  final Widget child;

  const ModalSheetContent({required this.side, required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
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
  );
}

class _Scoreboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readings = ref.watch(inventoryManagerProvider.select((state) => state.readings));
    final readingsCount = ref.watch(
      inventoryManagerProvider.select((state) => state.readingsCount),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ScoreboardItem(count: readings.length, label: 'Produtos Únicos'),
            const VerticalDivider(width: 20, color: Colors.grey),
            _ScoreboardItem(count: readingsCount, label: 'Etiquetas Lidas'),
          ],
        ),
      ],
    );
  }
}

class _ScoreboardItem extends StatelessWidget {
  const _ScoreboardItem({required this.count, required this.label});
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          count.toString(),
          style: context.theme.typography.xl5.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(label.toUpperCase(), style: context.theme.typography.sm.copyWith(color: Colors.grey)),
      ],
    );
  }
}
