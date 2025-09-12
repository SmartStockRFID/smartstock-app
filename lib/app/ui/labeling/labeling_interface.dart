import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/widgets/select.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';

class LabelingPageInterface extends ConsumerWidget {
  const LabelingPageInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    return Column(
      children: [
        const Text('Busque o produto'),
        stockState.when(
          data: (parts) {
            return FSelect<String>.searchBuilder(
              hint: 'Digite o nome do produto',
              format: (s) => s,
              filter: (query) => query.isEmpty
                  ? parts.map((part) => part.name).toList()
                  : parts
                        .where((p) => p.name.toLowerCase().startsWith(query.toLowerCase()))
                        .map((p) => p.name),
              contentBuilder: (context, _, fruits) => [
                for (final part in parts)
                  FSelectItem.raw(value: part.name, child: Text(part.name)),
              ],
            );
          },
          error: (e, stackTrace) {
            return const Text('Erro :/');
          },
          loading: () {
            return const Text('Buscando produtos...');
          },
        ),
      ],
    );
  }
}
