import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';

abstract class InventoryRepository {
  Future<void> finishInventory(int inventoryId);
  Future<InventorySummary?> getActiveInventory();
  Future<InventorySummary> initInventory();
  Future<void> postReadings(int inventoryId, List<ProductReadings> readings);
}
