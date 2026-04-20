import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';

class TimeInfo extends ConsumerWidget with _ConsumerState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = currentInventory(ref);
    final syncedAt = lastSyncedAt(ref);

    if (inventory == null) {
      return const SizedBox();
    }

    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(FIcons.clock, size: 16, color: Color.fromARGB(255, 130, 130, 130)),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${syncedAt != null ? 'Sincronizado' : 'Iniciado'} às '),
              TextSpan(
                text: formatTimestamp((syncedAt ?? inventory.createdAt).toLocal()),
                style: context.theme.typography.xl.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 130, 130, 130),
                ),
              ),
            ],
          ),
          style: context.theme.typography.xl.copyWith(
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
    );
  }

  String formatTimestamp(DateTime timestamp) {
    final timeFormat = DateFormat('HH:mm').format(timestamp);

    return timeFormat;
  }
}

mixin class _ConsumerState {
  InventorySummary? currentInventory(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.currentInventory));
  DateTime? lastSyncedAt(WidgetRef ref) =>
      ref.watch(inventoryManagerProvider.select((state) => state.lastSyncedAt));
}
