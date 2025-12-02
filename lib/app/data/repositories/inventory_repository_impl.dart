import 'dart:convert';
import 'dart:io';

import 'package:smart_stock/app/config/api/inventory.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  @override
  Future<InventorySummary> initInventory() async {
    final currentUser = await CurrentUserStorage.getValue();

    if (currentUser == null) {
      throw const InternalSystemException('Unauthorized!');
    }

    final response = await InventoryAPI.startInventory(currentUser);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return InventorySummaryDTO.fromJson(data);
    } else {
      throw Exception('Erro ao iniciar inventário: ${response.statusCode}');
    }
  }

  // TODO: Fazer filtros de busca nessa rotax
  @override
  Future<List<InventorySummary>> getAllInventories() async {
    final response = await InventoryAPI.getAllInventories();

    if (response.statusCode != 200) {
      throw HttpException('Falha ao obter inventários: ${response.statusCode} - ${response.body}');
    }
    List<dynamic> dataList;

    try {
      dataList = jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      throw FormatException('Resposta da API não é um JSON válido: $e');
    }

    return InventorySummaryDTO.fromJsonList(dataList);
  }

  @override
  Future<void> postReadings(int inventoryId, List<ProductReadings> readings) async {
    logger.d('Entrei em postReadings :)');
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
    logger.d('Vou mandar pra API :) $processedReadings');

    final response = await InventoryAPI.postReading(inventoryId, processedReadings);
    logger.d('mandei vei :)');

    if (response.statusCode != 200) {
      throw HttpException('Falha ao postar inventários: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<void> finishInventory(int inventoryId) async {
    final response = await InventoryAPI.finishInventory(inventoryId);

    if (response.statusCode != 200) {
      throw HttpException(
        'Falha ao finalizar inventário: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<InventorySummary?> getActiveInventory() async {
    final inventories = await getAllInventories();

    final activeConfIndex = inventories.indexWhere((conf) => conf.status == 'iniciada');
    if (activeConfIndex != -1) {
      final inventoryDetails = inventories[activeConfIndex];
      return inventoryDetails;
    }
    return null;
  }
}
