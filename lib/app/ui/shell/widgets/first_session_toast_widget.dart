import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';

final getIsFirstSession = FutureProvider<bool>((ref) async {
  return await FirstTimeOnAppStorage.getValue();
});

class FirstSessionToastRunner extends HookConsumerWidget {
  final Widget child;

  const FirstSessionToastRunner({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(getIsFirstSession, (_, state) async {
      if (state.hasValue && state.value == true) {
        showFToast(
          context: context,
          title: const Text('Dica: Leitura rápida'),
          description: const Text('Aperte o gatilho para ver o conteúdo de uma etiqueta'),
          alignment: FToastAlignment.bottomCenter,
        );
        await FirstTimeOnAppStorage.setNegative();
      }
    });

    return child;
  }
}
