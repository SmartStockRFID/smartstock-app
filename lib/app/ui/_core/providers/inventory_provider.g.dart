// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryManagerState _$InventoryManagerStateFromJson(
  Map<String, dynamic> json,
) => InventoryManagerState(
  currentInventory: json['currentInventory'] == null
      ? null
      : InventorySummary.fromJson(
          json['currentInventory'] as Map<String, dynamic>,
        ),
  readings:
      (json['readings'] as List<dynamic>?)
          ?.map((e) => ProductReadings.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isPaused: json['isPaused'] as bool? ?? false,
  lastAddedProductReading: json['lastAddedProductReading'] == null
      ? null
      : ProductReadings.fromJson(
          json['lastAddedProductReading'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$InventoryManagerStateToJson(
  InventoryManagerState instance,
) => <String, dynamic>{
  'currentInventory': instance.currentInventory,
  'readings': instance.readings,
  'lastAddedProductReading': instance.lastAddedProductReading,
  'isPaused': instance.isPaused,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InventoryManager)
@JsonPersist()
const inventoryManagerProvider = InventoryManagerProvider._();

@JsonPersist()
final class InventoryManagerProvider
    extends $NotifierProvider<InventoryManager, InventoryManagerState> {
  const InventoryManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryManagerProvider',
        isAutoDispose: false,
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

String _$inventoryManagerHash() => r'3430a96797f852783cf29e83bbb4c6440e38173b';

@JsonPersist()
abstract class _$InventoryManagerBase extends $Notifier<InventoryManagerState> {
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

// **************************************************************************
// JsonGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
abstract class _$InventoryManager extends _$InventoryManagerBase {
  /// The default key used by [persist].
  String get key {
    const resolvedKey = "InventoryManager";
    return resolvedKey;
  }

  /// A variant of [persist], for JSON-specific encoding.
  ///
  /// You can override [key] to customize the key used for storage.
  PersistResult persist(
    FutureOr<Storage<String, String>> storage, {
    String? key,
    String Function(InventoryManagerState state)? encode,
    InventoryManagerState Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    return NotifierPersistX(this).persist<String, String>(
      storage,
      key: key ?? this.key,
      encode: encode ?? $jsonCodex.encode,
      decode:
          decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return InventoryManagerState.fromJson(e as Map<String, Object?>);
          },
      options: options,
    );
  }
}
