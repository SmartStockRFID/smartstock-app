import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/data/repositories/part_repository_impl.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/utils/logger.dart';

part 'stock_provider.g.dart';

@Riverpod(keepAlive: true)
class Stock extends _$Stock {
  DateTime? updatedAt;

  @override
  Future<List<CarPart>> build() async {
    logger.d('Entrei no fetch véi');
    final respository = CarPartRepositoryImpl();
    final parts = await respository.getAllCarParts();
    updatedAt = DateTime.now();
    logger.d('Sucesso no getAll véi');
    return parts;
  }

  Future<void> refresh() async {
    // Uma forma simples de forçar a re-execução do método 'build'
    ref.invalidateSelf();
  }
}
