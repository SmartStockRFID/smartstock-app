import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/api/base.dart';

// TODO: Implementar timeout, backoff exponencial, fallback e circuit-breaker
// ignore: avoid_classes_with_only_static_members
class CarPartAPI {
  static Future<http.Response> getCarParts() async {
    late http.Response response;

    response = await APIConnector.get('pecas');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw HttpException('Falha ao obter peças: ${response.statusCode}');
    }
  }
}
