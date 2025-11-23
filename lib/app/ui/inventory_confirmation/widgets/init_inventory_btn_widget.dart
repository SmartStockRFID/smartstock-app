import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_shared/types.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class InitInventoryButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initReqStatus = ref.watch(
      inventoryManagerProvider.select((state) => state.initReqStatus),
    );

    final initBtnLabel = ref.watch(
      inventoryManagerProvider.select((state) => state.initButtonLabel),
    );

    final canClick = initReqStatus == RequestStatus.idle || initReqStatus == RequestStatus.success;

    return FButton(
      style: primaryLargeButton(context, disabled: !canClick),
      onPress: () async {
        if (initReqStatus == RequestStatus.idle) {
          await ref.read(inventoryManagerProvider.notifier).startInventoryFlow();
        } else if (initReqStatus == RequestStatus.success) {
          Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
          await context.router.push(const InventoryRoute());
        }
      },
      child: Text(initBtnLabel, style: context.theme.typography.xl2.copyWith(color: Colors.white)),
    );
  }
}
