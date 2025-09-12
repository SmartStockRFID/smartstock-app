import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/loading_widget.dart';
import 'package:smart_stock/app/ui/shared/types.dart';
import 'package:smart_stock/app/utils/logger.dart';

class _Footer extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<_Footer> {
  @override
  Widget build(BuildContext context) {
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
          child: confState.initReqStatus == RequestStatus.loading
              ? const Text('INICIANDO...')
              : const Text('INICIAR CONFERÊNCIA'),
          // isLoading: false,
          onPress: () async {
            if (confState.initReqStatus == RequestStatus.idle) {
              logger.d('initConference called by INICIAR button!');
              await confManager.initConference();
            }
          },
        ),
        const SizedBox(height: 8.0),
        FButton(
          style: FButtonStyle.secondary(),
          child: const Text('VOLTAR'),
          onPress: () {
            context.router.pop(const HomeRoute());
          },
        ),
      ],
    );
  }
}

class ConferenceConfirmationInterface extends StatelessWidget {
  const ConferenceConfirmationInterface({super.key});

  Widget _buildMainContent(BuildContext context) {
    final typography = context.theme.typography;
    return Column(
      spacing: 16.0,
      children: [
        const _ResponsibleEmploye(),
        Text(
          'Confirme que você iniciará esta conferência',
          style: typography.sm.copyWith(
            color: context.theme.colors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        const _ConnectionChecker(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildMainContent(context), _Footer()],
      ),
    );
  }
}

class _ResponsibleEmploye extends StatelessWidget {
  const _ResponsibleEmploye();

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Funcionário responsável:'),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FAvatar(image: const AssetImage(Assets.avatarPlaceholder)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ryan Faustino',
                      style: typography.xl2.copyWith(
                        color: context.theme.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('ID: Não informado | Funcionário'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionChecker extends ConsumerWidget {
  const _ConnectionChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final typography = context.theme.typography;
    return FCard(
      title: Text(
        'Verificação de conexão',
        style: typography.sm.copyWith(
          color: context.theme.colors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Checkbox(value: true, onChanged: (value) {}),
              const Text('Bluetooth conectado com a pistola'),
            ],
          ),
          Row(
            children: [
              stockState.when(
                data: (parts) {
                  return Checkbox(value: true, onChanged: (value) {});
                },
                error: (e, stackTrace) {
                  return const Icon(FIcons.x, size: 16.0, color: Colors.red);
                },
                loading: () {
                  return const LoadingWidget();
                },
              ),
              const Text('Lista de produtos atualizada'),
            ],
          ),
        ],
      ),
    );
  }
}
