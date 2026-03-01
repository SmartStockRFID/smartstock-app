import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_interfaces.g.dart';

@JsonSerializable()
@immutable
class ProductReadings {
  final List<ReadTag> readTags; //Todo: trocar por uma estrutura mais eficiente
  final String productOEM;

  const ProductReadings({required this.readTags, required this.productOEM});

  factory ProductReadings.fromJson(Map<String, dynamic> json) => _$ProductReadingsFromJson(json);

  int get tagCount => readTags.length;

  ProductReadings copyWith({List<ReadTag>? readTags, String? productOEM}) {
    return ProductReadings(
      readTags: readTags ?? this.readTags,
      productOEM: productOEM ?? this.productOEM,
    );
  }

  bool hasTag(String tagUid) => readTags.any((readTag) => readTag.tagUid == tagUid);

  Map<String, dynamic> toJson() => _$ProductReadingsToJson(this);
}

@JsonSerializable()
@immutable
class ReadTag {
  final String tagUid;
  final DateTime readTimestamp;

  const ReadTag({required this.tagUid, required this.readTimestamp});

  factory ReadTag.fromJson(Map<String, dynamic> json) => _$ReadTagFromJson(json);

  Map<String, dynamic> toJson() => _$ReadTagToJson(this);
}
