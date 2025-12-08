import 'package:dio/dio.dart' as dio;
import 'package:smart_stock/app/config/api/base.dart';

// TODO: Implementar timeout, backoff exponencial, fallback e circuit-breaker
// ignore: avoid_classes_with_only_static_members
class CarPartAPI {
  static Future<dio.Response> getCarParts() async {
    return APIConnector.fetch('pecas', method: HTTPVerb.GET);
  }
}
