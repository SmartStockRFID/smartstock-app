import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_writing_provider.g.dart';

@immutable
class WritingManagerState {
  final String? currentProductOEM;
  final DateTime? lastWritingAt;
  final int writedTagsCount;

  const WritingManagerState({this.currentProductOEM, this.lastWritingAt, this.writedTagsCount = 0});

  WritingManagerState copyWith({
    String? currentProductOEM,
    DateTime? lastWritingAt,
    int? writedTagsCount,
  }) {
    return WritingManagerState(
      currentProductOEM: currentProductOEM ?? this.currentProductOEM,
      lastWritingAt: lastWritingAt ?? this.lastWritingAt,
      writedTagsCount: writedTagsCount ?? this.writedTagsCount,
    );
  }
}

@riverpod
class WritingManager extends _$WritingManager {
  @override
  WritingManagerState build() {
    return const WritingManagerState();
  }

  void changeProductBeingWrited(String newProductOEM) {
    state = state.copyWith(currentProductOEM: newProductOEM, writedTagsCount: 0);
  }

  void incrementWritedTagsCount() {
    state = state.copyWith(
      writedTagsCount: state.writedTagsCount + 1,
      lastWritingAt: DateTime.now(),
    );
  }
}
