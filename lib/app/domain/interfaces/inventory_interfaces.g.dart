// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReadings _$ProductReadingsFromJson(Map<String, dynamic> json) =>
    ProductReadings(
      readTags: (json['readTags'] as List<dynamic>)
          .map((e) => ReadTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      productOEM: json['productOEM'] as String,
    );

Map<String, dynamic> _$ProductReadingsToJson(ProductReadings instance) =>
    <String, dynamic>{
      'readTags': instance.readTags,
      'productOEM': instance.productOEM,
    };

ReadTag _$ReadTagFromJson(Map<String, dynamic> json) => ReadTag(
  tagUid: json['tagUid'] as String,
  readTimestamp: DateTime.parse(json['readTimestamp'] as String),
);

Map<String, dynamic> _$ReadTagToJson(ReadTag instance) => <String, dynamic>{
  'tagUid': instance.tagUid,
  'readTimestamp': instance.readTimestamp.toIso8601String(),
};
