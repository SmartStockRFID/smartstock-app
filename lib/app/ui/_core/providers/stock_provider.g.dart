// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stock)
const stockProvider = StockProvider._();

final class StockProvider extends $AsyncNotifierProvider<Stock, List<CarPart>> {
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

String _$stockHash() => r'c3fe44f3b8b1ccb8f099c5df925387a42288230f';

abstract class _$Stock extends $AsyncNotifier<List<CarPart>> {
  FutureOr<List<CarPart>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<CarPart>>, List<CarPart>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CarPart>>, List<CarPart>>,
              AsyncValue<List<CarPart>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
