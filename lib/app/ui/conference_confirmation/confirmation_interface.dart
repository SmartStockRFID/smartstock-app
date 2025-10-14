import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/ui/conference_confirmation/widgets/footer_widget.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/loading_widget.dart';

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
        children: [
          const SingleChildScrollView(
            child: Column(
              children: [
                _ResponsibleEmployee(),
                SizedBox(height: 16),
                _ConnectionChecker(),
              ],
            ),
          ),
          Footer(),
        ],
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
