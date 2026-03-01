import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/constants.dart';
import 'package:smart_stock/app/domain/firmware/firmware_api_response.dart';
import 'package:smart_stock/app/domain/firmware/write_response.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/encoding/logic/current_writing_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';

part 'writing_feedback_ble_listener_provider.g.dart';

@Riverpod()
class WritingFeedbackBleListener extends _$WritingFeedbackBleListener {
  StreamSubscription? _sub;

  @override
  void build() {
    final bleManager = ref.watch(
      bleConnectionProvider.select((state) => state.currentState.manager),
    );

    final currentWriting = ref.read(writingManagerProvider.notifier);

    _sub = bleManager.rfidDataStream.listen((read) async {
      try {
        final microcontrollerResponse = FirmwareResponse.fromJson(read);

        if (microcontrollerResponse.type != FRTypes.writeResult) {
          return;
        }

        final result = WriteResponseContent.fromMap(microcontrollerResponse.content);

        if (result.ok && result.tagUid != null) {
          await currentWriting.addNewWritedTag(
            result.tagUid!,
            (result.encodedOEM == null || result.encodedOEM == emptyTagOEM)
                ? null
                : result.encodedOEM,
          );
        }
      } catch (err) {
        logger.e(err);
      }
    });

    ref.onDispose(() => _sub?.cancel());
  }
}
