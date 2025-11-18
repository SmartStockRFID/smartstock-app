// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConferenceManager)
const conferenceManagerProvider = ConferenceManagerProvider._();

final class ConferenceManagerProvider
    extends $NotifierProvider<ConferenceManager, InventoryManagerState> {
  const ConferenceManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conferenceManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conferenceManagerHash();

  @$internal
  @override
  ConferenceManager create() => ConferenceManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryManagerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryManagerState>(value),
    );
  }
}

String _$conferenceManagerHash() => r'2ecf12cace1490cfc27a351b7e5f507d03ccceb6';

abstract class _$ConferenceManager extends $Notifier<InventoryManagerState> {
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
