import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/shared/base_list_widget.dart';

class ConferencePageInterface extends StatelessWidget {
  const ConferencePageInterface({super.key});

  Widget _buildMainContent(BuildContext context) {
    return const Column(children: [_ConsoleWidget(), _ReadingHistoryWidget()]);
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Text.rich(
          TextSpan(
            style: TextStyle(fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Total de itens: '),
              TextSpan(
                text: '55',
                style: TextStyle(color: Colors.grey),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildMainContent(context), _buildFooter(context)],
      ),
    );
  }
}

class _ConsoleWidget extends ConsumerWidget {
  const _ConsoleWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pistolConnection = ref.watch(bleConnectionProvider);
    final typography = context.theme.typography;

    return StreamBuilder(
      stream: pistolConnection.manager.rfidDataStream,
      builder: (context, snapshot){
        if(snapshot.data == null){
          return Placeholder(child: Text('Aguardando leitura...'),);
        }
        return FCard(
          child: Column(
            children: [
              Text(
                'LENDO...',
                style: typography.sm.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Text(
                snapshot.data ?? 'Produto X',
                style: typography.xl4.copyWith(
                  color: context.theme.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Código OEM: 1234567890'),
              Text(
                'QUANTIDADE',
                style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                '25',
                style: typography.xl5.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReadingHistoryWidget extends StatelessWidget {
  const _ReadingHistoryWidget();

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
    return SizedBox(
      height: 200,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Histórico de Leitura',
                  style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            BaseList(
              isLoading: false,
              emptyMessage: 'Aguardando leituras.',
              data: const [1, 2],
              heightPercentage: 0.2,
              widthPercentage: 0.9,
              itemBuilder: (reading) {
                return FCard(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [Text('Product X'), Text('OEM: 1234567890')]),
                      Row(children: [Text('10'), Text('14:22:12')]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
