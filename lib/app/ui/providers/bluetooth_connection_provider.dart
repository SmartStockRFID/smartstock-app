// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:smart_stock/app/config/env.dart';

// part 'bluetooth_connection_provider.g.dart';

// final Guid rfidServiceUUID = Guid(Enviroment.rfidServiceUUID());

// enum ConnectionStatus { disconnected, scanning, connecting, connected, error }

// @immutable
// class BluetoothConnectionState {
//   final BluetoothDevice? pistolDevice;
//   final ConnectionStatus status;
//   final String? errorMessage;

//   const BluetoothConnectionState({
//     this.pistolDevice,
//     this.errorMessage,
//     this.status = ConnectionStatus.disconnected,
//   });

//   BluetoothConnectionState copyWith({
//     BluetoothDevice? pistolDevice,
//     ConnectionStatus? status,
//     String? errorMessage,
//   }) {
//     return BluetoothConnectionState(
//       pistolDevice: pistolDevice ?? this.pistolDevice,
//       status: status ?? this.status,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }

// @riverpod
// class BluetoothConnection extends _$BluetoothConnection {
//   StreamSubscription? _scanSubscription;
//   @override
//   BluetoothConnectionState build() {
//     return const BluetoothConnectionState();
//   }

//   Future<void> connectToPistol() async {
//     if (state.status == ConnectionStatus.scanning ||
//         state.status == ConnectionStatus.connecting ||
//         state.status == ConnectionStatus.connected) {
//       return;
//     }

//     state = state.copyWith(status: ConnectionStatus.scanning);

//     try {
//       await FlutterBluePlus.startScan(
//         withServices: [rfidServiceUUID],
//         timeout: Duration(seconds: 15),
//       );

//       _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
//         if (results.isNotEmpty) {
//           final pistolDevice = results.first;

//           await _scanSubscription?.cancel();
//           await FlutterBluePlus.stopScan();

//           state = state.copyWith(status: ConnectionStatus.connecting);

//           try {
//             await pistolDevice.device.connect();

//             state = state.copyWith(
//               status: ConnectionStatus.connected,
//               pistolDevice: pistolDevice.device,
//             );
//             print('Conectado com sucesso à pistola!');
//           } catch (e) {
//             state = state.copyWith(
//               status: ConnectionStatus.error,
//               errorMessage: 'Erro ao conectar à pistola: $e',
//             );
//             print(e);
//           }
//         }
//       });

//       Future.delayed(const Duration(seconds: 15), () {
//         if (state.status == ConnectionStatus.scanning) {
//           state = state.copyWith(
//             status: ConnectionStatus.error,
//             errorMessage: 'Nenhuma pistola encontrada.',
//           );
//         }
//       });
//     } catch (e) {
//       state = state.copyWith(
//         status: ConnectionStatus.error,
//         errorMessage: 'Falha ao iniciar o escaneamento.',
//       );
//       print(e);
//     }
//   }

//   Future<void> disconnect() async {
//     await state.pistolDevice?.disconnect();

//     state = BluetoothConnectionState();
//   }
// }
