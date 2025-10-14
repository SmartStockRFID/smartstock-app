import 'dart:convert';
import 'dart:io';

import 'package:smart_stock/app/config/api/base.dart';
import 'package:smart_stock/app/config/api/conference.dart';
import 'package:smart_stock/app/data/dtos/conference/conference_minimal_dto.dart';
import 'package:smart_stock/app/data/repositories/conference_repository.dart';
import 'package:smart_stock/app/domain/entities/reading_entity.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

class ConferenceRepositoryImpl implements ConferenceRepository {
  @override
  Future<ConferenceMinimalDTO> initConference(String username) async {
    final response = await ConferenceAPI.startConference(username);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ConferenceMinimalDTO.fromJson(data);
    } else {
      throw Exception('Erro ao iniciar inventário: ${response.statusCode}');
    }
  }

  // TODO: Fazer filtros de busca nessa rotax
  @override
  Future<List<ConferenceMinimalDTO>> getAllConferences() async {
    final response = await ConferenceAPI.getAllConferences();

    if (response.statusCode != 200) {
      throw HttpException('Falha ao obter inventários: ${response.statusCode} - ${response.body}');
    }
    List<dynamic> dataList;
    try {
      dataList = jsonDecode(response.body) as List<dynamic>;
    } catch (e) {
      throw FormatException('Resposta da API não é um JSON válido: $e');
    }

    return ConferenceMinimalDTO.fromJsonList(dataList);
  }

  Future<void> postReadings(int conferenceId, List<ProductReadings> readings) async {
    logger.d('Entrei em postReadings :)');
    final List<Map<String, dynamic>> processedReadings = [];

    for (final ProductReadings reading in readings) {
     
      for (final ReadTag readTag in reading.readTags) {
        
        processedReadings.add({
          'codigo_produto': reading.productOEM,
          'lido_em': readTag.readTimestamp.toIso8601String(),
          'rfid_etiqueta': readTag.tagUid,
        });
      }
    }
    logger.d('Vou mandar pra API :) $processedReadings');

    final response = await ConferenceAPI.postReading(conferenceId, processedReadings);
    logger.d('mandei vei :)');

    if (response.statusCode != 200) {
      throw HttpException('Falha ao postar inventários: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> finishConference(int conferenceId) async {
    final response = await ConferenceAPI.finishConference(conferenceId);

    if (response.statusCode != 200) {
      throw HttpException('Falha ao finalizar inventário: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> cancelConference(int conferenceId) async {
    final response = await ConferenceAPI.cancelConference(conferenceId);

    if (response.statusCode != 200) {
      throw HttpException('Falha ao cancelar inventário: ${response.statusCode} - ${response.body}');
    }
  }
}
