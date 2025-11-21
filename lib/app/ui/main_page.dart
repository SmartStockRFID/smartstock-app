import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  AppBar? _getAppBar(BuildContext context, String routeName, bool isAtHome) {
    if (isAtHome) {
      return baseAppBar(
        widgetTitle: Center(
          child: Image.asset(Assets.toyotaLogo, height: MediaQuery.of(context).size.height / 20),
        ),
      );
    }

    final backButton = BackButton(
      onPressed: () {
        context.router.replaceAll([const HomeRoute()]);
      },
    );

    return baseAppBar(title: routesTitles[routeName], leadingButton: isAtHome ? null : backButton);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final String routeName = tabsRouter.topMatch.name;
        final bool isAtHome = routeName == HomeRoute.name;

        return Scaffold(
          appBar: _getAppBar(context, routeName, isAtHome),
          backgroundColor: Colors.white,
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (isAtHome) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else {
                context.router.replaceAll(const [HomeRoute()]);
              }
            },
            child: SafeArea(
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
