// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_stock/app/bluetooth/connect_state.dart';
// import 'package:smart_stock/app/bluetooth/connnected_state.dart';
// import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';

// class PistolStatusWidget extends ConsumerStatefulWidget {
//   const PistolStatusWidget({super.key});

//   @override
//   ConsumerState<PistolStatusWidget> createState() => _PistolStatusWidgetState();
// }

// class _PistolStatusWidgetState extends ConsumerState<PistolStatusWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final connectionState = ref.watch(bleConnectionProvider);

//     if (connectionState.fsm.currentState is ConnnectedState) {
//       return Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Icon(Icons.leak_add, size: 64.0, color: Colors.green),
//       );
//     } else if (connectionState.fsm.currentState is ConnectState) {
//       return Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Icon(Icons.leak_add, size: 64.0, color: Colors.yellow),
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Icon(Icons.leak_add, size: 64.0, color: Colors.grey),
//       );
//     }
//   }
// }
