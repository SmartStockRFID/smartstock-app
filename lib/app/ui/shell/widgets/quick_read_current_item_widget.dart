import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';
import 'package:smart_stock/app/ui/shell/logic/quick_read_provider.dart';

class QuickReadCurrentItem extends HookConsumerWidget {
  final ReadingResponseContent firstRead;

  const QuickReadCurrentItem({required this.firstRead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamRead = ref.watch(quickReadProvider);
    final stockState = ref.watch(stockProvider);
    final currentRead = streamRead.value ?? firstRead;

    final isValueChanging = useState(false);

    ref.listen(quickReadProvider, (_, state) async {
      if (state.hasValue) {
        isValueChanging.value = true;

        await Future.delayed(const Duration(milliseconds: 120));

        isValueChanging.value = false;
      }
    });

    return CustomCard(
      child: SizedBox(
        height: 150,
        child: isValueChanging.value
            ? const LoadingWidget()
            : Center(child: _buildReadingState(context, stockState, currentRead)),
      ),
    );
  }

  Widget _buildReadingState(
    BuildContext context,
    AsyncValue<List<Product>> stockState,
    ReadingResponseContent currentRead,
  ) {
    final isResetedTag = currentRead.productOEM == emptyTagOEM;

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
                data: (products) {
                  final productIndex = products.indexWhere(
                    (p) => p.productCode == currentRead.productOEM,
                  );
                  return Text(
                    isResetedTag
                        ? 'Etiqueta não gravada'
                        : productIndex != -1
                        ? products[productIndex].name
                        : 'Desconhecido',
                    style: context.theme.typography.xl3.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                error: (e, st) => const Text('Desconhecido'),
                loading: () {
                  return const LoadingWidget();
                },
              ),
              const SizedBox(height: 8),
              Text(
                'OEM: ${isResetedTag ? 'Limpo' : currentRead.productOEM}',
                style: context.theme.typography.lg.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
