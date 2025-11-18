import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/ui/providers/inventory_provider.dart';

abstract class InventoryRepository {
  Future<InventorySummaryDTO> initInventory(String employeeUsername);
  Future<List<InventorySummaryDTO>> getAllInventories();
  Future<void> postReadings(int inventoryId, List<ProductReadings> readings);
  Future<void> finishInventory(int inventoryId);
  Future<void> cancelInventory(int inventoryId);
}
