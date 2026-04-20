import 'package:smart_stock/app/domain/entities/product_entity.dart';

// ignore: avoid_classes_with_only_static_members
abstract final class GetAllProductsDTO {
  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['nome'] as String,
      productCode: json['codigo_produto'] as String,
      description: json['descricao'] as String,
      location: json['localizacao'] as String,
      // quantity: json['quantidade'] as int,
    );
  }

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((jsonItem) => fromJson(jsonItem)).toList();
  }
}
