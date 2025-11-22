import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/domain/firmware/firmware_api_response.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/utils/logger.dart';

import 'ble_connection_provider.dart';
import 'inventory_provider.dart';

part 'inventory_ble_listener_provider.g.dart';

@Riverpod()
class InventoryBleListener extends _$InventoryBleListener {
  StreamSubscription? _sub;

  @override
  void build() {
    final ble = ref.watch(bleConnectionProvider);
    final inventoryNotifier = ref.read(inventoryManagerProvider.notifier);

    _sub = ble.manager.rfidDataStream.listen((read) {
      final microcontrollerResponse = FirmwareResponse.fromJson(read);

      if (microcontrollerResponse.type != FRTypes.readResult) {
        return;
      }

      final readingResponse = ReadingResponseContent.fromMap(microcontrollerResponse.content);

      final hasError =
          !readingResponse.ok ||
          readingResponse.tagUid == null ||
          readingResponse.productOEM == null;

      if (hasError || readingResponse.productOEM == emptyTagOEM) {
        return;
      }

      inventoryNotifier.addNewReading(readingResponse);
    });

    ref.onDispose(() => _sub?.cancel());
  }
}
