import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/domain/firmware/feedback_response.dart';
import 'package:smart_stock/app/domain/firmware/firmware_api_response.dart';
import 'package:smart_stock/app/ui/providers/current_writing_provider.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

import 'ble_connection_provider.dart';

part 'writing_feedback_ble_listener_provider.g.dart';

@Riverpod()
class WritingFeedbackBleListener extends _$WritingFeedbackBleListener {
  StreamSubscription? _sub;
  final _audioPlayer = AudioPlayer();

  @override
  void build() {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    final ble = ref.watch(bleConnectionProvider);

    final currentWriting = ref.read(writingManagerProvider.notifier);

    _sub = ble.manager.rfidDataStream.listen((read) {
      logger.d('Write feedback recebido!');

      final microcontrollerResponse = FirmwareResponse.fromJson(read);

      if (microcontrollerResponse.type != FRTypes.feedback) {
        return;
      }

      final feedback = FeedbackResponseContent.fromMap(microcontrollerResponse.content);

      const writeSuccessFeedback = 'Write successful:';

      if (feedback.status == 'ok' && feedback.message.startsWith(writeSuccessFeedback)) {
        _audioPlayer.play(AssetSource(Assets.scannerBeep));
        Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

        currentWriting.incrementWritedTagsCount();
      }
    });

    ref.onDispose(() => _sub?.cancel());
  }
}
