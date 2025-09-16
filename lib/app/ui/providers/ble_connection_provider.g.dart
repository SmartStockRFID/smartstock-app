// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BleConnection)
const bleConnectionProvider = BleConnectionProvider._();

final class BleConnectionProvider
    extends $NotifierProvider<BleConnection, BleConnectionState> {
  const BleConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bleConnectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bleConnectionHash();

  @$internal
  @override
  BleConnection create() => BleConnection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BleConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BleConnectionState>(value),
    );
  }
}

String _$bleConnectionHash() => r'd8dc59aa8b1f5a6d5090cbdb7e26122a3c5a13cc';

abstract class _$BleConnection extends $Notifier<BleConnectionState> {
  BleConnectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BleConnectionState, BleConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BleConnectionState, BleConnectionState>,
              BleConnectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
