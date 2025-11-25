import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';

abstract class InventoryRepository {
  Future<InventorySummaryDTO> initInventory();
  Future<List<InventorySummaryDTO>> getAllInventories();
  Future<void> postReadings(int inventoryId, List<ProductReadings> readings);
  Future<void> finishInventory(int inventoryId);
  Future<void> cancelInventory(int inventoryId);
  Future<InventorySummaryDTO?> getActiveInventory();
}
