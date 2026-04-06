import 'package:get_it/get_it.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository_impl.dart';
import 'package:smart_stock/app/data/repositories/product_repository.dart';
import 'package:smart_stock/app/data/repositories/product_repository_impl.dart';

GetIt injector = GetIt.instance;

void setUpGetItInject() {
  injector.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());

  injector.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl());
}
