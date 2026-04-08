import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/inventory/check/inventory_check_page.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

final initInventoryMutation = Mutation<void>();

Future<void> Function(MutationTransaction) initInventoryRun(BuildContext context, WidgetRef ref) {
  return (tsx) async {
    await tsx.get(inventoryManagerProvider.notifier).startInventoryFlow();

    Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

    initInventoryMutation.reset(ref);

    ref.invalidate(currentUserProvider, asReload: true);
    ref.invalidate(getActiveInventoryProvider, asReload: true);

    if (context.mounted) {
      context.router.replaceAll([const HomeRoute(), const InventorySessionRoute()]);
    }
  };
}
