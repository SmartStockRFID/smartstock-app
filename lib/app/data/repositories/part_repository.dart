import 'package:smart_stock/app/domain/entities/part_entity.dart';

abstract class CarPartRepository {
  Future<List<CarPart>> getAllCarParts();
}
