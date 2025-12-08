// Implemented based on this great article: https://dev.to/7twilight/mastering-auth-in-flutter-with-dio-from-simple-access-tokens-to-a-refresh-flow-27cf
// TODO: Lacks point "3) Drawbacks & the Flag + Queue Optimization implementation" to complete the article.

import 'package:dio/dio.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/data/dtos/login_dto.dart';
import 'package:smart_stock/app/utils/json.dart';

class AuthorizationInterceptor extends Interceptor {
  Future<String?>? _refreshTokenFuture;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isUnauthorized(err) && _shouldRefresh(err.requestOptions)) {
      _refreshTokenFuture ??= _refreshAccessToken();

      final newToken = await _refreshTokenFuture;

      if (newToken != null) {
        final clonedRequest = _retryRequest(err.requestOptions, newToken);
        try {
          final res = await Dio().fetch(clonedRequest);
          return handler.resolve(res);
        } catch (e) {
          return handler.next(e as DioException);
        }
      }
    }

    return handler.next(err);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = await TokenStorage.getTokens();
    if (tokens.access != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.access?.value}';
    }

    return handler.next(options);
  }

  bool _isUnauthorized(DioException err) {
    return err.response?.statusCode == 401;
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final baseUrl = Enviroment.backendBaseURL();
      final path = '$baseUrl/auth/refresh';

      final tokens = await TokenStorage.getTokens();

      if (tokens.refresh == null) {
        return null;
      }

      final res = await Dio().post(path, data: {'refresh_token': tokens.refresh?.value});

      final body = res.data;
      checkIfIsMap(body);

      final dto = LoginResponseDTO.fromMap(body);
      await TokenStorage.storeTokens(dto);

      return dto.accessToken;
    } catch (e) {
      await TokenStorage.deleteTokens();
      return null;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  RequestOptions _retryRequest(RequestOptions options, String newToken) {
    final newHeaders = {...options.headers};
    newHeaders['Authorization'] = 'Bearer $newToken';

    return options.copyWith(headers: newHeaders);
  }

  bool _shouldRefresh(RequestOptions options) {
    return !options.path.contains('/refresh');
  }
}
