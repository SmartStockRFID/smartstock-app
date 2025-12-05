import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part_entity.g.dart';

@JsonSerializable()
@immutable
class CarPart {
  final int id;
  final String name;
  final String productCode;
  final String description;
  final String location;

  const CarPart({
    required this.id,
    required this.name,
    required this.productCode,
    required this.description,
    required this.location,
  });

  factory CarPart.fromJson(Map<String, dynamic> json) => _$CarPartFromJson(json);

  Map<String, dynamic> toJson() => _$CarPartToJson(this);
}
