import 'dart:convert';
import 'dart:io';

import 'package:smart_stock/app/config/api/conference.dart';
import 'package:smart_stock/app/data/dtos/conference/conference_minimal_dto.dart';
import 'package:smart_stock/app/data/repositories/conference_repository.dart';

class ConferenceRepositoryImpl implements ConferenceRepository {
  @override
  Future<ConferenceMinimalDTO> initConference(String username) async {
    final response = await ConferenceAPI.startConference(username);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ConferenceMinimalDTO.fromJson(data);
    } else {
      throw Exception('Erro ao iniciar conferência: ${response.statusCode}');
    }
  }

  // TODO: Fazer filtros de busca nessa rotax
  @override
  Future<List<ConferenceMinimalDTO>> getAllConferences() async {
    final response = await ConferenceAPI.getAllConferences();

    if (response.statusCode != 200) {
      throw HttpException('Falha ao obter conferências: ${response.statusCode} - ${response.body}');
    }
    List<dynamic> dataList;
    try {
      dataList = jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      throw FormatException('Resposta da API não é um JSON válido: $e');
    }

    return ConferenceMinimalDTO.fromJsonList(dataList);
  }
}
