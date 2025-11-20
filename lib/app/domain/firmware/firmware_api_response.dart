import 'dart:convert';

abstract final class FRTypes {
  static const readResult = 'readResult';
  static const writeResult = 'writeResult';
  static const feedback = 'feedback';
}

class FirmwareResponse {
  final String type;
  final dynamic content;

  FirmwareResponse({required this.type, required this.content});

  factory FirmwareResponse.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;

    return FirmwareResponse(type: type, content: map['content'] as dynamic);
  }

  factory FirmwareResponse.fromJson(String source) =>
      FirmwareResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FirmwareObject(type: $type, content: $content)';

  @override
  bool operator ==(covariant FirmwareResponse other) {
    if (identical(this, other)) return true;

    return other.type == type && other.content == content;
  }
}
