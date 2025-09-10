import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';

class ConsoleWidget extends StatelessWidget {
  final ConferenceManagerState confState;

  const ConsoleWidget({required this.confState});

 
  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;

    return Builder(
      builder: (context) {
        if (confState.readings.isEmpty) {
          return const Text('Aguardando tags...');
        }

        return FCard(
          child: Column(
            children: [
              Text(
                'LENDO...',
                style: typography.sm.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Text(
                confState.readings.last.productOEM,
                style: typography.xl4.copyWith(
                  color: context.theme.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Código OEM: 1234567890'),
              Text(
                'QUANTIDADE TOTAL',
                style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                '1',
                style: typography.xl5.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}