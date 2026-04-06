import 'dart:convert';

class LoginRequestDTO {
  final String username;
  final String password;

  LoginRequestDTO({required this.username, required this.password});

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }
}

class LoginResponseDTO {
  final String accessToken;
  final DateTime accessTokenExpiration;
  final String refreshToken;
  final DateTime refreshTokenExpiration;

  LoginResponseDTO({
    required this.accessToken,
    required this.accessTokenExpiration,
    required this.refreshToken,
    required this.refreshTokenExpiration,
  });

  factory LoginResponseDTO.fromMap(Map<String, dynamic> map) {
    return LoginResponseDTO(
      accessToken: map['access_token'] as String,
      accessTokenExpiration: DateTime.parse(map['access_expire'] as String),
      refreshToken: map['refresh_token'] as String,
      refreshTokenExpiration: DateTime.parse(map['refresh_expire'] as String),
    );
  }
}
