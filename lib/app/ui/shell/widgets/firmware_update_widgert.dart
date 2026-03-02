import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/bluetooth/connnected_state.dart';
import 'package:smart_stock/app/config/env.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/domain/interfaces/firmware_version_interface.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/utils/internet.dart';
import 'package:smart_stock/app/utils/json.dart';
import 'package:version/version.dart';

final lastFirmwareVersion = FutureProvider<FirmwareVersion?>((ref) async {
  const headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

  await checkIfHasInternet();

  final firmwareUpdateList =
      await FirmwareUpdateUrlStorage.getValue() ?? Enviroment.firmwareUpdateListURL();

  final response = await Dio().get(
    Uri.parse(firmwareUpdateList).toString(),
    options: Options(headers: headers),
  );

  final List<dynamic> body = response.data;
  checkIfIsList(response.data);

  if (body.isEmpty) {
    return null;
  }

  final asList = body.map(FirmwareVersion.fromJson).toList();

  return asList.lastOrNull;
});

final updateFirmwareMutation = Mutation<void>();

void showFirmwareUpdateModal(BuildContext context) {
  showFDialog(
    context: context,
    barrierDismissible: false,
    builder: (context, style, animation) => FDialog(actions: const [], body: FirmwareUpdateModal()),
  );
}

class FirmwareUpdateModal extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firmwareVersionsQuery = ref.watch(lastFirmwareVersion);

    final currentFirmwareVersion = useState<Version?>(null);
    final awaitingBleConnection = useState(true);

    final updateFirmwareState = ref.watch(updateFirmwareMutation);

    useEffect(() {
      final initialBleState = ref.read(bleConnectionProvider).currentState;

      if (initialBleState is ConnectedState) {
        void checkUpdate() async {
          final version = await initialBleState.manager.getCurrentVersion();
          if (version != null) {
            currentFirmwareVersion.value = version;
          }
          awaitingBleConnection.value = false;
        }

        checkUpdate();
      }
      return () {};
    }, []);

    ref.listen(bleConnectionProvider, (_, state) async {
      if (state.currentState is ConnectedState) {
        final version = await state.currentState.manager.getCurrentVersion();
        if (version != null) {
          currentFirmwareVersion.value = version;
        }
        awaitingBleConnection.value = false;
      }
    });

    final bleState = ref.watch(bleConnectionProvider.select((state) => state.currentState));
    final bleManager = bleState.manager;

    Widget loadingWidget(String text) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(text, style: context.theme.typography.base),
          const SizedBox(height: 24, width: 24, child: CircularProgressIndicator()),
        ],
      );
    }

    Widget errorWidget(String title, String? description) {
      return FAlert(
        title: Text(
          title,
          style: context.theme.typography.base.copyWith(color: Colors.red),
          textAlign: TextAlign.start,
        ),
        subtitle: description != null
            ? Text(description, style: context.theme.typography.xs, textAlign: TextAlign.start)
            : null,
        icon: const Icon(FIcons.circleX, color: Colors.red),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Atualizar firmware',
          style: context.theme.typography.xl.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 18),
        firmwareVersionsQuery.when(
          data: (latestVersion) {
            if (currentFirmwareVersion.value != null) {
              if (awaitingBleConnection.value) {
                return loadingWidget('Aguardando resposta do leitor');
              } else if (latestVersion == null) {
                return errorWidget(
                  'Comunicação falhou',
                  'O servidor não conseguiu responder qual é a versão mais recente do firmware',
                );
              } else if (latestVersion.version > currentFirmwareVersion.value) {
                // Todo: Cara, nao sei se essa logica das condiiconais ta correta nao, melhor revisar
                return Column(
                  children: [
                    ...(updateFirmwareState is MutationPending
                        ? [
                            Text(
                              'Atualizando para ${latestVersion.version}...',
                              style: context.theme.typography.base.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Por favor, não feche o aplicativo ou desligue o leitor até a atualização terminar',
                              style: context.theme.typography.xs.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 24),

                            const FProgress(),
                          ]
                        : [
                            Text(
                              'Update para ${latestVersion.version} disponível!',
                              style: context.theme.typography.base.copyWith(color: Colors.black),
                            ),
                            Text(
                              latestVersion.releaseNotes,
                              style: context.theme.typography.sm.copyWith(color: Colors.black54),
                            ),
                          ]),
                    const SizedBox(height: 24),
                    // FButton(
                    //   onPress: () {
                    //     if (updateFirmwareState is MutationPending) {
                    //       return;
                    //     }
                    //     updateFirmwareMutation.run(ref, (tsx) async {
                    //       await ref
                    //           .read(bleConnectionProvider)
                    //           .currentState
                    //           .manager
                    //           .upgrade(latestVersion.url);
                    //       if (context.mounted) {
                    //         context.pop();
                    //       }
                    //     });
                    //   },
                    //   style: primaryLargeButton(
                    //     context,
                    //     disabled: updateFirmwareState is MutationPending,
                    //   ),
                    //   child: updateFirmwareState is MutationPending
                    //       ? Text(
                    //           'ATUALIZANDO...',
                    //           style: context.theme.typography.xl.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.white,
                    //           ),
                    //         )
                    //       : Text(
                    //           'ATUALIZAR',
                    //           style: context.theme.typography.xl.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    // ),
                  ],
                );
              } else {
                return Text(
                  'Firmware já na última versão ${currentFirmwareVersion.value}',
                  style: context.theme.typography.base.copyWith(color: Colors.blue[600]),
                );
              }
            }
            return loadingWidget('Aguardando conexão com o leitor');
          },
          error: (e, trace) =>
              errorWidget('Erro ao buscar atualizações', 'Não foi possível consultar o servidor'),
          loading: () => loadingWidget('Buscando atualizações...'),
        ),
        const SizedBox(height: 8),

        // FButton(
        //   style: createLargeStyle(
        //     context: context,
        //     backgroundColor: context.theme.colors.secondary,
        //     foregroundColor: context.theme.colors.secondaryForeground,
        //   ),
        //   onPress: () {
        //     if (updateFirmwareState is MutationPending) {
        //       return;
        //     }

        //     Navigator.of(context).pop();
        //   },
        //   child: Text(
        //     'VOLTAR',
        //     style: context.theme.typography.xl.copyWith(
        //       fontWeight: FontWeight.bold,
        //       color: Colors.grey,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
