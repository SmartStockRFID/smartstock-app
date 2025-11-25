import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/_providers/stock_provider.dart';
import 'package:smart_stock/app/ui/_shared/custom_card.dart';
import 'package:smart_stock/app/ui/_shared/loading_widget.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

final currentUserProvider = FutureProvider.autoDispose<String>((ref) async {
  return await PreferencesManager.getCurrentUser() ?? '';
});

final getActiveInventoryProvider = FutureProvider.autoDispose<InventorySummaryDTO?>((ref) async {
  try {
    final inventoryFromServer = await injector.get<InventoryRepository>().getActiveInventory();

    if (inventoryFromServer != null) {
      ref.read(inventoryManagerProvider.notifier).setInventoryFromServer(inventoryFromServer);
      return inventoryFromServer;
    }
  } catch (error) {
    logger.e('oi $error');
  }

  return null;
});

final initInventoryMutation = Mutation<void>();

@RoutePage()
class InventoryConfirmationPage extends StatelessWidget {
  const InventoryConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SingleChildScrollView(
          child: Column(spacing: 16, children: [_ResponsibleEmployee(), _InventoryStatus()]),
        ),
        InitInventoryButton(),
      ],
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
              ref.invalidate(currentUserProvider);
            },
            child: const Icon(FIcons.arrowRightLeft),
          ),
        ],
      ),
    );
  }
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
              data: (inventory) {
                String message;

                if (inventory == null) {
                  message = 'Estoque pronto para inventário';
                } else if (inventory.employeeUsername == username) {
                  message = 'Retomar conferência #${inventory.id}?';
                } else {
                  message =
                      '${inventory.employeeUsername} está realizando o inventário #${inventory.id}';
                }

                return Center(
                  child: Text(
                    message,
                    style: context.theme.typography.xl2,
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

class _ConnectionChecker extends ConsumerWidget {
  const _ConnectionChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    return CustomCard(
      title: const Text('Checklist de Prontidão'),
      child: Column(
        children: [
          const _StatusItem(isReady: true, text: 'Pistola conectada'),
          const Divider(height: 20),
          stockState.when(
            data: (_) => const _StatusItem(isReady: true, text: 'Produtos carregados'),
            error: (e, st) => const _StatusItem(isReady: false, text: 'Erro ao carregar produtos'),
            loading: () => const _StatusItem(isReady: false, text: 'Carregando produtos...'),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({required this.isReady, required this.text});
  final bool isReady;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isReady ? FIcons.circleCheck : FIcons.circleX,
          color: isReady ? Colors.green : Colors.red,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}

class InitInventoryButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryActiveInventory = ref.watch(getActiveInventoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    final pending = ref.watch(initInventoryMutation.select((state) => state is MutationPending));

    return FButton(
      style: primaryLargeButton(
        context,
        disabled: pending || queryActiveInventory.isLoading || currentUser.isLoading,
      ),
      onPress: () async {
        if (currentUser.isLoading || queryActiveInventory.isLoading) {
          return;
        }

        if (queryActiveInventory.value == null) {
          if (pending) {
            return;
          }
          initInventoryMutation.run(ref, (tsx) async {
            await tsx.get(inventoryManagerProvider.notifier).startInventoryFlow();

            Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

            initInventoryMutation.reset(ref);

            if (context.mounted) {
              context.router.push(const InventoryRoute());
            }
          });
        } else {
          Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
          await context.router.push(const InventoryRoute());
        }
      },
      child: currentUser.when(
        data: (username) => queryActiveInventory.when(
          data: (inventory) {
            String btnLabel;

            if (inventory == null) {
              btnLabel = 'INICIAR AGORA';
            } else if (inventory.employeeUsername == username) {
              btnLabel = 'CONTINUAR TRABALHO';
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
