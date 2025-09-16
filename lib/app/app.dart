import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/globals.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  App({super.key});

  static ThemeData theme = ThemeData(
    primaryColor: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  @override
  Widget build(BuildContext context) {
    Enviroment.validate();

    return MaterialApp.router(
      title: 'SmartStock',
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: _appRouter.config(),
      theme: theme,
      builder: (contenxt, child) =>
          FTheme(data: FThemes.zinc.light, child: child!),
    );
  }
}
