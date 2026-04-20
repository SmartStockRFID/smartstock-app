import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';
import 'package:smart_stock/app/domain/reading.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';

class CurrentItem extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    final isValueChanging = useState(false);
    final showedReading = useState<ProductReadings?>(null);

    ref.listen(inventoryManagerProvider.select((state) => state.lastAddedProductReading), (
      _,
      lastReading,
    ) async {
      if (stockState.hasValue &&
          lastReading != null &&
          isProductReadingsValid(lastReading, stockState.value!)) {
        showedReading.value = lastReading;

        isValueChanging.value = true;
        await Future.delayed(const Duration(milliseconds: 500));
        isValueChanging.value = false;
      }
    });

    return CustomCard(
      blink: isValueChanging.value,
      sizedBoxHeight: 0,
      child: SizedBox(
        height: 240,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: showedReading.value == null
              ? Text(
                  'Aguardando leitura...',
                  style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                )
              : _ReadingView(
                  context: context,
                  stockState: stockState,
                  lastReading: showedReading.value!,
                ),
        ),
      ),
    );
  }
}

class _ReadingView extends StatelessWidget {
  final BuildContext context;

  final AsyncValue<List<Product>> stockState;
  final ProductReadings lastReading;

  const _ReadingView({required this.context, required this.stockState, required this.lastReading});

  @override
  Widget build(BuildContext context) {
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
                data: (products) {
                  final productIndex = products.indexWhere(
                    (p) => p.productCode == lastReading.productOEM,
                  );
                  return Text(
                    productIndex != -1 ? products[productIndex].name : 'DESCONHECIDO',
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
                    'UNIDADE${lastReading.tagCount == 1 ? '' : 'S'} REGISTRADA${lastReading.tagCount == 1 ? '' : 'S'}',
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
