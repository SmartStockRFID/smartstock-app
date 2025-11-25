import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_shared/app_bar.dart';
import 'package:smart_stock/app/ui/_shared/loading_widget.dart';
import 'package:intl/intl.dart';

@RoutePage()
class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  AppBar? _getAppBar(BuildContext context, String routeName, bool isAtHome) {
    if (isAtHome) {
      return baseAppBar(
        widgetTitle: useNewlandTheme
            ? SvgPicture.asset(Assets.newlandLogo, height: MediaQuery.of(context).size.height / 20)
            : Icon(FIcons.origami, size: MediaQuery.of(context).size.height / 20),
      );
    }

    final backButton = BackButton(
      onPressed: () {
        context.router.replaceAll([const HomeRoute()]);
      },
    );

    return baseAppBar(title: routesTitles[routeName], leadingButton: isAtHome ? null : backButton);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final String routeName = tabsRouter.topMatch.name;
        final bool isAtHome = routeName == HomeRoute.name;

        return Scaffold(
          appBar: _getAppBar(context, routeName, isAtHome),
          backgroundColor: Colors.white,
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (isAtHome) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else {
                context.router.replaceAll(const [HomeRoute()]);
              }
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: child,
              ),
            ),
          ),
          drawer: isAtHome ? const MainDrawer() : null,
        );
      },
    );
  }
}

final currentSessionProvider = FutureProvider.autoDispose<(String?, DateTime?)>((ref) async {
  final username = await PreferencesManager.getCurrentUser();
  final timestamp = await PreferencesManager.getCurrentUserSessionTimestamp();

  return (username, timestamp);
});

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSession = ref.watch(currentSessionProvider);

    String formatTimestamp(DateTime timestamp) {
      final dateFormat = DateFormat('dd/MM/yyyy').format(timestamp);
      final timeFormat = DateFormat('hh:mm').format(timestamp);

      return 'Conectado desde $dateFormat, às $timeFormat';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: useNewlandTheme ? context.theme.colors.primary : Colors.deepPurple,
            ),
            accountName: Text(
              currentSession.when(
                data: (session) => session.$1 ?? 'Unautorizado',
                error: (err, trace) => 'Erro',
                loading: () => 'Carregando...',
              ),
              style: context.theme.typography.xl2.copyWith(color: Colors.white, height: 1.25),
            ),
            accountEmail: Text(
              currentSession.when(
                data: (session) =>
                    session.$2 != null ? formatTimestamp(session.$2!) : 'Sem mais informações',
                error: (err, trace) => 'Erro',
                loading: () => 'Carregando...',
              ),
              style: context.theme.typography.sm.copyWith(color: Colors.white, height: 1),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: currentSession.hasValue
                  ? const AssetImage(Assets.avatarPlaceholder)
                  : null,
              child: currentSession.isLoading ? const LoadingWidget() : null,
            ),
          ),
          ListTile(
            leading: const Icon(FIcons.logOut),
            title: const Text('Sair'),
            onTap: () async {
              await PreferencesManager.deleteCurrentUser();
              await TokenStorage.deleteToken();
              if (context.mounted) {
                context.router.replaceAll([LoginRoute(shouldRedirect: true)]);
              }
            },
          ),
        ],
      ),
    );
  }
}
