// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_ble_listener_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConferenceBleListener)
const conferenceBleListenerProvider = ConferenceBleListenerProvider._();

final class ConferenceBleListenerProvider
    extends $NotifierProvider<ConferenceBleListener, void> {
  const ConferenceBleListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conferenceBleListenerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conferenceBleListenerHash();

  @$internal
  @override
  ConferenceBleListener create() => ConferenceBleListener();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$conferenceBleListenerHash() =>
    r'00b8805955b0682f574807511fbfb14757d41da5';

abstract class _$ConferenceBleListener extends $Notifier<void> {
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
