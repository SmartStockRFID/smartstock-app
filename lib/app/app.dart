import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/globals.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  App({super.key});

  final theme = useNewlandTheme
      ? FThemes.red.light.copyWith(
          typography: FTypography.inherit(
            colors: FThemes.red.light.colors,
            defaultFontFamily: 'Avenir95',
          ).copyWith(xl2: FThemes.red.light.typography.xl2.copyWith(height: 1.8)),
        )
      : FThemes.zinc.light.copyWith(
          typography: FTypography.inherit(
            colors: FThemes.zinc.light.colors,
            defaultFontFamily: GoogleFonts.montserrat().fontFamily ?? 'packages/forui/Inter',
          ),
        );

  @override
  Widget build(BuildContext context) {
    Enviroment.validate();

    return MaterialApp.router(
      title: 'SmartStock',
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: _appRouter.config(),
      builder: (contenxt, child) => FTheme(data: theme, child: child!),
      debugShowCheckedModeBanner: false,
    );
  }
}
