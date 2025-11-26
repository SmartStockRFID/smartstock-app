import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/data/dtos/login_dto.dart';

// ignore: avoid_classes_with_only_static_members
class AuthAPI {
  static final String baseUrl = Enviroment.backendBaseURL()!;

  static Future<http.Response> login({required LoginRequestDTO payload}) async {
    const endpoint = 'auth/login';

    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json'},
      encoding: Encoding.getByName('utf-8'),
      body: payload.toMap(),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      final dto = LoginResponseDTO.fromMap(responseBody);
      final token = dto.token;

      await TokenStorage.storeToken(token);
      await CurrentUserStorage.setValue(payload.username);
      await SavedLoginsStorage.saveValue(payload.username);
      await CurrentSessionTimestampProvider.setValue();
    }
    return response;
  }
}
