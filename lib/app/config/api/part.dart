import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/exceptions.dart';

// TODO: Implementar timeout, backoff exponencial, fallback e circuit-breaker
class CarPartAPI {
  static final baseUrl = Enviroment.backendBaseURL();

  static Future<http.Response> getCarParts() async {
    late http.Response response;

    try {
      final url = Uri.parse('$baseUrl/pecas');
      response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw HttpException('Falha ao obter peças: ${response.statusCode}');
      }
    } catch (e) {
      throw InternalSystemException('Erro em CarParAPI getCarParts: $e');
    }
  }
}
