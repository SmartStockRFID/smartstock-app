import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/domain/stock.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';
import 'package:smart_stock/app/ui/_core/widgets/update_stock_btn.dart';
import 'package:smart_stock/app/ui/inventory/check/logic/init_inventory_mutation.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

final currentUserProvider = FutureProvider.autoDispose<String>((ref) async {
  return await CurrentUserStorage.getValue() ?? 'Inautorizado';
});

final getActiveInventoryProvider =
    FutureProvider.autoDispose<({InventorySummary? inventory, bool ok})>((ref) async {
      final inventoryFromCache = ref.read(inventoryManagerProvider).currentInventory;

      if (inventoryFromCache != null) {
        return (inventory: inventoryFromCache, ok: true);
      }

      try {
        final inventoryFromServer = await injector.get<InventoryRepository>().getActiveInventory();

        if (inventoryFromServer != null) {
          ref.read(inventoryManagerProvider.notifier).setInventoryFromServer(inventoryFromServer);
          return (inventory: inventoryFromServer, ok: true);
        }
        return (inventory: null, ok: true);
      } catch (error) {
        logger.e(error);
        return (inventory: null, ok: false);
      }
    });

class InitInventoryButton extends HookConsumerWidget with _InitInventoryState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final btnCanBeClicked =
        currentUser(ref).hasValue &&
        !currentUser(ref).isLoading &&
        !queryActiveInventory(ref).isLoading &&
        stockState(ref).hasValue &&
        isInitIdle(ref);

    return FButton(
      style: primaryLargeButton(context, disabled: !btnCanBeClicked),
      onPress: () async {
        if (!btnCanBeClicked) {
          if (!stockState(ref).hasValue) {
            showFToast(
              context: context,
              alignment: FToastAlignment.topCenter,
              title: const Text('Produtos não carregados', style: TextStyle(color: Colors.red)),
              icon: const Icon(FIcons.packageSearch, color: Colors.red),
            );
          }
          return;
        }

        if (queryActiveInventory(ref).value?.inventory != null) {
          Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
          context.router.replaceAll([const HomeRoute(), const InventorySessionRoute()]);
        } else {
          if (!isInitIdle(ref)) {
            return;
          }

          initInventoryMutation.run(ref, initInventoryRun(context, ref));
        }
      },
      child: currentUser(ref).when(
        data: (username) => queryActiveInventory(ref).when(
          data: (invState) {
            String btnLabel;

            if (invState.inventory == null) {
              if (invState.ok) {
                btnLabel = 'INICIAR AGORA';
              } else {
                btnLabel = 'INICIAR OFFLINE';
              }
            } else if (invState.inventory!.employeeUsername == username) {
              btnLabel = 'CONTINUAR AGORA';
            } else {
              btnLabel = 'ENTRAR NA SESSÃO';
            }

            return Text(
              btnLabel,
              style: context.theme.typography.xl2.copyWith(color: Colors.white),
            );
          },
          error: (e, st) =>
              Text('ERRO', style: context.theme.typography.xl2.copyWith(color: Colors.white)),
          loading: () => const LoadingWidget(),
        ),
        error: (err, trace) => const Text('Inautorizado'),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}

@RoutePage()
class InventoryCheckPage extends ConsumerWidget {
  const InventoryCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentUserProvider, asReload: true);
            ref.invalidate(getActiveInventoryProvider, asReload: true);
          },

          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 16,
              children: [
                _ResponsibleEmployee(),
                _InventoryStatus(),
                _ConnectionChecker(),
                // _Alert(),
              ],
            ),
          ),
        ),
        InitInventoryButton(),
      ],
    );
  }
}

class _ConnectionChecker extends ConsumerWidget {
  const _ConnectionChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final stockLastUpdate = ref.watch(stockProvider.notifier).updatedAt;
    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    // final isInventor yConnectedToServer = ref.watch(inventoryManagerProvider.select((state)=>state.currentInventory));

    return CustomCard(
      title: const Text('Checklist de Prontidão'),
      child: Column(
        spacing: 12,
        children: [
          _StatusItem(isReady: bleState is ConnectedState, text: 'Leitor conectado'),
          stockState.when(
            data: (_) => _StatusItem(
              isReady: true,
              text: 'Produtos carregados',
              isFresh: !(stockLastUpdate != null) || isStockFresh(stockLastUpdate),
            ),
            error: (e, st) => const _StatusItem(isReady: false, text: 'Erro ao carregar produtos'),
            loading: () =>
                const _StatusItem(isReady: false, isLoading: true, text: 'Carregando produtos...'),
          ),
          if (stockState.hasError || (stockLastUpdate != null && !isStockFresh(stockLastUpdate)))
            UpdateStockButton()
          else
            const Center(),
        ],
      ),
    );
  }
}

mixin class _InitInventoryState {
  AsyncValue<String> currentUser(WidgetRef ref) => ref.watch(currentUserProvider);
  bool isInitIdle(WidgetRef ref) =>
      ref.watch(initInventoryMutation.select((state) => state is MutationIdle));
  AsyncValue<({InventorySummary? inventory, bool ok})> queryActiveInventory(WidgetRef ref) =>
      ref.watch(getActiveInventoryProvider);
  AsyncValue<List<Product>> stockState(WidgetRef ref) => ref.watch(stockProvider);
}

class _InventoryStatus extends ConsumerWidget {
  const _InventoryStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryActiveInventory = ref.watch(getActiveInventoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    return CustomCard(
      title: const Text('Status do inventário'),
      child: Column(
        children: [
          currentUser.when(
            data: (username) => queryActiveInventory.when(
              data: (invState) {
                String message;
                bool hasError = false;

                if (invState.inventory == null) {
                  if (invState.ok) {
                    message = 'Nenhum inventário em andamento';
                  } else {
                    message = 'Erro ao se comunicar com o servidor';
                    hasError = true;
                  }
                } else if (invState.inventory!.employeeUsername == username) {
                  message = 'Retomar inventário #${invState.inventory!.id}?';
                } else {
                  message =
                      '${invState.inventory!.employeeUsername} está realizando o inventário #${invState.inventory!.id}';
                }

                return Center(
                  child: Text(
                    message,
                    style: context.theme.typography.xl2.copyWith(
                      color: hasError ? Colors.red : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              error: (e, st) => const Text('Erro ao carregar dados do servidor'),
              loading: () => const LoadingWidget(),
            ),
            error: (err, trace) => const Text('Inautorizado'),
            loading: () => const LoadingWidget(),
          ),
        ],
      ),
    );
  }
}

class _ResponsibleEmployee extends ConsumerWidget {
  const _ResponsibleEmployee();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final currentUser = ref.watch(currentUserProvider);
    return CustomCard(
      sizedBoxHeight: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FAvatar(image: const AssetImage(Assets.avatarPlaceholder)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentUser.when(
                        data: (data) => data,
                        error: (err, trace) => 'Desconhecido',
                        loading: () => 'Carregando...',
                      ) ??
                      'admin',
                  style: typography.xl.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text('Funcionário conectado'),
              ],
            ),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () async {
              await context.router.push(LoginRoute());
              ref.invalidate(currentUserProvider, asReload: true);
            },
            child: const Icon(FIcons.arrowRightLeft),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final bool isReady;
  final bool? isLoading;
  final bool? isFresh;
  final String text;
  const _StatusItem({required this.isReady, required this.text, this.isLoading, this.isFresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (true && isLoading != null && isLoading!)
          const CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        else
          Icon(
            (isFresh ?? true)
                ? (isReady ? FIcons.circleCheck : FIcons.circleX)
                : FIcons.circleAlert,
            color: isReady ? ((isFresh ?? true) ? Colors.green : Colors.orange) : Colors.red,
            size: 24,
          ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
