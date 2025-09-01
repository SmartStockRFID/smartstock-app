import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/routing/router.dart';

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
          style: typography.sm.copyWith(color: context.theme.colors.primary),
        ),
        const _ConnectionChecker(),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final typography = context.theme.typography;
    return Column(
      children: [
        Text(
          'Mantenha a pistola próxima durante toda a conferência. Se estiver offline, a sincronização ocorrerá quando a conexão for reestabelecida.',
          style: typography.xs.copyWith(color: context.theme.colors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        FButton(
          child: const Text('INICIAR CONFERÊNCIA'),
          // isLoading: false,
          onPress: () {
            context.router.push(const ConferenceRoute());
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildMainContent(context), _buildFooter(context)],
      ),
    );
  }
}

class _ResponsibleEmploye extends StatelessWidget {
  const _ResponsibleEmploye({super.key});

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
                FAvatar(
                  image: const NetworkImage(
                    'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyZmlsfGVufDB8fDB8fHww',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ricardo Silva',
                      style: typography.lg.copyWith(
                        color: context.theme.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('ID: 123456 | Supervisor'),
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

class _ConnectionChecker extends StatelessWidget {
  const _ConnectionChecker({super.key});

  @override
  Widget build(BuildContext context) {
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
              Checkbox(value: true, onChanged: (value) {}),
              const Text('Lista de produtos atualizada'),
            ],
          ),
        ],
      ),
    );
  }
}
