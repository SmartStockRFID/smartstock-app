import 'package:auto_route/auto_route.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/domain/auth.dart';
import 'package:smart_stock/app/ui/auth/login_page.dart';
import 'package:smart_stock/app/ui/devices/devices_page.dart';
import 'package:smart_stock/app/ui/encoding/process/encoding_process_page.dart';
import 'package:smart_stock/app/ui/encoding/setup/encoding_setup_page.dart';
import 'package:smart_stock/app/ui/home/home_page.dart';
import 'package:smart_stock/app/ui/inventory/check/inventory_check_page.dart';
import 'package:smart_stock/app/ui/inventory/session/inventory_session_page.dart';
import 'package:smart_stock/app/ui/shell/app_shell_page.dart';
import 'package:smart_stock/app/ui/welcome/welcome_page.dart';

part 'router.gr.dart';

final routesTitles = {InventoryCheckRoute.name: 'Inventário', EncodingSetupRoute.name: 'Gravação'};

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: WelcomeRoute.page, initial: true, guards: [WelcomeRedirectGuard()]),
    AutoRoute(
      page: AppShellRoute.page,
      path: '/',
      guards: [AuthGuard()],
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: EncodingSetupRoute.page),
        AutoRoute(page: InventoryCheckRoute.page),
      ],
    ),
    AutoRoute(page: DevicesRoute.page),
    AutoRoute(page: LoginRoute.page, keepHistory: false),
    AutoRoute(page: InventorySessionRoute.page, guards: [AuthGuard()]),
    AutoRoute(page: EncondingProcessRoute.page, guards: [AuthGuard()]),
  ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    final tokens = await TokenStorage.getTokens();
    final refresh = tokens.refresh;

    final authenticated = refresh != null && refreshTokenIsFresh(refresh.expiresAt);

    if (authenticated) {
      resolver.next(true);
    } else {
      await router.push(LoginRoute());
      resolver.next(true);
      // we redirect the user to our login page
      // tip: use resolver.redirectUntil to have the redirected route
      // automatically removed from the stack when the resolver is completed
      // var result = await context.router.push<bool>(LoginRoute());

      // resolver.redirectUntil(
      //   LoginRoute(onResult: (success) {
      //     // if success == true the navigation will be resumed
      //     // else it will be aborted
      //     resolver.next(success);
      // },
      // );
      // );
    }
  }
}

class WelcomeRedirectGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final firstTimeOnApp = await FirstTimeOnAppStorage.getValue();
    if (firstTimeOnApp) {
      resolver.next(true);
    } else {
      await router.push<bool>(const HomeRoute());
    }
  }
}
