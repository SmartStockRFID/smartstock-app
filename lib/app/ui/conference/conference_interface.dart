import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/routing/router.dart';
import 'package:smart_stock/app/ui/conference/widgets/console_widget.dart';
import 'package:smart_stock/app/ui/conference/widgets/reading_history.dart';
import 'package:smart_stock/app/ui/providers/conference_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/providers/conference_provider.dart';
import 'package:smart_stock/app/ui/shared/types.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';
import 'package:smart_stock/app/utils/logger.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(conferenceBleListenerProvider);
    final confState = ref.watch(conferenceManagerProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildMainContent(context, confState), const _Footer()],
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
    final confState = ref.watch(conferenceManagerProvider);
    final confManager = ref.read(conferenceManagerProvider.notifier);

    if (confState.cancelReqStatus == RequestStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showFDialog(
            style: context.theme.dialogStyle
                .copyWith(
                  barrierFilter: (animation) => ImageFilter.compose(
                    outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
                    inner: ColorFilter.mode(context.theme.colors.barrier, BlendMode.srcOver),
                  ),
                )
                .call,
            context: context,
            builder: (context, style, animation) => FDialog(
              style: style,
              animation: animation,
              title: const Text('Conferência cancelada com sucesso!'),
              body: const Text(''),
              actions: [
                FButton(
                  onPress: () => context.router.popAndPush(const HomeRoute()),
                  child: const Text('Continuar'),
                ),
              ],
            ),
          );
        }
      });
    } else if (confState.finishReqStatus == RequestStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showFDialog(
            style: context.theme.dialogStyle
                .copyWith(
                  barrierFilter: (animation) => ImageFilter.compose(
                    outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
                    inner: ColorFilter.mode(context.theme.colors.barrier, BlendMode.srcOver),
                  ),
                )
                .call,
            context: context,
            builder: (context, style, animation) => FDialog(
              style: style,
              animation: animation,
              title: const Text('Conferência finalizada com sucesso!'),
              body: const Text(''),
              actions: [
                FButton(
                  style: createLargeStyle(
                    context: context,
                    backgroundColor: context.theme.colors.primary,
                    foregroundColor: context.theme.colors.primaryForeground,
                  ),
                  onPress: () => context.router.popAndPush(const HomeRoute()),
                  child: const Text('Continuar'),
                ),
              ],
            ),
          );
        }
      });
    }

    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(fontWeight: FontWeight.bold),
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
              onPress: () {
                confManager.pauseConference();
                showFDialog(
                  style: context.theme.dialogStyle
                      .copyWith(
                        barrierFilter: (animation) => ImageFilter.compose(
                          outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
                          inner: ColorFilter.mode(context.theme.colors.barrier, BlendMode.srcOver),
                        ),
                      )
                      .call,
                  context: context,
                  builder: (context, style, animation) => FDialog(
                    style: style,
                    animation: animation,
                    title: const Text('Conferência pausada'),
                    body: const Text('Não se preocupe, esse evento será registrado.'),
                    actions: [
                      FButton(
                        prefix: const Icon(FIcons.play, size: 16, color: Colors.white),
                        onPress: () {
                          Navigator.of(context).pop();
                          confManager.resumeConference();
                        },
                        child: const Text('Continuar'),
                      ),
                    ],
                  ),
                );
              },
            ),
            FButton(
              style: FButtonStyle.destructive(),
              prefix: const Icon(FIcons.square, size: 16.0, color: Colors.white),
              child: confState.cancelReqStatus == RequestStatus.loading
                  ? const Text('CANCELANDO')
                  : const Text('CANCELAR'),
              onPress: () async {
                showFDialog(
                  context: context,
                  style: context.theme.dialogStyle
                      .copyWith(
                        barrierFilter: (animation) => ImageFilter.compose(
                          outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
                          inner: ColorFilter.mode(context.theme.colors.barrier, BlendMode.srcOver),
                        ),
                      )
                      .call,
                  builder: (context, style, animation) => FDialog(
                    style: style.call,
                    animation: animation,
                    title: const Text('Você tem certeza?'),
                    body: const Column(
                      children: [
                        Text(
                          'Essa ação não pode ser desfeita. Todo o progresso da conferência atual será perdido.',
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                    actions: [
                      FButton(
                        style: FButtonStyle.outline(),
                        onPress: () => Navigator.of(context).pop(),
                        child: const Text('Voltar'),
                      ),
                      FButton(
                        onPress: () async {
                          Navigator.of(context).pop();
                          if (confState.cancelReqStatus == RequestStatus.idle) {
                            await confManager.cancelConference();
                          }
                        },
                        style: FButtonStyle.destructive(),
                        child: const Text('Cancelar'),
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
          onPress: () async {
            showFDialog(
              context: context,
              style: context.theme.dialogStyle
                  .copyWith(
                    barrierFilter: (animation) => ImageFilter.compose(
                      outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
                      inner: ColorFilter.mode(context.theme.colors.barrier, BlendMode.srcOver),
                    ),
                  )
                  .call,
              builder: (context, style, animation) => FDialog(
                style: style.call,
                animation: animation,
                title: const Text('Certeza que terminou?'),
                body: const Column(
                  children: [
                    Text(
                      'Essa ação não pode ser desfeita. A conferềncia atual será dada como encerrada.',
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                actions: [
                  FButton(
                    style: FButtonStyle.outline(),
                    onPress: () => Navigator.of(context).pop(),
                    child: const Text('Voltar'),
                  ),
                  FButton(
                    onPress: () async {
                      Navigator.of(context).pop();
                      if (confState.finishReqStatus == RequestStatus.idle) {
                        await confManager.finishConference();
                      }
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
            backgroundColor: context.theme.colors.primary,
            foregroundColor: context.theme.colors.primaryForeground,
          ),
          child: confState.finishReqStatus == RequestStatus.loading
              ? const Text('FINALIZANDO')
              : const Text('FINALIZAR'),
        ),
      ],
    );
  }
}
