import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/widgets/app_bar.dart';
import 'package:smart_stock/app/ui/inventory/session/logic/inventory_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/current_item_widget.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals/inventory_pause_modal_widget.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/modals/inventory_sync_modal_widget.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/reading_history_widget.dart';
import 'package:smart_stock/app/utils/logger.dart';

class InventorySessionInterface extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      logger.i('Sincronização automática feita!');
      ref.read(inventoryManagerProvider.notifier).syncInventory();
    });
    ref.watch(inventoryBleListenerProvider);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [CurrentItem(), const SizedBox(height: 16), ReadingHistory()],
              ),
            ),
          ),
          Column(children: [const SizedBox(height: 8), InventoryPauseModal()]),
        ],
      ),
    );
  }
}

@RoutePage()
class InventorySessionPage extends ConsumerStatefulWidget {
  const InventorySessionPage({super.key});

  @override
  ConsumerState<InventorySessionPage> createState() => _InventorySessionPageState();
}

mixin class InventorySessionState {
  int? inventoryId(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory?.id));

  bool isPaused(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.isPaused));
}

class _InventorySessionPageState extends ConsumerState<InventorySessionPage>
    with InventorySessionState, SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar(
        actions: [Padding(padding: const EdgeInsets.only(right: 8), child: InventorySyncModal())],
        widgetTitle: Row(
          mainAxisSize: MainAxisSize.min, // Para a Row não ocupar a linha toda
          spacing: 8,
          children: [
            Text('Inventário ${inventoryId(ref) ?? 'local'}'),
            if (isPaused(ref))
              const Icon(Icons.circle, color: Colors.grey, size: 12)
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
        child: SafeArea(child: InventorySessionInterface()),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }
}
