import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/encoding/setup/encoding_setup_page.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

part 'label_controller.g.dart';

@Riverpod(keepAlive: true) // Todo: This is a gambiarra
class LabelController extends _$LabelController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> writeOnTag({String? productOem, required WritingMode mode}) async {
    state = const AsyncValue.loading();
    try {
      final bleManager = ref.read(
        bleConnectionProvider.select((state) => state.currentState.manager),
      );
      await bleManager.writeCharacteristic(
        bleManager.connectedPistol,
        mode == WritingMode.RESET ? emptyTagOEM : (productOem ?? ''),
      );

      Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }
}
