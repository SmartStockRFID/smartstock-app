import 'dart:io';

import 'package:smart_stock/app/config/api/inventory.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';
import 'package:smart_stock/app/utils/json.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  @override
  Future<void> finishInventory(int inventoryId) async {
    await InventoryAPI.finishInventory(inventoryId);
  }

  @override
  Future<InventorySummary?> getActiveInventory() async {
    final response = await InventoryAPI.getActiveInventory();

    if (response.statusCode == 200) {
      final data = response.data;
      checkIfIsMap(data);

      return InventorySummaryDTO.fromJson(data);
    } else if (response.statusCode == 204) {
      return null;
    }

    throw HttpException('Falha ao finalizar inventário: ${response.statusCode} - ${response.data}');
  }

  // TODO: Fazer filtros de busca nessa rotax
  @override
  Future<List<InventorySummary>> getAllInventories() async {
    final response = await InventoryAPI.getAllInventories();

    final list = response.data;
    checkIfIsList(list);

    return InventorySummaryDTO.fromJsonList(list);
  }

  @override
  Future<InventorySummary> initInventory() async {
    final currentUser = await CurrentUserStorage.getValue();

    if (currentUser == null) {
      throw const InternalSystemException('Unauthorized!');
    }

    final response = await InventoryAPI.startInventory(currentUser);

    final data = response.data;
    checkIfIsMap(data);

    return InventorySummaryDTO.fromJson(data);
  }

  @override
  Future<void> postReadings(int inventoryId, List<ProductReadings> readings) async {
    final List<Map<String, dynamic>> processedReadings = [];
    
    for (final ProductReadings reading in readings) {
      for (final ReadTag readTag in reading.readTags) {
        processedReadings.add({
          'codigo_produto': reading.productOEM,
          'lido_em': readTag.readTimestamp.toIso8601String(),
          'rfid_etiqueta': readTag.tagUid,
        });
      }
    }

    await InventoryAPI.postReading(inventoryId, processedReadings);
  }
}
