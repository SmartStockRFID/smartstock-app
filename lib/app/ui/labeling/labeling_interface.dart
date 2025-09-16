import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/ui/providers/label_controller.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';
import 'package:smart_stock/app/utils/logger.dart';

class LabelingPageInterface extends ConsumerStatefulWidget {
  const LabelingPageInterface({super.key});

  @override
  ConsumerState<LabelingPageInterface> createState() => _LabelingPageInterfaceState();
}

class _LabelingPageInterfaceState extends ConsumerState<LabelingPageInterface>
    with SingleTickerProviderStateMixin {
  late final FSelectController<CarPart> selectController;

  @override
  void initState() {
    super.initState();
    selectController = FSelectController<CarPart>(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // final writeState = ref.watch(createProductControllerProvider);
    final typography = context.theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FCard(
            title: Text(
              'Produto',
              textAlign: TextAlign.center,
              style: typography.sm.copyWith(
                color: context.theme.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: SearchCarPart(selectController: selectController),
          ),
          const Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 8.0)),
          FButton(
            onPress: () {
              logger.d('${selectController.value?.name}');
              ref
                  .read(labelControllerProvider.notifier)
                  .writeOnTag(productOem: selectController.value?.productCode ?? '');
            },
            prefix: const Icon(FIcons.save, size: 20, color: Colors.white),
            style: createLargeStyle(context: context, backgroundColor: context.theme.colors.primary, foregroundColor: context.theme.colors.primaryForeground),
            child: const Text('GRAVAR ETIQUETA'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    selectController.dispose();
    super.dispose();
  }
}

class SearchCarPart extends ConsumerWidget {
  final FSelectController<CarPart> selectController;

  const SearchCarPart({super.key, required this.selectController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: stockState.when(
            data: (parts) {
              return FSelect<CarPart>.searchBuilder(
                hint: 'Selecione o Produto',
                controller: selectController,
                description: const Text('Escolha o produto a ser gravado'),
                contentPhysics: const BouncingScrollPhysics(),
                format: (part) => part.name,
                filter: (query) => query.isEmpty
                    ? parts
                    : parts.where((p) => p.name.toLowerCase().startsWith(query.toLowerCase())),
                contentBuilder: (context, _, parts) => [
                  for (final part in parts) FSelectItem(value: part, title: Text(part.name)),
                ],
                contentLoadingBuilder: (context, style) => const Text('Buscando produtos...'),
                contentErrorBuilder: (context, error, stackTrace) =>
                    const Text('Serviço Indisponível'),
              );
            },
            error: (e, stackTrace) {
              return const Text('Serviço Indisponível');
            },
            loading: () {
              return const Text('Buscando produtos...');
            },
          ),
        ),
      ],
    );
  }
}
