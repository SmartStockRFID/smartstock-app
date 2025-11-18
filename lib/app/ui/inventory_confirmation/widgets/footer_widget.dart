import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/shared/types.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';
import 'package:smart_stock/app/utils/logger.dart';

class Footer extends ConsumerStatefulWidget {
  @override
  ConsumerState<Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<Footer> {
  @override
  Widget build(BuildContext context) {
    final connectionManager = ref.watch(bleConnectionProvider);

    final inventoryManager = ref.read(conferenceManagerProvider.notifier);
    final inventoryState = ref.watch(conferenceManagerProvider);

    final typography = context.theme.typography;

    if (inventoryState.initReqStatus == RequestStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.router.replaceAll([const InventoryRoute()]);
        }
      });
    }
    final disabledPriBackgroundColor = context.theme.colors.primary;
    final disabledPriForegroundColor = context.theme.colors.disable(
      context.theme.colors.primaryForeground,
    );

    final disabledSecBackgroundColor = context.theme.colors.secondary;
    final disabledSecForegroundColor = context.theme.colors.disable(
      context.theme.colors.secondaryForeground,
    );

    final canClick =
        inventoryState.initReqStatus == RequestStatus.idle &&
        inventoryState.initReqStatus != RequestStatus.error;

    return Column(
      children: [
        Text(
          'Mantenha a pistola próxima durante todo o inventário. Se estiver offline, a sincronização ocorrerá quando a conexão for reestabelecida.',
          style: typography.xs,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        FButton(
          style: createLargeStyle(
            context: context,
            backgroundColor: canClick ? context.theme.colors.primary : disabledPriBackgroundColor,
            foregroundColor: canClick
                ? context.theme.colors.primaryForeground
                : disabledPriForegroundColor,
          ),
          child: inventoryState.initReqStatus == RequestStatus.loading
              ? const Text('INICIANDO...')
              : const Text('INICIAR INVENTÁRIO'),
          // isLoading: false,
          onPress: () async {
            if (inventoryState.initReqStatus == RequestStatus.idle) {
              logger.d('initConference called by INICIAR button!');
              await Future.wait([
                inventoryManager.initConference(),
                connectionManager.manager.enterOnReadMode(
                  connectionManager.manager.connectedPistol,
                ),
              ]);
            }
          },
        ),
        const SizedBox(height: 15),
        FButton(
          style: createLargeStyle(
            context: context,
            backgroundColor: canClick ? context.theme.colors.secondary : disabledSecBackgroundColor,
            foregroundColor: canClick
                ? context.theme.colors.secondaryForeground
                : disabledSecForegroundColor,
          ),
          child: const Text('VOLTAR'),
          onPress: () {
            if (inventoryState.initReqStatus != RequestStatus.loading) {
              context.router.replaceAll([const HomeRoute()]);
            }
          },
        ),
      ],
    );
  }
}
