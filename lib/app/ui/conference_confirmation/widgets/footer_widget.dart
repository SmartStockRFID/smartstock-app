import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
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

    final confManager = ref.read(conferenceManagerProvider.notifier);
    final confState = ref.watch(conferenceManagerProvider);

    final typography = context.theme.typography;

    if (confState.initReqStatus == RequestStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.router.replaceAll([const ConferenceRoute()]);
        }
      });
    }

    return Column(
      children: [
        Text(
          'Mantenha a pistola próxima durante toda a conferência. Se estiver offline, a sincronização ocorrerá quando a conexão for reestabelecida.',
          style: typography.xs.copyWith(color: context.theme.colors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        FButton(
          style: createLargeStyle(
            context: context,
            backgroundColor: context.theme.colors.primary,
            foregroundColor: context.theme.colors.primaryForeground,
          ),
          child: confState.initReqStatus == RequestStatus.loading
              ? const Text('INICIANDO...')
              : const Text('INICIAR CONFERÊNCIA'),
          // isLoading: false,
          onPress: () async {
            if (confState.initReqStatus == RequestStatus.idle) {
              logger.d('initConference called by INICIAR button!');
              await Future.wait([
                confManager.initConference(),
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
            backgroundColor: context.theme.colors.secondary,
            foregroundColor: context.theme.colors.secondaryForeground,
          ),
          child: const Text('VOLTAR'),
          onPress: () {
            context.router.pop(const HomeRoute());
          },
        ),
      ],
    );
  }
}
