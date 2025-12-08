import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/home/widgets/status_panel_widget.dart';
import 'package:smart_stock/app/utils/internet.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(child: StatusPanelWidget()),
        Navbar(),
      ],
    );
  }
}

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasActiveInventory =
        ref.watch(inventoryManagerProvider.select((state) => state.currentInventory)) != null;

    return Column(
      spacing: 12,
      children: [
        NavLink(
          icon: FIcons.clipboardCheck,
          title: routesTitles[InventoryCheckRoute.name] ?? '',
          badgeLabel: hasActiveInventory ? 'ABERTO' : null,
          href: hasActiveInventory ? const InventorySessionRoute() : const InventoryCheckRoute(),
        ),
        NavLink(
          icon: FIcons.squarePen,
          title: routesTitles[EncodingSetupRoute.name] ?? '',
          href: const EncodingSetupRoute(),
        ),
      ],
    );
  }
}

class NavLink extends ConsumerWidget {
  final IconData icon;

  final String title;
  final PageRouteInfo href;
  final String? badgeLabel;
  const NavLink({
    super.key,
    required this.icon,
    required this.title,
    required this.href,
    this.badgeLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final stockState = ref.watch(stockProvider);
    final isConnected = currentBleState is ConnectedState && stockState.hasValue;

    return FButton(
      style: primaryLargeButton(context, disabled: !isConnected),
      prefix: Icon(icon, size: 20, color: Colors.white),
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.theme.typography.xl2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 2,
              children: [
                if (badgeLabel != null)
                  FBadge(
                    style: FBadgeStyle.secondary(),
                    child: const Text('ABERTO', style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                else
                  const Center(),
                const Icon(FIcons.chevronRight, size: 20, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      onPress: () async {
        if (isConnected) {
          AutoTabsRouter.of(context).navigate(href);
        } else if (await appIsOffline() && stockState.hasError && context.mounted) {
          showFToast(
            context: context,
            alignment: FToastAlignment.topCenter,
            title: const Text('Produtos não carregados', style: TextStyle(color: Colors.red)),
            icon: const Icon(FIcons.packageSearch, color: Colors.red),
          );
        } else if (currentBleState is! ConnectedState) {
          showFToast(
            context: context,
            alignment: FToastAlignment.topCenter,
            duration: const Duration(seconds: 1),
            title: const Text(
              'Aguardando conexão com a pistola',
              style: TextStyle(color: Colors.blue),
            ),
            icon: const Icon(FIcons.bluetooth, color: Colors.blue),
          );
        }
      },
    );
  }
}
