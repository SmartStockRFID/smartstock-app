import 'package:dio/dio.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/config/token_storage.dart';
import 'package:smart_stock/app/data/dtos/login_dto.dart';
import 'package:smart_stock/app/utils/json.dart';

final _authApiInstance = Dio();

// ignore: avoid_classes_with_only_static_members
class AuthAPI {
  static final String baseUrl = Enviroment.backendBaseURL()!;

  static Future<Response> login({required LoginRequestDTO payload}) async {
    const endpoint = 'auth/login';
    final url = Uri.parse('$baseUrl/$endpoint').toString();

    final response = await _authApiInstance.post(
      url,
      data: FormData.fromMap(payload.toMap()),
      options: Options(headers: {'Accept': 'application/json'}, validateStatus: (status) => true),
    );

    if (response.statusCode == 200) {
      final responseBody = response.data;
      checkIfIsMap(responseBody);

      final dto = LoginResponseDTO.fromMap(responseBody);
      await TokenStorage.storeTokens(dto);

      await CurrentUserStorage.setValue(payload.username);
      await SavedLoginsStorage.saveValue(payload.username);
      await CurrentSessionTimestampProvider.setValue();
    }
    return response;
  }
}
