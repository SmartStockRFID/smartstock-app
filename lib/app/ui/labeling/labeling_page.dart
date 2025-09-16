import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/labeling/labeling_interface.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class LabelingPage extends StatelessWidget {
  const LabelingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: baseAppBar(title: 'Etiquetagem'),
        body: const LabelingPageInterface(),
      ),
    );
  }
}
