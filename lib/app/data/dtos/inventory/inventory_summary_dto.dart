import 'package:smart_stock/app/domain/entities/inventory_entity.dart';

// ignore: avoid_classes_with_only_static_members
class InventorySummaryDTO {
  static InventorySummary fromJson(Map<String, dynamic> json) {
    return InventorySummary(
      id: json['id'],
      employeeUsername: json['username_funcionario'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static List<InventorySummary> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((jsonItem) {
      if (jsonItem is Map<String, dynamic>) {
        return InventorySummaryDTO.fromJson(jsonItem);
      } else {
        throw FormatException('Item inválido na lista de inventários: $jsonItem');
      }
    }).toList();
  }
}
