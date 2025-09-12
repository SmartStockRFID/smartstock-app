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
          return FCard(
            child: Column(
              children: [
                Text(
                  'AGUARDANDO LEITURA...',
                  style: typography.sm.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text(
                  '...',
                  style: typography.xl4.copyWith(
                    color: context.theme.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('OEM: ---'),
                Text(
                  'QUANTIDADE TOTAL',
                  style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  '--',
                  style: typography.xl5.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return FCard(
          child: Column(
            children: [
              Text(
                'LENDO...',
                style: typography.sm.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Text(
                'Desconhecido',
                style: typography.xl4.copyWith(
                  color: context.theme.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('OEM: ${confState.readings.last.productOEM}'),
              Text(
                'QUANTIDADE TOTAL',
                style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                confState.readings.last.tagCount.toString(),
                style: typography.xl5.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
