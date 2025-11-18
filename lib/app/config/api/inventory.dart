import 'package:http/http.dart' as http;
import 'package:smart_stock/app/config/api/base.dart';

class InventoryAPI {
  final String baseUrl = 'conferencia';

  static Future<http.Response> startInventory(String employeeUsername) async {
    final Map<String, dynamic> body = {'username_funcionario': employeeUsername};
    return APIConnector.post('conferencia/', body);
  }

  static Future<http.Response> getAllInventories() async {
    return APIConnector.get('conferencia/');
  }

  // TODO: Trocar esse dynamic por um tipo verdadeiro
  static Future<http.Response> postReading(int inventoryId, dynamic readings) async {
    return APIConnector.post('conferencia/$inventoryId/leitura', readings);
  }

  static Future<http.Response> finishInventory(int inventoryId) async {
    return APIConnector.put('conferencia/$inventoryId/encerrar', {});
  }

  static Future<http.Response> cancelInventory(int inventoryId) async {
    return APIConnector.put('conferencia/$inventoryId/cancelar', {});
  }
}
