import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/ui/inventory_confirmation/widgets/init_inventory_btn_widget.dart';
import 'package:smart_stock/app/ui/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/custom_card.dart';
import 'package:smart_stock/app/ui/shared/update_stock_btn.dart';

@RoutePage()
class InventoryConfirmationPage extends StatelessWidget {
  const InventoryConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SingleChildScrollView(
          child: Column(
            children: [_ResponsibleEmployee(), SizedBox(height: 16), _ConnectionChecker()],
          ),
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
    final employeeUsername = ref.watch(
      inventoryManagerProvider.select((state) => state.employeeUsername),
    );
    return CustomCard(
      title: const Text('Responsável'),
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
                  employeeUsername ?? 'admin',
                  style: typography.xl.copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text('Funcionário'),
              ],
            ),
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
            data: (_) => const _StatusItem(isReady: true, text: 'Lista de produtos sincronizada'),
            error: (e, st) =>
                const _StatusItem(isReady: false, text: 'Erro ao sincronizar produtos'),
            loading: () => const _StatusItem(isReady: false, text: 'Sincronizando produtos...'),
          ),
          const SizedBox(height: 24),
          UpdateStockButton(),
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
