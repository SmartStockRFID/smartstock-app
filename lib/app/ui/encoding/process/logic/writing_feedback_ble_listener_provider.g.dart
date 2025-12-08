// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_feedback_ble_listener_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WritingFeedbackBleListener)
const writingFeedbackBleListenerProvider =
    WritingFeedbackBleListenerProvider._();

final class WritingFeedbackBleListenerProvider
    extends $NotifierProvider<WritingFeedbackBleListener, void> {
  const WritingFeedbackBleListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writingFeedbackBleListenerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writingFeedbackBleListenerHash();

  @$internal
  @override
  WritingFeedbackBleListener create() => WritingFeedbackBleListener();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$writingFeedbackBleListenerHash() =>
    r'7f2dcb3bd0cbb23a8a1b7df9fb832daa8e98765c';

abstract class _$WritingFeedbackBleListener extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
