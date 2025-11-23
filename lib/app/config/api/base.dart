import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/exceptions.dart';

// ignore: avoid_classes_with_only_static_members
class APIConnector {
  static final String baseUrl = Enviroment.backendBaseURL()!;
  static const defaultHeaders = {'Content-Type': 'application/json', 'Accept': 'application/json'};

  /// Generic GET
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.get(url, headers: defaultHeaders);

      _validateResponse(response, endpoint);
      return response;
    } catch (e) {
      throw InternalSystemException('Error in BaseAPI GET [$endpoint]: $e');
    }
  }

  /// Generic POST -> TODO: tipar esse dynamic melhor
  static Future<http.Response> post(String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.post(url, headers: defaultHeaders, body: jsonEncode(body));

      _validateResponse(response, endpoint);
      return response;
    } catch (e) {
      throw InternalSystemException('Error in BaseAPI POST [$endpoint]: $e');
    }
  }

  /// Generic PUT
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.put(url, headers: defaultHeaders, body: jsonEncode(body));

      _validateResponse(response, endpoint);
      return response;
    } catch (e) {
      throw InternalSystemException('Error in BaseAPI PUT [$endpoint]: $e');
    }
  }

  /// Generic DELETE
  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    try {
      final response = await http.delete(url, headers: defaultHeaders);

      _validateResponse(response, endpoint);
      return response;
    } catch (e) {
      throw InternalSystemException('Error in BaseAPI DELETE [$endpoint]: $e');
    }
  }

  /// Validates HTTP responses
  static void _validateResponse(http.Response response, String endpoint) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw HttpException(
        'Request to [$endpoint] failed: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
