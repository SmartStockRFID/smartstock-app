import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
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
        Navbar(),
      ],
    );
  }
}

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    final stockState = ref.watch(stockProvider);
    final isConnected = pistolConnection.fsm.currentState is ConnectedState && stockState.hasValue;

    return Column(
      spacing: 12,
      children: [
        NavLink(
          isConnected: isConnected,
          icon: FIcons.clipboardCheck,
          title: routesTitles[InventoryConfirmationRoute.name] ?? '',
          href: const InventoryConfirmationRoute(),
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
  });

  final bool isConnected;
  final IconData icon;
  final String title;
  final PageRouteInfo href;

  @override
  Widget build(BuildContext context) {
    return FButton(
      style: primaryLargeButton(context, disabled: !isConnected),
      prefix: Icon(icon, size: 20, color: Colors.white),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
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
        if (isConnected) {
          AutoTabsRouter.of(context).navigate(href);
        }
      },
    );
  }
}
