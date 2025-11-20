import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

part 'label_controller.g.dart';

@Riverpod(keepAlive: true) // Todo: This is a gambiarra
class LabelController extends _$LabelController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> writeOnTag({required String productOem}) async {
    state = const AsyncValue.loading();
    try {
      final bleConnection = ref.read(bleConnectionProvider);
      await bleConnection.manager.writeCharacteristic(
        bleConnection.manager.connectedPistol,
        productOem,
      );

      Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }
}
