import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

class _CurrentItem extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final lastReading = ref.watch(
      inventoryManagerProvider.select((state) => state.lastAddedProductReading),
    );

    final isValueChanging = useState(false);

    ref.listen(inventoryManagerProvider.select((state) => state.lastAddedProductReading), (
      _,
      state,
    ) async {
      isValueChanging.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      isValueChanging.value = false;
    });

    return CustomCard(
      blink: isValueChanging.value,
      sizedBoxHeight: 0,
      child: SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: lastReading == null
                ? Text(
                    'Aguardando leitura...',
                    style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                  )
                : _buildReadingState(context, stockState, lastReading),
          ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                error: (e, st) => const Text('Desconhecido'),
                loading: () => const Text('Procurando...'),
              ),
              const SizedBox(height: 8),
              Center(
                child: FBadge(
                  style: (style) => style.copyWith(
                    decoration: style.decoration.copyWith(color: Colors.grey[200]),
                  ),
                  child: Text(
                    'OEM: ${lastReading.productOEM}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      lastReading.tagCount.toString(),
                      style: GoogleFonts.robotoMono(
                        textStyle: context.theme.typography.xl8.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'UNIDADE REGISTRADA${lastReading.tagCount == 1 ? '' : 'S'}',
                    style: context.theme.typography.sm.copyWith(letterSpacing: 2),
                  ),
                ],
              ),
            ],
          ),
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
    final readingsCount = ref.watch(
      inventoryManagerProvider.select((state) => state.readingsCount),
    );

    if (readings.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Histórico',
            style: context.theme.typography.lg.copyWith(fontWeight: FontWeight.bold),
          ),
          FBadge(
            child: Text(
              '$readingsCount lidos',
              style: context.theme.typography.lg.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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

    return Column(children: [const SizedBox(height: 8), ModalSheetPaused()]);
  }
}
