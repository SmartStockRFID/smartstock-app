// lib/app/bluetooth/connnected_state.dart

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/bluetooth/base_ble_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_off_state.dart';
import 'package:smart_stock/app/bluetooth/bluetooth_on_state.dart';
import 'package:smart_stock/app/bluetooth/permission_denied_state.dart';
import 'package:smart_stock/app/utils/logger.dart';

class ConnectedState extends NormalBleState {
  final BluetoothDevice connectedPistol;
  StreamSubscription? _pistolSub;
  StreamSubscription? _adapterSub;

  ConnectedState({required this.connectedPistol, required super.manager});

  @override
  Future<BleState> processState() async {
    logger.d('Dispositivo conectado: ${connectedPistol.remoteId}');

    final promise = Completer<BleState>();

    // --- ADIÇÃO IMPORTANTE ---
    // Inicia a escuta das características assim que entramos neste estado.
    try {
      await manager.readCharacteristic(connectedPistol);
      logger.d('✅ Assinatura de notificações ativada com sucesso!');
    } catch (e) {
      logger.e('❌ Falha ao ativar notificações: $e');
      // Se falhar, voltamos ao estado anterior para tentar reconectar.
      return BluetoothOnState(manager: manager);
    }
    // --- FIM DA ADIÇÃO ---


    // Ouve por mudanças no estado da conexão do dispositivo
    _pistolSub = connectedPistol.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected && !promise.isCompleted) {
        logger.d('Dispositivo desconectado, retornando para BluetoothOnState');
        promise.complete(BluetoothOnState(manager: manager));
      }
    });

    // Ouve por mudanças no estado do adaptador Bluetooth do celular
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off && !promise.isCompleted) {
        logger.w('Bluetooth foi desligado enquanto estava conectado.');
        promise.complete(BluetoothOffState(manager: manager));
      } else if (state == BluetoothAdapterState.unauthorized && !promise.isCompleted) {
        logger.e('Permissão de Bluetooth revogada enquanto estava conectado.');
        promise.complete(PermissionDeniedState(manager: manager));
      }
    });

    // AGORA, simplesmente aguardamos a promise ser completada por um evento real.
    // Sem timeout. O estado permanecerá aqui até que algo aconteça.
    final nextState = await promise.future;

    // A limpeza agora é feita aqui, após a conclusão da promise.
    await _pistolSub?.cancel();
    await _adapterSub?.cancel();

    return nextState;
  }

  @override
  void dispose() {
    logger.d('Descartando ConnectedState');
    _pistolSub?.cancel();
    _adapterSub?.cancel();
    super.dispose();
  }
}