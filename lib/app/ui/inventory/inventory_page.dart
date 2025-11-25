import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_shared/app_bar.dart';
import 'package:smart_stock/app/ui/inventory/inventory_interface.dart';

@RoutePage()
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Page();
  }
}

class Page extends ConsumerStatefulWidget {
  const Page({super.key});

  @override
  ConsumerState<Page> createState() => _PageState();
}

class _PageState extends ConsumerState<Page> with SingleTickerProviderStateMixin {
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
    final inventoryId = ref.watch(
      inventoryManagerProvider.select((state) => state.currentInventory?.id),
    );
    final isPaused = ref.watch(inventoryManagerProvider.select((state) => state.isPaused));
    final hasEnded = ref.watch(inventoryManagerProvider.select((state) => state.hasEnded));

    return Scaffold(
      appBar: baseAppBar(
        widgetTitle: Row(
          mainAxisSize: MainAxisSize.min, // Para a Row não ocupar a linha toda
          spacing: 8,
          children: [
            Text('Inventário $inventoryId'),
            if (isPaused)
              const Icon(Icons.circle, color: Colors.grey, size: 12)
            else if (hasEnded)
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
