import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/shared/types.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

part 'inventory_provider.g.dart';

@immutable
class ReadTag {
  final String tagUid;
  final DateTime readTimestamp;

  const ReadTag({required this.tagUid, required this.readTimestamp});
}

@immutable
class ProductReadings {
  final List<ReadTag> readTags;
  final String productOEM;

  const ProductReadings({required this.readTags, required this.productOEM});

  int get tagCount => readTags.length;

  bool hasTag(String tagUid) => readTags.any((readTag) => readTag.tagUid == tagUid);

  ProductReadings copyWith({List<ReadTag>? readTags, String? productOEM}) {
    return ProductReadings(
      readTags: readTags ?? this.readTags,
      productOEM: productOEM ?? this.productOEM,
    );
  }
}

@immutable
class InventoryManagerState {
  final List<ProductReadings> readings;
  final ProductReadings? lastAddedProductReading;
  final String? employeeUsername;
  final int? id;
  final bool isPaused;
  final bool hasEnded;
  final RequestStatus initReqStatus;
  final RequestStatus finishReqStatus;
  final RequestStatus cancelReqStatus;

  const InventoryManagerState({
    this.id,
    this.readings = const [],
    this.employeeUsername,
    this.isPaused = false,
    this.hasEnded = false,
    this.initReqStatus = RequestStatus.idle,
    this.finishReqStatus = RequestStatus.idle,
    this.cancelReqStatus = RequestStatus.idle,
    this.lastAddedProductReading,
  });

  bool get hasReqPending => [
    initReqStatus,
    finishReqStatus,
    cancelReqStatus,
  ].any((status) => status == RequestStatus.loading);

  String get initButtonLabel {
    return switch (initReqStatus) {
      RequestStatus.loading => 'INICIANDO...',
      RequestStatus.success => 'ENTRAR',
      _ => 'INICIAR INVENTÁRIO',
    };
  }

  int get readingsCount => readings.fold(0, (acc, r) => acc + r.tagCount);

  InventoryManagerState copyWith({
    List<ProductReadings>? readings,
    String? employeeUsername,
    int? id,
    RequestStatus? initReqStatus,
    RequestStatus? finishReqStatus,
    RequestStatus? cancelReqStatus,
    bool? isPaused,
    bool? hasEnded,
    ProductReadings? lastAddedProductReading,
  }) {
    return InventoryManagerState(
      readings: readings ?? this.readings,
      employeeUsername: employeeUsername ?? this.employeeUsername,
      id: id ?? this.id,
      initReqStatus: initReqStatus ?? this.initReqStatus,
      finishReqStatus: finishReqStatus ?? this.finishReqStatus,
      cancelReqStatus: cancelReqStatus ?? this.cancelReqStatus,
      isPaused: isPaused ?? this.isPaused,
      hasEnded: hasEnded ?? this.hasEnded,
      lastAddedProductReading: lastAddedProductReading ?? this.lastAddedProductReading,
    );
  }
}

@riverpod
class InventoryManager extends _$InventoryManager {
  final _audioPlayer = AudioPlayer();

  @override
  InventoryManagerState build() {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    return const InventoryManagerState();
  }

  void resetState() {
    logger.d('resetState called!');
    state = const InventoryManagerState();
  }

  Future<void> startInventoryFlow() async {
    await Future.wait([initInventory(), ref.read(bleConnectionProvider).manager.enterOnReadMode()]);
  }

  Future<void> initInventory() async {
    state = state.copyWith(initReqStatus: RequestStatus.loading);
    try {
      final hasActiveConf = await _getActiveReading();
      if (!hasActiveConf) {
        final inventoryDetails = await injector.get<InventoryRepository>().initInventory(
          state.employeeUsername ?? 'admin',
        );
        state = state.copyWith(
          id: inventoryDetails.id,
          employeeUsername: inventoryDetails.employeeUsername,
          initReqStatus: RequestStatus.success,
        );
      } else {
        // Já tô atualizando dentro do get
        // state = state.copyWith(initReqStatus: RequestStatus.success);
      }
    } catch (error) {
      logger.e(error);
      state = state.copyWith(initReqStatus: RequestStatus.error);
    }
  }

  // Como que eu pego esse retorno para eu conseguir controlar na tela de interface se eu exibo Retomar ou Iniciar?
  Future<bool> _getActiveReading() async {
    final inventories = await injector.get<InventoryRepository>().getAllInventories();
    final activeConfIndex = inventories.indexWhere((conf) => conf.status == 'iniciada');
    if (activeConfIndex != -1) {
      final inventoryDetails = inventories[activeConfIndex];
      state = state.copyWith(
        id: inventoryDetails.id,
        employeeUsername: inventoryDetails.employeeUsername,
        initReqStatus: RequestStatus.success,
      );
      return true;
    }
    return false;
  }

  Future<void> finishInventory() async {
    if (state.id != null) {
      state = state.copyWith(finishReqStatus: RequestStatus.loading);
      try {
        try {
          await injector.get<InventoryRepository>().postReadings(state.id!, state.readings);
        } catch (err) {
          logger.e('Erro ao buscar produtos da conferência!');
        }
        await injector.get<InventoryRepository>().finishInventory(state.id!);
        state = state.copyWith(
          finishReqStatus: RequestStatus.success,
          initReqStatus: RequestStatus.idle,
          hasEnded: true,
          isPaused: false,
        );
      } catch (error) {
        logger.e('Error on finishInventory $error');
        state = state.copyWith(finishReqStatus: RequestStatus.error);
      }
    }
  }

  Future<void> cancelInventory() async {
    if (state.id != null) {
      state = state.copyWith(cancelReqStatus: RequestStatus.loading);
      try {
        await injector.get<InventoryRepository>().cancelInventory(state.id!);
      } catch (error) {
        logger.e('Error calling cancelInventory on inventoryManager: $error');
        state = state.copyWith(cancelReqStatus: RequestStatus.error);
      }
      state = state.copyWith(
        cancelReqStatus: RequestStatus.success,
        initReqStatus: RequestStatus.idle,
        hasEnded: true,
        isPaused: false,
      );
    }
  }

  void addNewReading(ReadingResponseContent reading) {
    if (state.isPaused || !reading.ok) {
      return;
    }

    final readTimestamp = DateTime.now();
    final currentReadings = List<ProductReadings>.from(state.readings);
    bool wasNewTagAdded = false;

    final productIndex = currentReadings.indexWhere(
      (product) => product.productOEM == reading.productOEM,
    );

    ProductReadings? newProduct;

    if (productIndex == -1) {
      wasNewTagAdded = true;
      newProduct = ProductReadings(
        readTags: [ReadTag(tagUid: reading.tagUid!, readTimestamp: readTimestamp)],
        productOEM: reading.productOEM!,
      );
      currentReadings.add(newProduct);
    } else {
      final existingProduct = currentReadings[productIndex];
      if (!existingProduct.hasTag(reading.tagUid!)) {
        wasNewTagAdded = true;
        newProduct = existingProduct.copyWith(
          readTags: [
            ...existingProduct.readTags,
            ReadTag(tagUid: reading.tagUid!, readTimestamp: readTimestamp),
          ],
        );
        currentReadings[productIndex] = newProduct;
      }
    }

    if (wasNewTagAdded) {
      _audioPlayer.play(AssetSource(Assets.scannerBeep));
      Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);
      state = state.copyWith(readings: currentReadings, lastAddedProductReading: newProduct);
    }
  }

  void resumeInventory() {
    logger.d('Inventário retomado!');
    state = state.copyWith(isPaused: false);
  }

  void pauseInventory() {
    logger.d('Inventário pausado!');
    state = state.copyWith(isPaused: true);
  }
}
