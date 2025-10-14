import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/ui/conference/conference_interface.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';

@RoutePage()
class ConferencePage extends StatelessWidget {
  const ConferencePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Page();
  }
}

class Page extends ConsumerWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confState = ref.watch(conferenceManagerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: baseAppBar(title: 'Inventário nº ${confState.id}'),
        backgroundColor: Colors.white,
        body: const ConferencePageInterface(),
      ),
    );
  }
}
