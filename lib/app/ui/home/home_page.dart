import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/home/bluetooth_status_widget.dart';
import 'package:smart_stock/app/ui/home/conference_button_widget.dart';
import 'package:smart_stock/app/ui/home/pistol_status_widget.dart';
import 'package:smart_stock/app/ui/home/stock_status_widget.dart';

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
          Center(child: StockStatusWidget()),
        ],
      ),
    );
  }
}
