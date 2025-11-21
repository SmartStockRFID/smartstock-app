import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/domain/firmware/firmware_api_response.dart';
import 'package:smart_stock/app/domain/firmware/write_response.dart';
import 'package:smart_stock/app/ui/providers/current_writing_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

import 'ble_connection_provider.dart';

part 'writing_feedback_ble_listener_provider.g.dart';

@Riverpod()
class WritingFeedbackBleListener extends _$WritingFeedbackBleListener {
  StreamSubscription? _sub;

  @override
  void build() {
    final ble = ref.watch(bleConnectionProvider);

    final currentWriting = ref.read(writingManagerProvider.notifier);

    _sub = ble.manager.rfidDataStream.listen((read) {
      try {
        final microcontrollerResponse = FirmwareResponse.fromJson(read);

        if (microcontrollerResponse.type != FRTypes.writeResult) {
          return;
        }

        final result = WriteResponseContent.fromMap(microcontrollerResponse.content);

        if (result.ok && result.uid != null) {
          currentWriting.addNewWritedTag(result.uid!);
        }
      } catch (err) {
        logger.e(err);
      }
    });

    ref.onDispose(() => _sub?.cancel());
  }
}
