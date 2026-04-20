import 'package:smart_stock/app/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
}
