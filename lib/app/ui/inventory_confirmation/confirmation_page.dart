import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/inventory_confirmation/confirmation_interface.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class ConferenceConfirmationPage extends StatelessWidget {
  const ConferenceConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: baseAppBar(title: 'Iniciar inventário'),
        body: const ConferenceConfirmationInterface(),
      ),
    );
  }
}
