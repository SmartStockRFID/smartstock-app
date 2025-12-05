import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/experimental/mutation.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_mutations/finish_inventory_mutation.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_shared/app_bar.dart';
import 'package:smart_stock/app/ui/inventory/inventory_interface.dart';
import 'package:smart_stock/app/ui/inventory/widgets/inventory_modals_widgets.dart';

mixin class InventoryState {
  int? inventoryId(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory?.id));
  bool isPaused(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.isPaused));

  bool hasEnded(WidgetRef ref) => ref.watch(finishInventoryMutation) is MutationSuccess;
}

@RoutePage()
class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage>
    with InventoryState, SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar(
        actions: [Padding(padding: const EdgeInsets.only(right: 8), child: InventoryModalFinish())],
        widgetTitle: Row(
          mainAxisSize: MainAxisSize.min, // Para a Row não ocupar a linha toda
          spacing: 8,
          children: [
            Text('Inventário ${inventoryId(ref) ?? 'local'}'),
            if (isPaused(ref))
              const Icon(Icons.circle, color: Colors.grey, size: 12)
            else if (hasEnded(ref))
              const Icon(Icons.circle, color: Colors.blue, size: 12)
            else
              FadeTransition(
                opacity: _animationController,
                child: const Icon(Icons.circle, color: Colors.green, size: 12),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          context.router.replaceAll(const [HomeRoute()]);
        },
        child: SafeArea(child: InventoryPageInterface()),
      ),
    );
  }
}
