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
    r'4d31192d7c5042b076c92a5d8b9eff2dc1a65af2';

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
