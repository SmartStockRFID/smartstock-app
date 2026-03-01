import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smart_stock/app/domain/entities/event_entity.dart';
import 'package:smart_stock/app/domain/entities/reading_entity.dart';

part 'inventory_entity.g.dart';

class InventoryDetail {
  final String employeeUsername;
  final int id;
  final String status;
  final List<Reading> readings;
  final List<Event> events;
  final DateTime createdAt;

  InventoryDetail({
    required this.employeeUsername,
    required this.id,
    required this.status,
    required this.readings,
    required this.events,
    required this.createdAt,
  });
}

@JsonSerializable()
@immutable
class InventorySummary {
  final int? id;
  final String employeeUsername;
  final DateTime createdAt;

  const InventorySummary({
    required this.id,
    required this.employeeUsername,
    required this.createdAt,
  });

  factory InventorySummary.fromJson(Map<String, dynamic> json) => _$InventorySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$InventorySummaryToJson(this);
}
