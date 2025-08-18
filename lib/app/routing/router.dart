import 'package:auto_route/auto_route.dart';
import 'package:smart_stock/app/ui/home/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      initial: true
    ),
  ];
}