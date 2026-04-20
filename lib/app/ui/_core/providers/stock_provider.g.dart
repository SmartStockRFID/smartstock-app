// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stock)
const stockProvider = StockProvider._();

final class StockProvider extends $AsyncNotifierProvider<Stock, List<Product>> {
  const StockProvider._()
    : super(
        from: null,
        argument: null,
        retry: customRetry,
        name: r'stockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockHash();

  @$internal
  @override
  Stock create() => Stock();
}

String _$stockHash() => r'21beb59166ff7bdcfbe32c6cff9c1ad321eaede6';

abstract class _$Stock extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
