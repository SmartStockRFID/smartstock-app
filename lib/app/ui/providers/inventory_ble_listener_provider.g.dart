// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_ble_listener_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InventoryBleListener)
const inventoryBleListenerProvider = InventoryBleListenerProvider._();

final class InventoryBleListenerProvider
    extends $NotifierProvider<InventoryBleListener, void> {
  const InventoryBleListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryBleListenerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryBleListenerHash();

  @$internal
  @override
  InventoryBleListener create() => InventoryBleListener();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$inventoryBleListenerHash() =>
    r'0decba12c16eb886e5de9689527091cdb0da0276';

abstract class _$InventoryBleListener extends $Notifier<void> {
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
