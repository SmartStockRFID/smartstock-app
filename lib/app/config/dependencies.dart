import 'package:get_it/get_it.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository_impl.dart';
import 'package:smart_stock/app/data/repositories/part_repository.dart';
import 'package:smart_stock/app/data/repositories/part_repository_impl.dart';

GetIt injector = GetIt.instance;

void setUpGetItInject() {
  injector.registerLazySingleton<CarPartRepository>(() => CarPartRepositoryImpl());

  injector.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl());
}
