import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/conference/widgets/console_widget.dart';
import 'package:smart_stock/app/ui/conference/widgets/reading_history.dart';
import 'package:smart_stock/app/ui/providers/conference_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';

class ConferencePageInterface extends ConsumerWidget {
  const ConferencePageInterface({super.key});

  Widget _buildMainContent(BuildContext context, ConferenceManagerState confState) {
    return Column(
      children: [
        ConsoleWidget(confState: confState),
        ReadingHistoryWidget(confState: confState),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ConferenceManagerState confState) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(fontWeight: FontWeight.bold),
            children: [
              const TextSpan(text: 'Total de itens: '),
              TextSpan(
                text: confState.readingsCount.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FButton(
              style: FButtonStyle.secondary(),
              prefix: const Icon(FIcons.pause, size: 16, color: Colors.black),
              child: const Text('PAUSAR'),
              onPress: () {},
            ),
            FButton(
              style: FButtonStyle.destructive(),
              prefix: const Icon(FIcons.square, size: 16.0, color: Colors.white),
              child: const Text('INTERROMPER'),
              onPress: () {},
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        FButton(
          onPress: () {},
          prefix: const Icon(FIcons.circleCheck, size: 16.0, color: Colors.white),
          child: const Text('FINALIZAR'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(conferenceBleListenerProvider);
    final confState = ref.watch(conferenceManagerProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildMainContent(context, confState), _buildFooter(context, confState)],
      ),
    );
  }
}



