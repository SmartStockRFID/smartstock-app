import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';

bool isProductReadingsValid(ProductReadings reading, List<Product> stockProducts) {
  return stockProducts.indexWhere((p) => p.productCode == reading.productOEM) != -1;
}
