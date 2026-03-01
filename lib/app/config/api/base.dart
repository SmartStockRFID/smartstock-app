// ignore_for_file: avoid_classes_with_only_static_members, non_constant_identifier_names

import 'package:dio/dio.dart' as dio;
import 'package:smart_stock/app/config/api/_middleware.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/utils/internet.dart';
import 'package:smart_stock/app/utils/logger.dart';

final _apiInstance = dio.Dio();

class APIConnector {
  static final baseUrl = Enviroment.backendBaseURL()!;
  static const defaultHeaders = {
    dio.Headers.contentTypeHeader: 'application/json',
    dio.Headers.acceptHeader: 'application/json',
  };

  static Future<dio.Response> fetch(
    String endpoint, {
    required HTTPVerb method,
    dynamic body,
  }) async {
    _apiInstance.interceptors.add(AuthorizationInterceptor());

    await checkIfHasInternet();

    try {
      final url = Uri.parse('$baseUrl/$endpoint').toString();

      final response = await _apiInstance.fetch(
        dio.RequestOptions(path: url, data: body, headers: defaultHeaders, method: method.value),
      );

      return response;
    } catch (e) {
      logger.e('APIConnector error: $e');
      rethrow;
    }
  }
}

enum HTTPVerb {
  GET('GET'),
  POST('POST'),
  PUT('PUT');

  final String value;
  const HTTPVerb(this.value);
}
