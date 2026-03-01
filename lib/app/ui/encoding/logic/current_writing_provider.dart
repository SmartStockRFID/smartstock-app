import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/ui/encoding/logic/encoding_history_saver.dart';
import 'package:smart_stock/app/ui/encoding/setup/encoding_setup_page.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

part 'current_writing_provider.g.dart';

@riverpod
class WritingManager extends _$WritingManager {
  final _audioPlayer = AudioPlayer();

  Future<void> addNewWritedTag(String uid, String? writedProductOEM) async {
    if (!state.writedTags.contains(uid)) {
      _audioPlayer.play(AssetSource(Assets.scannerBeep));
      Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

      state = state.copyWith(writedTags: [...state.writedTags, uid], lastWritingAt: DateTime.now());
      await updateOrInsertRegister(productCode: writedProductOEM);
    }
  }

  @override
  WritingManagerState build() {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    return const WritingManagerState();
  }

  void changeProductBeingWrited(String newProductOEM) {
    state = WritingManagerState(mode: WritingMode.PRODUCT_CODE, currentProductOEM: newProductOEM);
  }

  void changeToResetMode() {
    state = const WritingManagerState(mode: WritingMode.RESET, currentProductOEM: null);
  }
}

@immutable
class WritingManagerState {
  final WritingMode mode;
  final String? currentProductOEM;
  final DateTime? lastWritingAt;
  final List<String> writedTags;

  const WritingManagerState({
    this.mode = WritingMode.PRODUCT_CODE,
    this.currentProductOEM,
    this.lastWritingAt,
    this.writedTags = const [],
  });

  WritingManagerState copyWith({
    WritingMode? mode,
    String? currentProductOEM,
    DateTime? lastWritingAt,
    List<String>? writedTags,
  }) {
    return WritingManagerState(
      mode: mode ?? this.mode,
      currentProductOEM: currentProductOEM ?? this.currentProductOEM,
      lastWritingAt: lastWritingAt ?? this.lastWritingAt,
      writedTags: writedTags ?? this.writedTags,
    );
  }
}
