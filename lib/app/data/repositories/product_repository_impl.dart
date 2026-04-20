import 'package:smart_stock/app/config/api/product.dart';
import 'package:smart_stock/app/data/dtos/product/get_all_products_dto.dart';
import 'package:smart_stock/app/data/repositories/product_repository.dart';
import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/utils/json.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts() async {
    final response = await ProductAPI.getAllProducts();

    final body = response.data;
    checkIfIsList(body);

    final List<Product> products = GetAllProductsDTO.fromJsonList(body);

    return products;
  }
}
