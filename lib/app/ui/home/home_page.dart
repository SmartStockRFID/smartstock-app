import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/home/back_status_widget.dart';
import 'package:smart_stock/app/ui/home/ble_status_widget.dart';
import 'package:smart_stock/app/ui/home/status_panel_widget.dart';
import 'package:smart_stock/app/ui/home/stock_status_widget.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';

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
        appBar: baseAppBar(
          widgetTitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text("Newland Toyota"),
              // const SizedBox(width: 10),
              Image.asset(
                Assets.toyotaLogo,
                // TODO: Ajeitar a proporção
                height: MediaQuery.of(context).size.height / 15,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: StatusPanelWidget()),
              Column(
                spacing: 15,
                children: [
                  ConferenceButton(),
                  LabelingButton(),
                  // ResetButton(),
                  // ConferencesHistory(),
                ],
              ),

              // Center(child: StockStatusWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: Refator como NavigationButton talvez, mesmo que fique só nesse arquivo
class ConferenceButton extends ConsumerWidget {
  const ConferenceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    final stockState = ref.watch(stockProvider);
    bool isConnected() =>
        pistolConnection.fsm.currentState is ConnectedState && stockState.hasValue;
    return FButton(
      style: isConnected()
          ? createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.primary,
              foregroundColor: context.theme.colors.primaryForeground,
            )
          : createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.secondary,
              foregroundColor: context.theme.colors.disable(
                context.theme.colors.secondaryForeground,
              ),
            ),
      prefix: isConnected()
          ? const Icon(FIcons.scanText, size: 20, color: Colors.white)
          : const Icon(FIcons.scanText, size: 20, color: Colors.grey),
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
    final stockState = ref.watch(stockProvider);
    bool isConnected() =>
        pistolConnection.fsm.currentState is ConnectedState && stockState.hasValue;
    return FButton(
      style: isConnected()
          ? createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.primary,
              foregroundColor: context.theme.colors.primaryForeground,
            )
          : createLargeStyle(
              context: context,
              backgroundColor: context.theme.colors.secondary,
              foregroundColor: context.theme.colors.disable(
                context.theme.colors.secondaryForeground,
              ),
            ),
      prefix: isConnected()
          ? const Icon(FIcons.squarePen, size: 20, color: Colors.white)
          : const Icon(FIcons.squarePen, size: 20, color: Colors.grey),
      child: const Text('Etiquetagem'),
      onPress: () {
        if (isConnected()) {
          context.router.push(const LabelingRoute());
        }
      },
    );
  }
}
