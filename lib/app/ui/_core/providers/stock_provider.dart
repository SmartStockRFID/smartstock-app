import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/data/repositories/product_repository.dart';
import 'package:smart_stock/app/domain/entities/product_entity.dart';
import 'package:smart_stock/app/ui/_core/providers/stock_cache.dart';
import 'package:smart_stock/app/utils/internet.dart';
import 'package:smart_stock/app/utils/logger.dart';

part 'stock_provider.g.dart';

Duration? customRetry(int retryCount, Object error) {
  if (retryCount >= 3) {
    return null;
  }
  if (error is OfflineException) {
    return null;
  }

  return Duration(milliseconds: 200 * (1 << retryCount));
}

@Riverpod(keepAlive: true, retry: customRetry)
class Stock extends _$Stock {
  StreamSubscription<InternetStatus>? _stateSubscription;

  DateTime? updatedAt;

  @override
  Future<List<Product>> build() async {
    final cached = await getStockCache();

    _listenToConnectionChanges();

    if (cached != null) {
      _updateOnBackground();

      updatedAt = cached.savedAt;
      return cached.products;
    }

    return _loadFromServer();
  }

  Future<bool> refresh() async {
    if (await appIsOffline()) {
      return false;
    }

    state = const AsyncLoading();
    try {
      final products = await _loadFromServer();

      state = AsyncData(products);
    } catch (err, trace) {
      logger.e(err, stackTrace: trace);
      if (state.hasValue) {
        state = AsyncData(state.value!);
      } else {
        state = AsyncError(err, trace);
      }
      return false;
    }

    return true;
  }

  void _listenToConnectionChanges() {
    _stateSubscription?.cancel();
    _stateSubscription = InternetConnection().onStatusChange.listen((status) async {
      if (status == InternetStatus.connected) {
        try {
          final newData = await _loadFromServer();
          state = AsyncData(newData);
        } catch (e) {
          logger.e(e);
        }
      }
    });

    ref.onDispose(() => _stateSubscription?.cancel());
  }

  Future<List<Product>> _loadFromServer() async {
    final repo = injector<ProductRepository>();
    final products = await repo.getAllProducts();

    final now = DateTime.now();
    updatedAt = now;
    await writeStockCache(StockCache(products: products, savedAt: now));

    return products;
  }

  Future<void> _updateOnBackground() async {
    try {
      await _loadFromServer();
    } catch (err) {
      logger.e(err);
    }
  }
}
