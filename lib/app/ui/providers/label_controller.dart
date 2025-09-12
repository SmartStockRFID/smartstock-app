import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

part 'label_controller.g.dart';

@riverpod
class LabelController extends _$LabelController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> writeOnTag({required String productOem}) async {
    logger.d('Entrei no writeOnTag');
    state = const AsyncValue.loading();
    try {
      logger.d('Comecei no writeOnTag');
      final bleConnection = ref.watch(bleConnectionProvider);
      await bleConnection.manager.writeCharacteristic(
        bleConnection.manager.connectedPistol,
        productOem,
      );
      logger.d('Deu bom no writeOnTag!');

      state = const AsyncValue.data(null);
    } catch (e) {
      logger.e('Deu ruim no writeOnTag! $e');

      state = const AsyncValue.data(null);
    }
  }
}
