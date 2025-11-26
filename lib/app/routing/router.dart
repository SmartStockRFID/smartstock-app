import 'package:auto_route/auto_route.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/ui/home/home_page.dart';
import 'package:smart_stock/app/ui/inventory/inventory_page.dart';
import 'package:smart_stock/app/ui/inventory_confirmation/confirmation_page.dart';
import 'package:smart_stock/app/ui/labeling/labeling_select_page.dart';
import 'package:smart_stock/app/ui/labeling/writing_page.dart';
import 'package:smart_stock/app/ui/login/login_page.dart';
import 'package:smart_stock/app/ui/main_page.dart';
import 'package:smart_stock/app/ui/welcome/welcome_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: WelcomeRoute.page, initial: true, guards: [WelcomeRedirectGuard()]),
    AutoRoute(
      page: MainLayoutRoute.page,
      path: '/',
      guards: [AuthGuard()],
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: LabelingRoute.page, path: 'etiquetagem'),
        AutoRoute(page: InventoryConfirmationRoute.page, path: 'inventario/iniciar'),
      ],
    ),
    AutoRoute(page: LoginRoute.page, path: '/login', keepHistory: false),
    AutoRoute(page: InventoryRoute.page, path: '/inventario', guards: [AuthGuard()]),
    AutoRoute(page: WritingRoute.page, path: '/etiquetagem/iniciar', guards: [AuthGuard()]),
  ];
}

final routesTitles = {
  InventoryConfirmationRoute.name: 'Inventário',
  LabelingRoute.name: 'Gravação',
};

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    final authenticated = await TokenStorage.getToken() != null;

    if (authenticated) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirectUntil to have the redirected route
      // automatically removed from the stack when the resolver is completed
      // var result = await context.router.push<bool>(LoginRoute());

      await router.push(LoginRoute());
      resolver.next(true);
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
