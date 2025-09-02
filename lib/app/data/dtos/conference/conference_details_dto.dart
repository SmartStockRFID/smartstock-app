import 'package:smart_stock/app/domain/entities/conference_entity.dart';
import 'package:smart_stock/app/domain/entities/event_entity.dart';
import 'package:smart_stock/app/domain/entities/reading_entity.dart';

// ignore: avoid_classes_with_only_static_members
class ConferenceDetailsDTO {
  static Conference fromJson(Map<String, dynamic> json) {
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

    return Conference(
      id: json['id'],
      employeeUsername: json['username_funcionario'],
      status: json['status'],
      readings: readings,
      events: events,
    );
  }

  static Map<String, dynamic> toJson(Conference conference) {
    return {
      'id': conference.id,
      'username_funcionario': conference.employeeUsername,
      'status': conference.status,
      'leituras': conference.readings
          .map(
            (r) => {
              'codigo_produto': r.productCode,
              'id': r.id,
              'ultima_leitura': r.lastReading.toIso8601String(),
              'quantidade': r.quantity,
            },
          )
          .toList(),
      'eventos': conference.events
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
