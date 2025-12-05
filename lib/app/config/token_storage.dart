import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// part 'token_storage.g.dart';

// class Token {
//   final String value;
//   final DateTime expiresAt;

//   const Token({required this.value, required this.expiresAt});
// }

// ignore: avoid_classes_with_only_static_members
class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return storage.read(key: 'jwt_token');
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'jwt_token');
  }
}
