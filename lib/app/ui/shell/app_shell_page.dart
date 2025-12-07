import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/app_bar.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';
import 'package:smart_stock/app/ui/inventory/session/widgets/inventory_modals_widgets.dart';
import 'package:smart_stock/app/ui/shell/logic/quick_read_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

final currentSessionProvider =
    FutureProvider.autoDispose<({String? username, DateTime? timestamp})>((ref) async {
      final username = await CurrentUserStorage.getValue();
      final timestamp = await CurrentSessionTimestampProvider.getValue();

      return (username: username, timestamp: timestamp);
    });

final getIsFirstSession = FutureProvider.autoDispose<bool>((ref) async {
  return await FirstTimeOnAppStorage.getValue();
});

@RoutePage()
class AppShellPage extends HookConsumerWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModalOpen = useState(false);

    ref.listen(quickReadProvider, (_, state) async {
      if ((ModalRoute.of(context)?.isCurrent ?? false) && state.hasValue && !isModalOpen.value) {
        isModalOpen.value = true;
        Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

        await showFSheet(
          style: getModalBlurStyle(context).call,
          context: context,
          side: FLayout.btt,
          builder: (context) => ModalContent(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Leitura rápida',
                        style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                      ),

                      const Text(
                        'O conteúdo atual da etiqueta lida é:',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  QuickReadCurrentItem(firstRead: state.value!),
                  FButton(
                    style: createLargeStyle(
                      context: context,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.lightGreen,
                    ),
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'VOLTAR',
                      style: context.theme.typography.xl2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        isModalOpen.value = false;
      }
    });

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
                child: FToaster(child: ToastRunner(child: child)),
              ),
            ),
          ),
          drawer: isAtHome ? const MainDrawer() : null,
        );
      },
    );
  }

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
}

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
              color: useNewlandTheme ? context.theme.colors.primary : Colors.deepPurple,
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

class QuickReadCurrentItem extends HookConsumerWidget {
  final ReadingResponseContent firstRead;

  const QuickReadCurrentItem({required this.firstRead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamRead = ref.watch(quickReadProvider);
    final stockState = ref.watch(stockProvider);
    final currentRead = streamRead.value ?? firstRead;

    final isValueChanging = useState(false);

    ref.listen(quickReadProvider, (_, state) async {
      if (state.hasValue) {
        isValueChanging.value = true;

        await Future.delayed(const Duration(milliseconds: 120));

        isValueChanging.value = false;
      }
    });

    return CustomCard(
      child: SizedBox(
        height: 150,
        child: isValueChanging.value
            ? const LoadingWidget()
            : Center(child: _buildReadingState(context, stockState, currentRead)),
      ),
    );
  }

  Widget _buildReadingState(
    BuildContext context,
    AsyncValue<List<CarPart>> stockState,
    ReadingResponseContent currentRead,
  ) {
    final isResetedTag = currentRead.productOEM == emptyTagOEM;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stockState.when(
                data: (parts) {
                  final productIndex = parts.indexWhere(
                    (p) => p.productCode == currentRead.productOEM,
                  );
                  return Text(
                    isResetedTag
                        ? 'Etiqueta virgem'
                        : productIndex != -1
                        ? parts[productIndex].name
                        : 'Desconhecido',
                    style: context.theme.typography.xl3.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                error: (e, st) => const Text('Desconhecido'),
                loading: () {
                  return const LoadingWidget();
                },
              ),
              const SizedBox(height: 8),
              Text(
                'OEM: ${isResetedTag ? 'Limpo' : currentRead.productOEM}',
                style: context.theme.typography.lg.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ToastRunner extends ConsumerWidget {
  final Widget child;

  const ToastRunner({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(getIsFirstSession, (_, state) async {
      if (state.hasValue && state.value == true) {
        showFToast(
          context: context,
          title: const Text('Dica: Leitura rápida'),
          description: const Text('Aperte o gatilho para ver o conteúdo de uma etiqueta'),
          alignment: FToastAlignment.bottomCenter,
        );
        await FirstTimeOnAppStorage.setNegative();
      }
    });

    return child;
  }
}
