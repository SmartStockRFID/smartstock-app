import 'dart:async';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/utils/logger.dart';

class BleFSM {
  BleState? _currentState;
  BleState? get currentState => _currentState;

  bool _isProcessing = false;

  final StreamController<BleState> _stateController = StreamController<BleState>.broadcast();
  Stream<BleState> get stateStream => _stateController.stream;

  void start(BleState initialState) {
    logger.i('🚀 FSM INICIANDO com estado: ${initialState.runtimeType}');
    _currentState = initialState;
    _stateController.add(initialState);
    _processLoop();
  }

  void _processLoop() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_currentState != null) {
      final stateToProcess = _currentState!;
      try {
        logger.d('⚙️ Processando estado: ${stateToProcess.runtimeType}');
        final nextState = await stateToProcess.process();

        // Normal transition if we were not interrupted by ourselves
        if (_currentState == stateToProcess) {
          _currentState?.dispose(); // Clear last state
          _currentState = nextState;
          _stateController.add(_currentState!);
        }
      } catch (e, stackTrace) {
        logger.e(
          '❌ Erro no processamento do estado ${stateToProcess.runtimeType}',
          error: e,
          stackTrace: stackTrace,
        );
        // In case of erros, stop the loop; ErrorState should be called?
        break;
      }
    }
    _isProcessing = false;
  }

  void dispose() {
    logger.w('🛑 FSM sendo descartada!');
    _currentState?.dispose();
    _currentState = null;
    _stateController.close();
  }
}
