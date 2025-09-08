import 'dart:convert';

import 'package:smart_stock/app/config/api/part.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/data/dtos/parts/get_all_parts_repository.dart';
import 'package:smart_stock/app/data/repositories/part_repository.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';

class CarPartRepositoryImpl implements CarPartRepository {
  @override
  Future<List<CarPart>> getAllCarParts() async {
    final response = await CarPartAPI.getCarParts();

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);

      final List<CarPart> parts = GetAllCarPartsDTO.fromJsonList(body);

      return parts;
    } else {
      throw APIException(
        'Erro dentro de CarPartRepositoryImpl getAllCarParts.',
        code: response.statusCode,
      );
    }
  }
}
