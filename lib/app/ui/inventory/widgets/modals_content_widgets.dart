import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';

mixin class TimeInfoState {
  InventorySummary? currentInventory(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory));
}

class TimeInfo extends ConsumerWidget with TimeInfoState {
  String formatTimestamp(DateTime timestamp) {
    final timeFormat = DateFormat('HH:mm').format(timestamp);

    return timeFormat;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = currentInventory(ref);

    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(FIcons.clock, size: 16, color: Color.fromARGB(255, 130, 130, 130)),
        Text.rich(
          inventory != null
              ? TextSpan(
                  children: [
                    if (inventory.id == null)
                      const TextSpan(text: 'Iniciado local às ')
                    else
                      const TextSpan(text: 'Iniciado às '),
                    TextSpan(
                      text: formatTimestamp(inventory.createdAt.toLocal()),
                      style: context.theme.typography.xl.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 130, 130, 130),
                      ),
                    ),
                  ],
                )
              : const TextSpan(text: 'Sem mais informações'),

          style: context.theme.typography.xl.copyWith(
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
    );
  }
}

class Scoreboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readings = ref.watch(inventoryManagerProvider.select((state) => state.readings));
    final readingsCount = ref.watch(
      inventoryManagerProvider.select((state) => state.readingsCount),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ScoreboardItem(count: readings.length, label: 'Produtos Únicos'),
            const VerticalDivider(width: 20, color: Colors.grey),
            _ScoreboardItem(count: readingsCount, label: 'Etiquetas Lidas'),
          ],
        ),
      ],
    );
  }
}

class _ScoreboardItem extends StatelessWidget {
  const _ScoreboardItem({required this.count, required this.label});
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          count.toString(),
          style: context.theme.typography.xl6.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: context.theme.typography.sm.copyWith(
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
    );
  }
}
