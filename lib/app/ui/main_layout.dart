import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  AppBar? _getAppBar(BuildContext context, TabsRouter tabsRouter) {
    final String routeName = tabsRouter.topMatch.name;
    final bool isAtHome = routeName == HomeRoute.name;

    final backButton = BackButton(
      onPressed: () {
        context.router.replaceAll([const HomeRoute()]);
      },
    );

    switch (routeName) {
      case HomeRoute.name:
        return baseAppBar(
          leadingButton: null,
          widgetTitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text("Newland Toyota"),
              // const SizedBox(width: 10),
              Image.asset(
                Assets.toyotaLogo,
                // TODO: Ajeitar a proporção
                height: MediaQuery.of(context).size.height / 15,
              ),
            ],
          ),
        );
      case InventoryConfirmationRoute.name:
        return baseAppBar(title: 'Inventário', leadingButton: isAtHome ? null : backButton);
      case LabelingRoute.name:
        return baseAppBar(title: 'Etiquetagem', leadingButton: isAtHome ? null : backButton);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final String routeName = tabsRouter.topMatch.name;
        final bool isAtHome = routeName == HomeRoute.name;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (isAtHome) {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            } else {
              context.router.replaceAll(const [HomeRoute()]);
            }
          },
          child: Scaffold(
            appBar: _getAppBar(context, tabsRouter),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
