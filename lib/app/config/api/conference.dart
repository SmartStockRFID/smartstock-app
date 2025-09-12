import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/api/base.dart';

class ConferenceAPI {
  final String baseUrl = 'conferencia';

  static Future<http.Response> startConference(String employeeUsername) async {
    final Map<String, dynamic> body = {'username_funcionario': employeeUsername};
    return APIConnector.post('conferencia/', body);
  }

  static Future<http.Response> getAllConferences() async {
    return APIConnector.get('conferencia/');
  }

  // TODO: Trocar esse dynamic por um tipo verdadeiro
  static Future<http.Response> postReading(int conferenceId, dynamic readings) async {
    return APIConnector.post('conferencia/$conferenceId/leitura', readings);
  }

  static Future<http.Response> finishConference(int conferenceId) async {
    return APIConnector.put('conferencia/$conferenceId/encerrar', {});
  }

  static Future<http.Response> cancelConference(int conferenceId) async {
    return APIConnector.put('conferencia/$conferenceId/cancelar', {});
  }
}
