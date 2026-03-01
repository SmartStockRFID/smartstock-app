// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_cache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockCache _$StockCacheFromJson(Map<String, dynamic> json) => StockCache(
  products: (json['products'] as List<dynamic>)
      .map((e) => CarPart.fromJson(e as Map<String, dynamic>))
      .toList(),
  savedAt: DateTime.parse(json['savedAt'] as String),
);

Map<String, dynamic> _$StockCacheToJson(StockCache instance) =>
    <String, dynamic>{
      'savedAt': instance.savedAt.toIso8601String(),
      'products': instance.products,
    };
