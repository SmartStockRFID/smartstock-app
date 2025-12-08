import 'package:smart_stock/app/config/api/part.dart';
import 'package:smart_stock/app/data/dtos/parts/get_all_parts_dto.dart';
import 'package:smart_stock/app/data/repositories/part_repository.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/utils/json.dart';

class CarPartRepositoryImpl implements CarPartRepository {
  @override
  Future<List<CarPart>> getAllCarParts() async {
    final response = await CarPartAPI.getCarParts();

    final body = response.data;
    checkIfIsList(body);

    final List<CarPart> parts = GetAllCarPartsDTO.fromJsonList(body);

    return parts;
  }
}
