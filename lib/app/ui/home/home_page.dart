import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/ui/home/bluetooth_status_widget.dart';
import 'package:smart_stock/app/ui/home/pistol_status_widget.dart';
import 'package:smart_stock/app/ui/providers/bluetooth_connection_provider.dart';
import 'package:smart_stock/app/routing/router.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página inicial')),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [BluetoothStatusWidget(), PistolStatusWidget()],
            ),
          ),
          Center(child: ConferenceButton()),
        ],
      ),
    );
  }
}

class ConferenceButton extends ConsumerWidget {
  const ConferenceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bluetoothConnectionProvider);
    isConnected() => pistolConnection.status == ConnectionStatus.connected;
    return OutlinedButton(
      onPressed: () {
        if (isConnected()) {
          context.router.push(ConferenceRoute());
        }
      },
      style: ButtonStyle(
        backgroundColor: isConnected()
            ? null
            : WidgetStatePropertyAll<Color>(Colors.grey),
      ),
      child: const Text('Conferência'),
    );
  }
}
