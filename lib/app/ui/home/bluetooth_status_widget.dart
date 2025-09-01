// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BluetoothStatusWidget extends StatefulWidget {
//   const BluetoothStatusWidget({super.key});

//   @override
//   State<BluetoothStatusWidget> createState() => _BluetoothStatusWidgetState();
// }

// class _BluetoothStatusWidgetState extends State<BluetoothStatusWidget> {
//   bool bluetoothState = false;
//   Future getBLEPermission() async {
//     try {
//       await Permission.bluetooth.request();
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future setupBLE() async {
//     await getBLEPermission();
//     FlutterBluePlus.setLogLevel(LogLevel.verbose);
//     FlutterBluePlus.turnOn();
//   }

//   @override
//   void initState() {
//     super.initState();
//     setupBLE();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FlutterBluePlus.adapterState,
//       builder: (context, snapshot) {
//         if (snapshot.data != null) {
//           if (snapshot.data == BluetoothAdapterState.on) {
//             bluetoothState = true;
//           } else if (snapshot.data == BluetoothAdapterState.off) {
//             bluetoothState = false;
//           }
//           return Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Icon(
//               Icons.bluetooth,
//               size: 64.0,
//               color: bluetoothState ? Colors.green : Colors.grey,
//             ),
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }


