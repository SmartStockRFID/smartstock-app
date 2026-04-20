import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/ui/inventory/check/logic/future_providers.dart';
import 'package:smart_stock/app/ui/inventory/check/widgets/connection_checker_widget.dart';
import 'package:smart_stock/app/ui/inventory/check/widgets/init_inventory_button_widget.dart';
import 'package:smart_stock/app/ui/inventory/check/widgets/inventory_status_widget.dart';
import 'package:smart_stock/app/ui/inventory/check/widgets/responsible_employee_widget.dart';

@RoutePage()
class InventoryCheckPage extends ConsumerWidget {
  const InventoryCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentUserProvider, asReload: true);
            ref.invalidate(getActiveInventoryProvider, asReload: true);
          },

          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 16,
              children: [ResponsibleEmployee(), InventoryStatus(), ConnectionChecker()],
            ),
          ),
        ),
        InitInventoryButton(),
      ],
    );
  }
}
