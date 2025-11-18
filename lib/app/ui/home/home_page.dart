import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/home/status_panel_widget.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(child: StatusPanelWidget()),
        Column(
          spacing: 15,
          children: [
            ConferenceButton(),
            LabelingButton(),
            // ResetButton(),
            // ConferencesHistory(),
          ],
        ),

        // Center(child: StockStatusWidget()),
      ],
    );
  }
}

// TODO: Refator como NavigationButton talvez, mesmo que fique só nesse arquivo
class ConferenceButton extends ConsumerWidget {
  const ConferenceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    final stockState = ref.watch(stockProvider);
    bool isConnected() => true;
    // pistolConnection.fsm.currentState is ConnectedState && stockState.hasValue;
    return FButton(
      style: isConnected()
          ? createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.primary,
              foregroundColor: context.theme.colors.primaryForeground,
            )
          : createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.secondary,
              foregroundColor: context.theme.colors.disable(
                context.theme.colors.secondaryForeground,
              ),
            ),
      prefix: isConnected()
          ? const Icon(FIcons.scanText, size: 20, color: Colors.white)
          : const Icon(FIcons.scanText, size: 20, color: Colors.grey),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Leitura',
              style: context.theme.typography.xl2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(FIcons.chevronRight, size: 20, color: Colors.white),
          ],
        ),
      ),
      onPress: () {
        if (isConnected()) {
          AutoTabsRouter.of(context).navigate(const InventoryConfirmationRoute());
        }
      },
    );
  }
}

class LabelingButton extends ConsumerWidget {
  const LabelingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    final stockState = ref.watch(stockProvider);
    bool isConnected() => true;
    // pistolConnection.fsm.currentState is ConnectedState && stockState.hasValue;
    return FButton(
      style: isConnected()
          ? createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.primary,
              foregroundColor: context.theme.colors.primaryForeground,
            )
          : createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.secondary,
              foregroundColor: context.theme.colors.disable(
                context.theme.colors.secondaryForeground,
              ),
            ),
      prefix: isConnected()
          ? const Icon(FIcons.squarePen, size: 20, color: Colors.white)
          : const Icon(FIcons.squarePen, size: 20, color: Colors.grey),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Etiquetagem',
              style: context.theme.typography.xl2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(FIcons.chevronRight, size: 24, color: Colors.white),
          ],
        ),
      ),
      onPress: () {
        if (isConnected()) {
          AutoTabsRouter.of(context).navigate(const LabelingRoute());
        }
      },
    );
  }
}
