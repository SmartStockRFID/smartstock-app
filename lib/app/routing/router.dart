import 'package:auto_route/auto_route.dart';
import 'package:smart_stock/app/ui/inventory/inventory_page.dart';
import 'package:smart_stock/app/ui/inventory_confirmation/confirmation_page.dart';
import 'package:smart_stock/app/ui/home/home_page.dart';
import 'package:smart_stock/app/ui/labeling/labeling_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/', initial: true),
    AutoRoute(page: ConferenceRoute.page, path: '/conferencia'),
    AutoRoute(page: LabelingRoute.page, path: '/etiquetagem'),
    AutoRoute(
      page: ConferenceConfirmationRoute.page,
      path: '/conferencia/iniciar',
    ),
  ];
}
