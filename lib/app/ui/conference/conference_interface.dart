import 'dart:ui';

import 'package:smart_stock/app/domain/entities/part_entity.dart';
import 'package:smart_stock/app/ui/shared/custom_card.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/providers/conference_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';
import 'package:smart_stock/app/ui/shared/types.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';

// --- WIDGET PRINCIPAL DA INTERFACE ---
class ConferencePageInterface extends ConsumerWidget {
  const ConferencePageInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(conferenceBleListenerProvider);
    final confState = ref.watch(conferenceManagerProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Scoreboard(confState: confState),
                  const SizedBox(height: 16),
                  _CurrentItem(confState: confState),
                  const SizedBox(height: 16),
                  _ReadingHistory(confState: confState),
                ],
              ),
            ),
          ),
          _Footer(key: UniqueKey()),
        ],
      ),
    );
  }
}

class _Scoreboard extends ConsumerWidget {
  const _Scoreboard({required this.confState});
  final ConferenceManagerState confState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomCard(
      title: Text('Resumo do Inventário'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ScoreboardItem(count: confState.readings.length, label: 'Produtos Únicos'),
          _ScoreboardItem(count: confState.readingsCount, label: 'Etiquetas Lidas'),
        ],
      ),
    );
  }
}

class _ScoreboardItem extends StatelessWidget {
  const _ScoreboardItem({required this.count, required this.label});
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _CurrentItem extends ConsumerWidget {
  const _CurrentItem({required this.confState});
  final ConferenceManagerState confState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);
    final lastReading = confState.readings.isNotEmpty
        ? confState.readings.last
        : null;

    return CustomCard(
      title: const Text('Item Atual'),
      child: SizedBox(
        height: 120,
        child: Center(
          child: lastReading == null
              ? const Text('Aguardando leitura...', style: TextStyle(fontSize: 16))
              : _buildReadingState(context, stockState, lastReading),
        ),
      ),
    );
  }

  Widget _buildReadingState(
    BuildContext context,
    AsyncValue<List<CarPart>> stockState,
    ProductReadings lastReading,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              stockState.when(
                data: (parts) {
                  final productIndex = parts.indexWhere(
                    (p) => p.productCode == lastReading.productOEM,
                  );
                  return Text(
                    productIndex != -1 ? parts[productIndex].name : 'DESCONHECIDO',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                error: (e, st) => const Text('Desconhecido'),
                loading: () => const Text('Procurando...'),
              ),
              const SizedBox(height: 8),
              Text('OEM: ${lastReading.productOEM}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lastReading.tagCount.toString(),
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const Text("Unidades"),
          ],
        ),
      ],
    );
  }
}

class _ReadingHistory extends ConsumerWidget {
  const _ReadingHistory({required this.confState});
  final ConferenceManagerState confState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockProvider);

    if (confState.readings.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomCard(
      title: Text('Histórico'),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: confState.readings.length,
        itemBuilder: (context, index) {
          final reading = confState.readings[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: stockState.when(
              data: (parts) {
                final productIndex = parts.indexWhere((p) => p.productCode == reading.productOEM);
                return Text(
                  productIndex != -1 ? parts[productIndex].name : 'Desconhecido',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
              error: (e, st) => const Text('Desconhecido'),
              loading: () => const Text('Procurando...'),
            ),
            subtitle: Text('OEM: ${reading.productOEM}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${reading.tagCount} un',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(DateFormat.Hm().format(reading.readTags.last.readTimestamp)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class _Footer extends ConsumerStatefulWidget {
  const _Footer({super.key});

  @override
  ConsumerState<_Footer> createState() => _FooterState();
}


class _FooterState extends ConsumerState<_Footer> {
  @override
  Widget build(BuildContext context) {
    final confManager = ref.read(conferenceManagerProvider.notifier);

    ref.listen<ConferenceManagerState>(conferenceManagerProvider, (previous, next) {
      final wasPaused = previous?.isPaused ?? false;
      if (!wasPaused && next.isPaused) {
        showFDialog(
          context: context,
          builder: (context, style, animation) => FDialog(
            style: style,
            animation: animation,
            title: const Text('Inventário pausado'),
            body: const Text('Não se preocupe, seu progresso está salvo.'),
            actions: [
              FButton(
                onPress: () {
                  Navigator.of(context).pop();
                  confManager.resumeConference();
                },
                child: const Text('Continuar'),
                prefix: const Icon(FIcons.play, size: 16, color: Colors.white),
              ),
            ],
          ),
        );
      }
    });

    ref.listen<ConferenceManagerState>(conferenceManagerProvider, (previous, next) {
      final wasNotSuccess = previous?.cancelReqStatus != RequestStatus.success;
      if (wasNotSuccess && next.cancelReqStatus == RequestStatus.success) {
        showFDialog(
          context: context,
          builder: (context, style, animation) => FDialog(
            style: style,
            animation: animation,
            title: const Text('Inventário cancelado!'),
            actions: [
              FButton(
                onPress: () => context.router.replaceAll([const HomeRoute()]),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    ref.listen<ConferenceManagerState>(conferenceManagerProvider, (previous, next) {
      final wasNotSuccess = previous?.finishReqStatus != RequestStatus.success;
      if (wasNotSuccess && next.finishReqStatus == RequestStatus.success) {
        showFDialog(
          context: context,
          builder: (context, style, animation) => FDialog(
            style: style,
            animation: animation,
            title: const Text('Inventário finalizado com sucesso!'),
            actions: [
              FButton(
                onPress: () => context.router.replaceAll([const HomeRoute()]),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
    final confState = ref.watch(conferenceManagerProvider);

    final bool canClick =
        confState.finishReqStatus != RequestStatus.loading &&
        confState.finishReqStatus != RequestStatus.success &&
        confState.cancelReqStatus != RequestStatus.loading &&
        confState.cancelReqStatus != RequestStatus.success;

    final disabledPriBackgroundColor = context.theme.colors.primary;
    final disabledPriForegroundColor = context.theme.colors.disable(
      context.theme.colors.primaryForeground,
    );
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FButton(
              style: FButtonStyle.secondary(),
              prefix: const Icon(FIcons.pause, size: 16, color: Colors.black),
              child: const Text('PAUSAR'),
              onPress: () => confManager.pauseConference(),
            ),
            FButton(
              style: FButtonStyle.destructive(),
              prefix: const Icon(FIcons.square, size: 16.0, color: Colors.white),
              child: confState.cancelReqStatus == RequestStatus.loading
                  ? const Text('CANCELANDO')
                  : const Text('CANCELAR'),
              onPress: () {
                showFDialog(
                  context: context,
                  builder: (context, style, animation) => FDialog(
                    style: style,
                    animation: animation,
                    title: const Text('Você tem certeza?'),
                    body: const Text('Essa ação não pode ser desfeita.'),
                    actions: [
                      FButton(
                        style: FButtonStyle.outline(),
                        onPress: () => Navigator.of(context).pop(),
                        child: const Text('Voltar'),
                      ),
                      FButton(
                        onPress: () {
                          Navigator.of(context).pop();
                          confManager.cancelConference();
                        },
                        style: FButtonStyle.destructive(),
                        child: const Text('Cancelar Inventário'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        FButton(
          onPress: () {
            showFDialog(
              context: context,
              builder: (context, style, animation) => FDialog(
                style: style,
                animation: animation,
                title: const Text('Finalizar o inventário?'),
                body: const Text('A contagem atual será salva como final.'),
                actions: [
                  FButton(
                    style: FButtonStyle.outline(),
                    onPress: () => Navigator.of(context).pop(),
                    child: const Text('Voltar'),
                  ),
                  FButton(
                    onPress: () {
                      Navigator.of(context).pop();
                      confManager.finishConference();
                    },
                    child: const Text('Encerrar'),
                  ),
                ],
              ),
            );
          },
          prefix: const Icon(FIcons.circleCheck, size: 16.0, color: Colors.white),
          style: createLargeStyle(
            context: context,
            backgroundColor: canClick ? context.theme.colors.primary : disabledPriBackgroundColor,
            foregroundColor: canClick ? context.theme.colors.primaryForeground : disabledPriForegroundColor,
          ),
          child: confState.finishReqStatus == RequestStatus.loading
              ? const Text('FINALIZANDO...')
              : (confState.finishReqStatus == RequestStatus.success
                    ? const Text('FINALIZADA')
                    : const Text('FINALIZAR')),
        ),
      ],
    );
  }
}
