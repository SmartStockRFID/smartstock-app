import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/utils/logger.dart';

Future<bool> appIsOffline() async {
  return !(await InternetConnection().hasInternetAccess);
}

Future<void> checkIfHasInternet() async {
  final bool isConnected = await InternetConnection().hasInternetAccess;
  if (!isConnected) {
    logger.e('Tentativa de realizar operação na Internet com app offline');
    throw const OfflineException();
  }
}
