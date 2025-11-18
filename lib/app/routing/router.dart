import 'package:auto_route/auto_route.dart';
import 'package:smart_stock/app/ui/home/home_page.dart';
import 'package:smart_stock/app/ui/inventory/inventory_page.dart';
import 'package:smart_stock/app/ui/inventory_confirmation/confirmation_page.dart';
import 'package:smart_stock/app/ui/labeling/labeling_page.dart';
import 'package:smart_stock/app/ui/main_layout.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: MainLayoutRoute.page,
      path: '/',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
        AutoRoute(page: LabelingRoute.page, path: 'etiquetagem'),
        AutoRoute(page: InventoryConfirmationRoute.page, path: 'inventario/iniciar'),
      ],
    ),
    AutoRoute(page: InventoryRoute.page, path: '/inventario'),
  ];
}

final mainLayoutChildren = [
  AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
  AutoRoute(page: LabelingRoute.page, path: 'etiquetagem'),
  AutoRoute(page: InventoryConfirmationRoute.page, path: 'inventario/iniciar'),
];
