import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/ui/_core/providers/inventory_provider.dart';

final currentUserProvider = FutureProvider.autoDispose<String>((ref) async {
  return await CurrentUserStorage.getValue() ?? 'Inautorizado';
});

final getActiveInventoryProvider = FutureProvider<InventorySummary?>((ref) async {
  final inventoryFromCache = ref.watch(inventoryManagerProvider).currentInventory;

  if (inventoryFromCache != null) {
    return inventoryFromCache;
  }

  final inventoryRepository = injector.get<InventoryRepository>();
  return inventoryRepository.getActiveInventory();
});
