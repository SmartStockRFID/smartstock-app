import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smart_stock/app/data/dtos/auth/login_dto.dart';

part 'token_storage.g.dart';

const accessKey = 'access_token';
const refreshKey = 'refresh_token';

@JsonSerializable()
@immutable
class Token {
  final String value;
  final DateTime expiresAt;

  const Token({required this.value, required this.expiresAt});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

// ignore: avoid_classes_with_only_static_members
class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> deleteTokens() async {
    await storage.delete(key: accessKey);
    await storage.delete(key: refreshKey);
  }

  static Future<({Token? access, Token? refresh})> getTokens() async {
    final access = await storage.read(key: accessKey);
    final refresh = await storage.read(key: refreshKey);

    Token? getTokenOrNull(String? value) {
      return (value != null && value.isNotEmpty) ? Token.fromJson(json.decode(value)) : null;
    }

    return (access: getTokenOrNull(access), refresh: getTokenOrNull(refresh));
  }

  static Future<void> storeTokens(LoginResponseDTO payload) async {
    final access = Token(value: payload.accessToken, expiresAt: payload.accessTokenExpiration);
    final refresh = Token(value: payload.refreshToken, expiresAt: payload.refreshTokenExpiration);

    await storage.write(key: accessKey, value: json.encode(access.toJson()));
    await storage.write(key: refreshKey, value: json.encode(refresh.toJson()));
  }
}
