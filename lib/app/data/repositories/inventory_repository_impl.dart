import 'dart:convert';
import 'dart:io';

import 'package:smart_stock/app/config/api/inventory.dart';
import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/ui/_providers/inventory_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  @override
  Future<InventorySummaryDTO> initInventory(String username) async {
    final response = await InventoryAPI.startInventory(username);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return InventorySummaryDTO.fromJson(data);
    } else {
      throw Exception('Erro ao iniciar inventário: ${response.statusCode}');
    }
  }

  // TODO: Fazer filtros de busca nessa rotax
  @override
  Future<List<InventorySummaryDTO>> getAllInventories() async {
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
  Future<void> cancelInventory(int inventoryId) async {
    final response = await InventoryAPI.cancelInventory(inventoryId);

    if (response.statusCode != 200) {
      throw HttpException(
        'Falha ao cancelar inventário: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
