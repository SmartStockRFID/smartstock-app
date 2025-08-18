import 'package:smart_stock/app/domain/entities/part_entity.dart';

abstract final class GetAllCarPartsDTO {
  static CarPart fromJson(Map<String, dynamic> json) {
    return CarPart(
      id: json['id'] as int,
      name: json['nome'] as String,
      oemCode: json['codigo_oem'] as String,
      description: json['descricao'] as String,
      location: json['localizacao'] as String,
      quantity: json['quantidade'] as int,
      costPrice: json['preco_custo'] as double,
      sellingPrice: json['preco_venda'] as double,
      carModel: json['modelo_carro'] as String,
      carYear: json['ano_carro'] as String,
      rfidUid: json['rfid_uid'] as String?,
    );
  }

  static List<CarPart> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((jsonItem) => fromJson(jsonItem)).toList();
  }
}
