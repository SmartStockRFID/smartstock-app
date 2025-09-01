import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/home/ble_status_widget.dart';
import 'package:smart_stock/app/ui/home/stock_status_widget.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(title: 'Página inicial'),
        backgroundColor: Colors.white,
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [BleStatusWidget()],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                spacing: 8,
                children: [
                  ConferenceButton(),
                  LabelingButton(),
                  ResetButton(),
                  ConferencesHistory(),
                ],
              ),
            ),
            Center(child: StockStatusWidget()),
          ],
        ),
      ),
    );
  }
}

class ConferenceButton extends ConsumerWidget {
  const ConferenceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    bool isConnected() => pistolConnection.fsm.currentState is ConnectedState;
    return FButton(
      prefix: const Icon(FIcons.scanText, size: 16, color: Colors.white),
      child: const Text('Leitura'),
      onPress: () {
        if (isConnected()) {
          context.router.push(const ConferenceConfirmationRoute());
        }
      },
    );
  }
}

class LabelingButton extends ConsumerWidget {
  const LabelingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    isConnected() => pistolConnection.fsm.currentState is ConnectedState;
    return FButton(
      prefix: const Icon(FIcons.squarePen, size: 16, color: Colors.white),
      child: const Text('Etiquetagem'),
      onPress: () {
        if (isConnected()) {}
      },
    );
  }
}

class ResetButton extends ConsumerWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    bool isConnected() => pistolConnection.fsm.currentState is ConnectedState;
    return FButton(
      prefix: const Icon(FIcons.rotateCcw, size: 16, color: Colors.white),
      child: const Text('Regravação/Reset'),
      onPress: () {
        if (isConnected()) {}
      },
    );
  }
}

class ConferencesHistory extends StatelessWidget {
  const ConferencesHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return FButton(
      prefix: const Icon(FIcons.clipboardList, size: 16, color: Colors.black),
      onPress: () {},
      style: FButtonStyle.secondary(),
      child: const Text('Histórico de conferências'),
    );
  }
}
