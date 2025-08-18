import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/ui/providers/bluetooth_connection_provider.dart';

class PistolStatusWidget extends ConsumerStatefulWidget {
  const PistolStatusWidget({super.key});

  @override
  ConsumerState<PistolStatusWidget> createState() => _PistolStatusWidgetState();
}

class _PistolStatusWidgetState extends ConsumerState<PistolStatusWidget> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(bluetoothConnectionProvider.notifier).connectToPistol();
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(bluetoothConnectionProvider);

    switch (connectionState.status) {
      case ConnectionStatus.disconnected:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.leak_remove, size: 64.0, color: Colors.grey),
        );
      case ConnectionStatus.error:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.leak_remove, size: 64.0, color: Colors.red),
        );
      case ConnectionStatus.connected:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.leak_add, size: 64.0, color: Colors.green),
        );
      case ConnectionStatus.scanning:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.leak_add, size: 64.0, color: Colors.grey),
        );
      case ConnectionStatus.connecting:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.leak_add, size: 64.0, color: Colors.amberAccent),
        );
    }
  }
}
