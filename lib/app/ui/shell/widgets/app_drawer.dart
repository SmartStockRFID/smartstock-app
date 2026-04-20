import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';

final currentSessionProvider =
    FutureProvider.autoDispose<({String? username, DateTime? timestamp})>((ref) async {
      final username = await CurrentUserStorage.getValue();
      final timestamp = await CurrentSessionTimestampStorage.getValue();

      return (username: username, timestamp: timestamp);
    });

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSession = ref.watch(currentSessionProvider);

    String formatTimestamp(DateTime timestamp) {
      final dateFormat = DateFormat('dd/MM/yyyy').format(timestamp);
      final timeFormat = DateFormat('HH:mm').format(timestamp);

      return 'Conectado desde $dateFormat, às $timeFormat';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: AppConfig.useNewlandTheme ? context.theme.colors.primary : Colors.deepPurple,
            ),
            accountName: Text(
              currentSession.when(
                data: (session) => session.username ?? 'Unautorizado',
                error: (err, trace) => 'Erro',
                loading: () => 'Carregando...',
              ),
              style: context.theme.typography.xl2.copyWith(color: Colors.white, height: 1.25),
            ),
            accountEmail: Text(
              currentSession.when(
                data: (session) => session.timestamp != null
                    ? formatTimestamp(session.timestamp!)
                    : 'Sem mais informações',
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
              await CurrentUserStorage.deleteValue();
              await TokenStorage.deleteTokens();
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
