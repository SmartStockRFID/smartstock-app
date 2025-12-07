import 'dart:convert';
import 'dart:io';

import 'package:smart_stock/app/config/api/inventory.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';

class InventoryRepositoryImpl implements InventoryRepository {
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
    final response = await InventoryAPI.getActiveInventory();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return InventorySummaryDTO.fromJson(data);
    } else if (response.statusCode == 204) {
      return null;
    }

    throw HttpException('Falha ao finalizar inventário: ${response.statusCode} - ${response.body}');
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

    final response = await InventoryAPI.postReading(inventoryId, processedReadings);

    if (response.statusCode != 200) {
      throw HttpException(
        'Error posting inventory products: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
