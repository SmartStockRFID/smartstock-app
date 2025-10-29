import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';

abstract class InventoryRepository {
  Future<InventorySummaryDTO> initInventory(String employeeUsername);
  Future<List<InventorySummaryDTO>> getAllInventories();
}
