import 'package:dio/dio.dart' as dio;
import 'package:smart_stock/app/config/api/base.dart';

class InventoryAPI {
  final String baseUrl = 'inventarios';

  static Future<dio.Response> finishInventory(int inventoryId) async {
    return APIConnector.fetch('inventarios/$inventoryId/encerrar', method: HTTPVerb.PUT);
  }

  static Future<dio.Response> getActiveInventory() async {
    return APIConnector.fetch('inventarios-ativo', method: HTTPVerb.GET);
  }

  static Future<dio.Response> getAllInventories() async {
    return APIConnector.fetch('inventarios', method: HTTPVerb.GET);
  }

  // TODO: Trocar esse dynamic por um tipo verdadeiro
  static Future<dio.Response> postReading(int inventoryId, dynamic readings) async {
    return APIConnector.fetch(
      'inventarios/$inventoryId/leitura',
      method: HTTPVerb.POST,
      body: readings,
    );
  }

  static Future<dio.Response> startInventory(String employeeUsername) async {
    final Map<String, dynamic> body = {'username_funcionario': employeeUsername};

    return APIConnector.fetch('inventarios', method: HTTPVerb.POST, body: body);
  }
}
