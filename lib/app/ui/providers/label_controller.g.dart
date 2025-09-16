// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LabelController)
const labelControllerProvider = LabelControllerProvider._();

final class LabelControllerProvider
    extends $NotifierProvider<LabelController, AsyncValue<void>> {
  const LabelControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'labelControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$labelControllerHash();

  @$internal
  @override
  LabelController create() => LabelController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$labelControllerHash() => r'109206b7c3681b090016e072a2e355eed9ab83a6';

abstract class _$LabelController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
