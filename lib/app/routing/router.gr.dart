// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

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
/// [InventoryConfirmationPage]
class InventoryConfirmationRoute extends PageRouteInfo<void> {
  const InventoryConfirmationRoute({List<PageRouteInfo>? children})
    : super(InventoryConfirmationRoute.name, initialChildren: children);

  static const String name = 'InventoryConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InventoryConfirmationPage();
    },
  );
}

/// generated route for
/// [InventoryPage]
class InventoryRoute extends PageRouteInfo<void> {
  const InventoryRoute({List<PageRouteInfo>? children})
    : super(InventoryRoute.name, initialChildren: children);

  static const String name = 'InventoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InventoryPage();
    },
  );
}

/// generated route for
/// [LabelingPage]
class LabelingRoute extends PageRouteInfo<void> {
  const LabelingRoute({List<PageRouteInfo>? children})
    : super(LabelingRoute.name, initialChildren: children);

  static const String name = 'LabelingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LabelingPage();
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
/// [MainLayoutPage]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
    : super(MainLayoutRoute.name, initialChildren: children);

  static const String name = 'MainLayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainLayoutPage();
    },
  );
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

/// generated route for
/// [WritingPage]
class WritingRoute extends PageRouteInfo<WritingRouteArgs> {
  WritingRoute({
    required String? targetProductName,
    required WritingMode mode,
    List<PageRouteInfo>? children,
  }) : super(
         WritingRoute.name,
         args: WritingRouteArgs(
           targetProductName: targetProductName,
           mode: mode,
         ),
         initialChildren: children,
       );

  static const String name = 'WritingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WritingRouteArgs>();
      return WritingPage(
        targetProductName: args.targetProductName,
        mode: args.mode,
      );
    },
  );
}

class WritingRouteArgs {
  const WritingRouteArgs({required this.targetProductName, required this.mode});

  final String? targetProductName;

  final WritingMode mode;

  @override
  String toString() {
    return 'WritingRouteArgs{targetProductName: $targetProductName, mode: $mode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WritingRouteArgs) return false;
    return targetProductName == other.targetProductName && mode == other.mode;
  }

  @override
  int get hashCode => targetProductName.hashCode ^ mode.hashCode;
}
