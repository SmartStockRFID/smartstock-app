import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';

abstract class InventoryRepository {
  Future<InventorySummary> initInventory();
  Future<List<InventorySummary>> getAllInventories();
  Future<void> postReadings(int inventoryId, List<ProductReadings> readings);
  Future<void> finishInventory(int inventoryId);
  Future<InventorySummary?> getActiveInventory();
}
