// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AppShellPage]
class AppShellRoute extends PageRouteInfo<void> {
  const AppShellRoute({List<PageRouteInfo>? children})
    : super(AppShellRoute.name, initialChildren: children);

  static const String name = 'AppShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppShellPage();
    },
  );
}

/// generated route for
/// [DevicesPage]
class DevicesRoute extends PageRouteInfo<void> {
  const DevicesRoute({List<PageRouteInfo>? children})
    : super(DevicesRoute.name, initialChildren: children);

  static const String name = 'DevicesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return DevicesPage();
    },
  );
}

/// generated route for
/// [EncodingHistoryPage]
class EncodingHistoryRoute extends PageRouteInfo<void> {
  const EncodingHistoryRoute({List<PageRouteInfo>? children})
    : super(EncodingHistoryRoute.name, initialChildren: children);

  static const String name = 'EncodingHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return EncodingHistoryPage();
    },
  );
}

/// generated route for
/// [EncodingProcessPage]
class EncodingProcessRoute extends PageRouteInfo<EncodingProcessRouteArgs> {
  EncodingProcessRoute({
    required String? targetProductName,
    required WritingMode mode,
    List<PageRouteInfo>? children,
  }) : super(
         EncodingProcessRoute.name,
         args: EncodingProcessRouteArgs(
           targetProductName: targetProductName,
           mode: mode,
         ),
         initialChildren: children,
       );

  static const String name = 'EncodingProcessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EncodingProcessRouteArgs>();
      return EncodingProcessPage(
        targetProductName: args.targetProductName,
        mode: args.mode,
      );
    },
  );
}

class EncodingProcessRouteArgs {
  const EncodingProcessRouteArgs({
    required this.targetProductName,
    required this.mode,
  });

  final String? targetProductName;

  final WritingMode mode;

  @override
  String toString() {
    return 'EncodingProcessRouteArgs{targetProductName: $targetProductName, mode: $mode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EncodingProcessRouteArgs) return false;
    return targetProductName == other.targetProductName && mode == other.mode;
  }

  @override
  int get hashCode => targetProductName.hashCode ^ mode.hashCode;
}

/// generated route for
/// [EncodingSetupPage]
class EncodingSetupRoute extends PageRouteInfo<void> {
  const EncodingSetupRoute({List<PageRouteInfo>? children})
    : super(EncodingSetupRoute.name, initialChildren: children);

  static const String name = 'EncodingSetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EncodingSetupPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return HomePage();
    },
  );
}

/// generated route for
/// [InventoryCheckPage]
class InventoryCheckRoute extends PageRouteInfo<void> {
  const InventoryCheckRoute({List<PageRouteInfo>? children})
    : super(InventoryCheckRoute.name, initialChildren: children);

  static const String name = 'InventoryCheckRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InventoryCheckPage();
    },
  );
}

/// generated route for
/// [InventorySessionPage]
class InventorySessionRoute extends PageRouteInfo<void> {
  const InventorySessionRoute({List<PageRouteInfo>? children})
    : super(InventorySessionRoute.name, initialChildren: children);

  static const String name = 'InventorySessionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InventorySessionPage();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({bool shouldRedirect = false, List<PageRouteInfo>? children})
    : super(
        LoginRoute.name,
        args: LoginRouteArgs(shouldRedirect: shouldRedirect),
        initialChildren: children,
      );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginScreen(shouldRedirect: args.shouldRedirect);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.shouldRedirect = false});

  final bool shouldRedirect;

  @override
  String toString() {
    return 'LoginRouteArgs{shouldRedirect: $shouldRedirect}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return shouldRedirect == other.shouldRedirect;
  }

  @override
  int get hashCode => shouldRedirect.hashCode;
}

/// generated route for
/// [WelcomeScreen]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomeScreen();
    },
  );
}
