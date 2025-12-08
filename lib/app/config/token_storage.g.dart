// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  value: json['value'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'value': instance.value,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
