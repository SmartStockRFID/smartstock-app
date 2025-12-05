// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventorySummary _$InventorySummaryFromJson(Map<String, dynamic> json) =>
    InventorySummary(
      id: (json['id'] as num?)?.toInt(),
      employeeUsername: json['employeeUsername'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$InventorySummaryToJson(InventorySummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeUsername': instance.employeeUsername,
      'createdAt': instance.createdAt.toIso8601String(),
    };
