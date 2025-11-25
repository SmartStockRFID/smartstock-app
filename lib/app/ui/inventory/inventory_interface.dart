import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/inventory_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_shared/custom_card.dart';
import 'package:smart_stock/app/ui/_shared/types.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';
import 'package:smart_stock/app/ui/inventory/widgets/modals_widgets.dart';

class InventoryPageInterface extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inventoryBleListenerProvider);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // _Scoreboard(confState: confState),
                  // const SizedBox(height: 16),
                  _CurrentItem(),
                  const SizedBox(height: 16),
                  _ReadingHistory(),
                ],
              ),
            ),
          ),
          _Footer(key: UniqueKey()),
        ],
      ),
    );
  }
}

class _CurrentItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final lastReading = ref.watch(
      inventoryManagerProvider.select((state) => state.lastAddedProductReading),
    );

    return CustomCard(
      title: const Text('Item Atual'),
      child: SizedBox(
        height: 120,
        child: Center(
          child: lastReading == null
              ? const Text('Aguardando leitura...', style: TextStyle(fontSize: 16))
              : _buildReadingState(context, stockState, lastReading),
        ),
      ),
    );
  }

  Widget _buildReadingState(
    BuildContext context,
    AsyncValue<List<CarPart>> stockState,
    ProductReadings lastReading,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stockState.when(
                data: (parts) {
                  final productIndex = parts.indexWhere(
                    (p) => p.productCode == lastReading.productOEM,
                  );
                  return Text(
                    productIndex != -1 ? parts[productIndex].name : 'DESCONHECIDO',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                error: (e, st) => const Text('Desconhecido'),
                loading: () => const Text('Procurando...'),
              ),
              const SizedBox(height: 8),
              Text('OEM: ${lastReading.productOEM}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lastReading.tagCount.toString(),
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const Text('Unidades'),
          ],
        ),
      ],
    );
  }
}

class _ReadingHistory extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final readings = ref.watch(inventoryManagerProvider.select((state) => state.readings));

    if (readings.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      title: const Text('Histórico'),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: readings.length,
        itemBuilder: (context, index) {
          final reading = readings[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: stockState.when(
              data: (parts) {
                final productIndex = parts.indexWhere((p) => p.productCode == reading.productOEM);
                return Text(
                  productIndex != -1 ? parts[productIndex].name : 'Desconhecido',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
              error: (e, st) => const Text('Desconhecido'),
              loading: () => const Text('Procurando...'),
            ),
            subtitle: Text('OEM: ${reading.productOEM}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${reading.tagCount} un',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(DateFormat.Hm().format(reading.readTags.last.readTimestamp)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class _Footer extends ConsumerStatefulWidget {
  const _Footer({super.key});

  @override
  ConsumerState<_Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<_Footer> {
  @override
  Widget build(BuildContext context) {
    final resetState = ref.read(inventoryManagerProvider.notifier).resetState;

    ref.listen<InventoryManagerState>(inventoryManagerProvider, (previous, next) {
      final wasNotSuccess = previous?.cancelReqStatus != RequestStatus.success;
      if (wasNotSuccess && next.cancelReqStatus == RequestStatus.success) {
        showFDialog(
          barrierDismissible: false,
          context: context,
          builder: (context, style, animation) => FDialog(
            style: style.call,
            animation: animation,
            title: const Text('Inventário cancelado!'),
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
      }
    });

    ref.listen<InventoryManagerState>(inventoryManagerProvider, (previous, next) {
      final wasNotSuccess = previous?.finishReqStatus != RequestStatus.success;
      if (wasNotSuccess && next.finishReqStatus == RequestStatus.success) {
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
      }
    });

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ModalSheetPaused(), ModalSheetCancel()],
        ),
        const SizedBox(height: 8.0),
        ModalSheetFinish(),
      ],
    );
  }
}
