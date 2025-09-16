import 'package:smart_stock/app/data/dtos/conference/conference_minimal_dto.dart';

abstract class ConferenceRepository {
  Future<ConferenceMinimalDTO> initConference(String employeeUsername);
  Future<List<ConferenceMinimalDTO>> getAllConferences();
}
