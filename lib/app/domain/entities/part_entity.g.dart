// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarPart _$CarPartFromJson(Map<String, dynamic> json) => CarPart(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  productCode: json['productCode'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
);

Map<String, dynamic> _$CarPartToJson(CarPart instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'productCode': instance.productCode,
  'description': instance.description,
  'location': instance.location,
};
