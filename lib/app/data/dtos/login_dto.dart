import 'dart:convert';

class LoginRequestDTO {
  final String username;
  final String password;

  LoginRequestDTO({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }

  String toJson() => json.encode(toMap());
}

class LoginResponseDTO {
  final String token;

  LoginResponseDTO({required this.token});

  factory LoginResponseDTO.fromMap(Map<String, dynamic> map) {
    return LoginResponseDTO(token: map['access_token'] as String);
  }

  factory LoginResponseDTO.fromJson(String source) =>
      LoginResponseDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
