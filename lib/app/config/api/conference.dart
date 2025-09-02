import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/api/base.dart';

class ConferenceAPI {
  final String baseUrl = 'conferencia';

  static Future<http.Response> startConference(String employeeUsername) async {
    final Map<String, dynamic> body = {'username_funcionario': employeeUsername};
    return await APIConnector.post('conferencia/iniciar_conferencia', body);
  }

  static Future<http.Response> getAllConferences() async {
    return await APIConnector.get('conferencia/');
  }
}
