import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_shared/types.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';
import 'package:smart_stock/app/ui/home/status_panel_widget.dart';

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
    final currentStsdate = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final stockState = ref.watch(stockProvider);
    final isConnected = currentStsdate is ConnectedState && stockState.hasValue;
    final initInventoryStatus = ref.watch(
      inventoryManagerProvider.select((state) => state.initReqStatus),
    );

    return Column(
      spacing: 12,
      children: [
        NavLink(
          isConnected: isConnected,
          icon: FIcons.clipboardCheck,
          title: routesTitles[InventoryConfirmationRoute.name] ?? '',
          badgeLabel: initInventoryStatus == RequestStatus.success ? 'ABERTO' : null,
          href: initInventoryStatus == RequestStatus.success
              ? const InventoryRoute()
              : const InventoryConfirmationRoute(),
        ),
        NavLink(
          isConnected: isConnected,
          icon: FIcons.squarePen,
          title: routesTitles[LabelingRoute.name] ?? '',
          href: const LabelingRoute(),
        ),
      ],
    );
  }
}

class NavLink extends StatelessWidget {
  const NavLink({
    super.key,
    required this.isConnected,
    required this.icon,
    required this.title,
    required this.href,
    this.badgeLabel,
  });

  final bool isConnected;
  final IconData icon;
  final String title;
  final PageRouteInfo href;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
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
      onPress: () {
        if (isConnected) {
          AutoTabsRouter.of(context).navigate(href);
        }
      },
    );
  }
}
