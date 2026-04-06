import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_entity.g.dart';

@JsonSerializable()
@immutable
class Product {
  final int id;
  final String name;
  final String productCode;
  final String description;
  final String location;

  const Product({
    required this.id,
    required this.name,
    required this.productCode,
    required this.description,
    required this.location,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
