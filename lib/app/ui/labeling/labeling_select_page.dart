import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/current_writing_provider.dart';
import 'package:smart_stock/app/ui/_providers/label_controller.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';

@RoutePage()
class LabelingPage extends ConsumerStatefulWidget {
  const LabelingPage({super.key});

  @override
  ConsumerState<LabelingPage> createState() => _LabelingPageState();
}

enum WritingMode { PRODUCT_CODE, RESET }

class _LabelingPageState extends ConsumerState<LabelingPage> with SingleTickerProviderStateMixin {
  late final FSelectController<CarPart> selectController;
  final radioController = FSelectGroupController<WritingMode>.radio(
    WritingMode.PRODUCT_CODE,
  ); // If you want to remove this default, please check for .value.first on code

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
    final stockState = ref.watch(stockProvider);

    final bool canStartWriting =
        selectController.value != null || radioController.value.firstOrNull == WritingMode.RESET;

    final bool isResetMode = radioController.value.firstOrNull == WritingMode.RESET;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FCard(
          title: Text(
            'Modo de gravação',
            textAlign: TextAlign.center,
            style: typography.sm.copyWith(fontWeight: FontWeight.bold),
          ),
          child: Column(
            spacing: 12,
            children: [
              const SizedBox(height: 4),
              FSelectGroup(
                controller: radioController,
                validator: (values) => values?.isEmpty ?? true ? 'Please select a value.' : null,
                onChange: (value) {
                  setState(() {});
                },
                children: [
                  FRadio.grouped(
                    value: WritingMode.RESET,
                    label: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Restauração', style: context.theme.typography.xl),
                    ),
                  ),
                  FRadio.grouped(
                    value: WritingMode.PRODUCT_CODE,
                    label: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('Produto', style: context.theme.typography.xl),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: stockState.when(
                      data: (parts) {
                        return FSelect<CarPart>.searchBuilder(
                          enabled: radioController.value.firstOrNull == WritingMode.PRODUCT_CODE,
                          controller: selectController,
                          searchFieldProperties: const FSelectSearchFieldProperties(
                            hint: 'Buscar produto...',
                          ),
                          hint: 'Escolha o produto a ser gravado',
                          contentPhysics: const BouncingScrollPhysics(),
                          format: (part) => part.name,
                          filter: (query) => query.isEmpty
                              ? parts
                              : parts.where(
                                  (p) => p.name.toLowerCase().startsWith(query.toLowerCase()),
                                ),
                          contentBuilder: (context, _, parts) => [
                            for (final part in parts)
                              FSelectItem(
                                value: part,
                                title: Text(part.name, style: const TextStyle(color: Colors.black)),
                              ),
                          ],
                          contentLoadingBuilder: (context, style) =>
                              const Text('Buscando produtos...'),
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
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 8.0)),
        FButton(
          onPress: () async {
            if (!canStartWriting) {
              return;
            }

            if (isResetMode) {
              ref.read(writingManagerProvider.notifier).changeToResetMode();
            } else {
              ref
                  .read(writingManagerProvider.notifier)
                  .changeProductBeingWrited(selectController.value?.productCode ?? '');
            }

            await ref
                .read(labelControllerProvider.notifier)
                .writeOnTag(
                  mode: radioController.value.first,
                  productOem: selectController.value?.productCode,
                );

            if (context.mounted) {
              context.router.push(
                WritingRoute(
                  targetProductName: selectController.value?.name,
                  mode: radioController.value.first,
                ),
              );
            }
          },
          prefix: Icon(
            radioController.value.firstOrNull == WritingMode.RESET ? FIcons.eraser : FIcons.save,
            size: 22,
            color: Colors.white,
          ),
          style: primaryLargeButton(context, disabled: !canStartWriting),
          child: Text(
            radioController.value.firstOrNull == WritingMode.RESET
                ? 'LIMPAR ETIQUETAS'
                : 'GRAVAR ETIQUETAS',
            style: context.theme.typography.xl2.copyWith(color: Colors.white),
          ),
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
