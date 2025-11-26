import 'package:smart_stock/app/domain/entities/event_entity.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/entities/reading_entity.dart';

// ignore: avoid_classes_with_only_static_members
class InventoryDetailsDTO {
  static Inventory fromJson(Map<String, dynamic> json) {
    final readings = (json['leituras'] as List)
        .map(
          (e) => Reading(
            productCode: e['codigo_produto'],
            id: e['id'],
            lastReading: DateTime.parse(e['ultima_leitura']),
            quantity: e['quantidade'],
          ),
        )
        .toList();

    final events = (json['eventos'] as List)
        .map(
          (e) => Event(
            type: e['tipo'],
            description: e['descricao'],
            occurredAt: DateTime.parse(e['ocorreu_em']),
            id: e['id'],
          ),
        )
        .toList();

    return Inventory(
      id: json['id'],
      employeeUsername: json['username_funcionario'],
      status: json['status'],
      readings: readings,
      events: events,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static Map<String, dynamic> toJson(Inventory inventory) {
    return {
      'id': inventory.id,
      'username_funcionario': inventory.employeeUsername,
      'status': inventory.status,
      'leituras': inventory.readings
          .map(
            (r) => {
              'codigo_produto': r.productCode,
              'id': r.id,
              'ultima_leitura': r.lastReading.toIso8601String(),
              'quantidade': r.quantity,
            },
          )
          .toList(),
      'eventos': inventory.events
          .map(
            (e) => {
              'tipo': e.type,
              'descricao': e.description,
              'ocorreu_em': e.occurredAt.toIso8601String(),
              'id': e.id,
            },
          )
          .toList(),
    };
  }
}
