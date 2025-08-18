import 'package:flutter/material.dart';
import 'package:smart_stock/app/routing/router.dart';

class App extends StatelessWidget {
    final _appRouter = AppRouter();
    
    App({super.key});

    static ThemeData theme = ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    @override
    Widget build(BuildContext context) {

        return MaterialApp.router(
            title: "SmartStock",
            routerConfig: _appRouter.config(),
            theme: theme,
        );
    }
}
