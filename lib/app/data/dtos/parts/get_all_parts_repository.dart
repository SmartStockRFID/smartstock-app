import 'package:smart_stock/app/domain/entities/part_entity.dart';

abstract final class GetAllCarPartsDTO {
  static CarPart fromJson(Map<String, dynamic> json) {
    return CarPart(
      id: json['id'] as int,
      name: json['nome'] as String,
      productCode: json['codigo_produto'] as String,
      description: json['descricao'] as String,
      location: json['localizacao'] as String,
      // quantity: json['quantidade'] as int,
    );
  }

  static List<CarPart> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((jsonItem) => fromJson(jsonItem)).toList();
  }
}
