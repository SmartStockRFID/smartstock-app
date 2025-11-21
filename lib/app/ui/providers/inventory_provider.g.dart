// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InventoryManager)
const inventoryManagerProvider = InventoryManagerProvider._();

final class InventoryManagerProvider
    extends $NotifierProvider<InventoryManager, InventoryManagerState> {
  const InventoryManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryManagerHash();

  @$internal
  @override
  InventoryManager create() => InventoryManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryManagerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryManagerState>(value),
    );
  }
}

String _$inventoryManagerHash() => r'96fac1539c1d2b68b2f8c4ddf8d85b48a36bd586';

abstract class _$InventoryManager extends $Notifier<InventoryManagerState> {
  InventoryManagerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<InventoryManagerState, InventoryManagerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InventoryManagerState, InventoryManagerState>,
              InventoryManagerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
