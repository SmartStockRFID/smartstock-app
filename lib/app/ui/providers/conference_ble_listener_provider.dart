import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/domain/objects/firmware_api_object.dart';
import 'package:smart_stock/app/domain/objects/reading_object.dart';

import 'ble_connection_provider.dart';
import 'conference_provider.dart';

part 'conference_ble_listener_provider.g.dart';

@Riverpod()
class ConferenceBleListener extends _$ConferenceBleListener {
  StreamSubscription? _sub;

  @override
  void build() {
    final ble = ref.watch(bleConnectionProvider);
    final conferenceNotifier = ref.read(conferenceManagerProvider.notifier);

    _sub = ble.manager.rfidDataStream.listen((read) {
      final microcontrollerResponse = FirmwareObject.fromJson(read);

      if (microcontrollerResponse.type != FirmwareObjectType.ReadResult) {
        return;
      }

      final readingResponse = ReadingContentObject.fromMap(microcontrollerResponse.content);

      conferenceNotifier.addNewReading(readingResponse);
    });

    ref.onDispose(() => _sub?.cancel());
  }
}
