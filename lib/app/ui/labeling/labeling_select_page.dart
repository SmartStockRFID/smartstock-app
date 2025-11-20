import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/providers/current_writing_provider.dart';
import 'package:smart_stock/app/ui/providers/label_controller.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/update_stock_btn.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';

@RoutePage()
class LabelingPage extends ConsumerStatefulWidget {
  const LabelingPage({super.key});

  @override
  ConsumerState<LabelingPage> createState() => _LabelingPageState();
}

class _LabelingPageState extends ConsumerState<LabelingPage> with SingleTickerProviderStateMixin {
  late final FSelectController<CarPart> selectController;

  @override
  void initState() {
    super.initState();
    selectController = FSelectController<CarPart>(vsync: this);

    selectController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final writeState = ref.watch(createProductControllerProvider);
    final typography = context.theme.typography;
    final bool buttonDisabled = selectController.value == null;

    return Column(
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
          child: Column(
            spacing: 12,
            children: [
              SearchCarPart(selectController: selectController),
              UpdateStockButton(),
            ],
          ),
        ),
        const Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 8.0)),

        Column(
          spacing: 12,
          children: [
            FButton(
              onPress: () async {
                if (selectController.value == null) {
                  return;
                }
                ref
                    .read(writingManagerProvider.notifier)
                    .changeProductBeingWrited(selectController.value!.productCode);
                await ref
                    .read(labelControllerProvider.notifier)
                    .writeOnTag(productOem: selectController.value!.productCode);

                if (context.mounted) {
                  context.router.push(
                    WritingRoute(targetProductName: selectController.value!.name),
                  );
                }
              },
              prefix: const Icon(FIcons.save, size: 22, color: Colors.white),
              style: primaryLargeButton(context, disabled: buttonDisabled),
              child: Text(
                'GRAVAR ETIQUETA',
                style: context.theme.typography.xl2.copyWith(color: Colors.white),
              ),
            ),
            FButton(
              style: secondaryLargeButton(context),
              child: Text(
                'VOLTAR',
                style: context.theme.typography.xl2.copyWith(color: Colors.black),
              ),
              onPress: () {
                context.router.replaceAll([const HomeRoute()]);
              },
            ),
          ],
        ),
      ],
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
                searchFieldProperties: const FSelectSearchFieldProperties(
                  hint: 'Buscar produto...',
                ),
                description: const Text('Escolha o produto a ser gravado'),
                contentPhysics: const BouncingScrollPhysics(),
                format: (part) => part.name,
                filter: (query) => query.isEmpty
                    ? parts
                    : parts.where((p) => p.name.toLowerCase().startsWith(query.toLowerCase())),
                contentBuilder: (context, _, parts) => [
                  for (final part in parts)
                    FSelectItem(
                      value: part,
                      title: Text(part.name, style: const TextStyle(color: Colors.black)),
                    ),
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
