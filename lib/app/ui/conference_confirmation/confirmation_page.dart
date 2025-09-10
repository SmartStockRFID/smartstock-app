import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/conference_confirmation/confirmation_interface.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class ConferenceConfirmationPage extends StatelessWidget {
  const ConferenceConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        appBar: baseAppBar(title: 'Iniciar conferência'),
        body: const ConferenceConfirmationInterface(),
      ),
    );
  }
}
