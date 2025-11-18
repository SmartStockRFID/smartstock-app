import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/ui/inventory/inventory_interface.dart';
import 'package:smart_stock/app/ui/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

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
    final confState = ref.watch(conferenceManagerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(
          widgetTitle: Row(
            mainAxisSize: MainAxisSize.min, // Para a Row não ocupar a linha toda
            children: [
              Text('Inventário ${confState.id}'),
              const SizedBox(width: 8),
              FadeTransition(
                opacity: _animationController,
                child: const Icon(Icons.circle, color: Colors.green, size: 12),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: const ConferencePageInterface(),
      ),
    );
  }
}
