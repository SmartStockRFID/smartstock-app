import 'dart:convert';

import 'package:smart_stock/app/config/exceptions.dart';

enum FirmwareObjectType { ReadResult }

class FirmwareObject {
  final FirmwareObjectType type;
  final dynamic content;

  FirmwareObject({required this.type, required this.content});

  // TODO: Implementar, acho que o toJson vai precisar receber uma função conversora por padrão
  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'type': type,
  //     'content': content,
  //   };
  // }

  // String toJson(Function) => json.encode(toMap());

  factory FirmwareObject.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;
    if (type != 'readResult') {
      throw const InternalSystemException(
        'Undefined message type comming from the microcontroller!',
      );
    }
    return FirmwareObject(type: FirmwareObjectType.ReadResult, content: map['content'] as dynamic);
  }

  factory FirmwareObject.fromJson(String source) =>
      FirmwareObject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FirmwareObject(type: $type, content: $content)';

  @override
  bool operator ==(covariant FirmwareObject other) {
    if (identical(this, other)) return true;

    return other.type == type && other.content == content;
  }
}
