import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';
import 'package:smart_stock/app/utils/fortunes.dart';

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
      style: secondaryLargeButton(context),
      prefix: Icon(FIcons.pause, size: 20, color: btnDisabled ? Colors.grey : Colors.black),
      child: Text(
        'PAUSAR',
        style: context.theme.typography.xl2.copyWith(
          color: btnDisabled ? Colors.grey : Colors.black,
        ),
      ),
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

                      TimeInfo(),
                    ],
                  ),
                  _Scoreboard(),
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
                          resumeInventory();
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

class TimeInfo extends ConsumerWidget {
  String formatTimestamp(DateTime timestamp) {
    final timeFormat = DateFormat('HH:mm').format(timestamp);

    return timeFormat;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentInventory = ref.watch(
      inventoryManagerProvider.select((state) => state.currentInventory),
    );

    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(FIcons.clock, size: 16, color: Color.fromARGB(255, 130, 130, 130)),
        Text.rich(
          currentInventory != null
              ? TextSpan(
                  children: [
                    const TextSpan(text: 'Iniciado às '),
                    TextSpan(
                      text: formatTimestamp(currentInventory.createdAt.toLocal()),
                      style: context.theme.typography.xl.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 130, 130, 130),
                      ),
                    ),
                  ],
                )
              : const TextSpan(text: 'Sem mais informações'),

          style: context.theme.typography.xl.copyWith(
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
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

    return IconButton(
      icon: Icon(Icons.stop, size: 32, color: btnDisabled ? Colors.grey : Colors.white),
      onPressed: () {
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
                      TimeInfo(),
                      // const Text(
                      //   'A contagem atual será salva como final.',
                      //   style: TextStyle(color: Colors.grey),
                      // ),
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
          style: context.theme.typography.xl6.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: context.theme.typography.sm.copyWith(color: Color.fromARGB(255, 130, 130, 130)),
        ),
      ],
    );
  }
}
