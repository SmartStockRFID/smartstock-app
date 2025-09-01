import 'package:logger/logger.dart';
import 'package:smart_stock/app/bluetooth/error_state.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/ui/utils/toast_utils.dart';

import '../utils/logger.dart';

class FSMException extends InternalSystemException {
  FSMException(super.message);
}

abstract class BleState {
  Future<BleState> process();
  void dispose() {}
}

abstract class NormalBleState extends BleState {
  final toast = ToastUtils();

  Future<BleState> processState();

  @override
  Future<BleState> process() async {
    try {
      return await processState();
    } on Exception catch (e) {
      logger.e('Exception in ${runtimeType}: $e');
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      throw FSMException(errorMessage);
    }
  }
}

abstract class RetryState extends BleState {
  final logger = Logger();
  final toast = ToastUtils();
  late ErrorOrigin origin;
  final int _maxRetries;

  RetryState({required this.origin, int maxRetries = 3})
    : _maxRetries = maxRetries;

  Future<BleState> processState();

  @override
  Future<BleState> process() async {
    int attempt = 0;
    Exception? lastException;

    while (attempt < _maxRetries) {
      try {
        logger.d('Attempt ${attempt + 1}/$_maxRetries for ${runtimeType}');
        return await processState();
      } on Exception catch (e) {
        logger.e('Attempt ${attempt + 1} failed: $e');
        lastException = e;
        attempt++;

        if (attempt < _maxRetries) {
          logger.d("Retrying ($attempt/$_maxRetries)...");
          await Future.delayed(Duration(seconds: attempt));
        } else {
          logger.e("Max retries reached. Last exception: $lastException");
          break;
        }
      }
    }

    return ErrorState(previousState: origin);
  }
}
