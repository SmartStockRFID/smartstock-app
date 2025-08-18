import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_stock/app/ui/home/pistol_status_widget.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool bluetoothState = false;

  Future getPermissions() async {
    try {
      await Permission.bluetooth.request();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
    FlutterBluePlus.turnOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página inicial')),
      body: Row(
        children: [
          StreamBuilder(
            stream: FlutterBluePlus.adapterState,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.data == BluetoothAdapterState.on) {
                  bluetoothState = true;
                } else if (snapshot.data == BluetoothAdapterState.off) {
                  bluetoothState = false;
                }
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.bluetooth,
                    size: 64.0,
                    color: bluetoothState ? Colors.green : Colors.grey,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          PistolStatusWidget(),
        ],
      ),
    );
  }
}
