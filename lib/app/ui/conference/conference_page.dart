import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class ConferencePage extends StatelessWidget {
  const ConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar(title: 'Conferência'),
      backgroundColor: Colors.white,
    );
  }
}
