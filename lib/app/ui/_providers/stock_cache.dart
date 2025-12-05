import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/utils/logger.dart';

part 'stock_cache.g.dart';

@JsonSerializable()
@immutable
class StockCache {
  final DateTime savedAt;
  final List<CarPart> products;

  const StockCache({required this.products, required this.savedAt});

  factory StockCache.fromJson(Map<String, dynamic> json) => _$StockCacheFromJson(json);

  Map<String, dynamic> toJson() => _$StockCacheToJson(this);
}

Future<String> getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> getCacheFile() async {
  final path = await getLocalPath();
  return File('$path/stock_cache.txt');
}

Future<StockCache?> getStockCache() async {
  try {
    final file = await getCacheFile();

    if (!file.existsSync()) {
      return null;
    }

    final content = await file.readAsString();

    return StockCache.fromJson(jsonDecode(content));
  } catch (err) {
    logger.e('Deu bosta viu $err');
    return null;
  }
}

Future<void> writeStockCache(StockCache cache) async {
  final file = await getCacheFile();

  await file.writeAsString(jsonEncode(cache));
}
