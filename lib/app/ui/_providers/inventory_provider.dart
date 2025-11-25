import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/data/dtos/inventory/inventory_summary_dto.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/ui/_providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_shared/types.dart';
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
  final List<ReadTag> readTags; //Todo: trocar por uma estrutura mais eficiente
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
  final InventorySummaryDTO? currentInventory;
  final List<ProductReadings> readings;
  final ProductReadings? lastAddedProductReading;
  final bool isPaused;
  final bool hasEnded;
  final RequestStatus finishReqStatus;
  final RequestStatus cancelReqStatus;

  const InventoryManagerState({
    this.currentInventory,
    this.readings = const [],
    this.isPaused = false,
    this.hasEnded = false,
    this.finishReqStatus = RequestStatus.idle,
    this.cancelReqStatus = RequestStatus.idle,
    this.lastAddedProductReading,
  });

  bool get hasReqPending =>
      [finishReqStatus, cancelReqStatus].any((status) => status == RequestStatus.loading);

  int get readingsCount => readings.fold(0, (acc, r) => acc + r.tagCount);

  InventoryManagerState copyWith({
    InventorySummaryDTO? currentInventory,
    List<ProductReadings>? readings,
    RequestStatus? finishReqStatus,
    RequestStatus? cancelReqStatus,
    bool? isPaused,
    bool? hasEnded,
    ProductReadings? lastAddedProductReading,
  }) {
    return InventoryManagerState(
      currentInventory: currentInventory ?? this.currentInventory,
      readings: readings ?? this.readings,
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
    final newInventory = await injector.get<InventoryRepository>().initInventory();
    state = state.copyWith(currentInventory: newInventory);
  }

  Future<void> finishInventory() async {
    if (state.currentInventory != null) {
      state = state.copyWith(finishReqStatus: RequestStatus.loading);
      try {
        try {
          await injector.get<InventoryRepository>().postReadings(
            state.currentInventory!.id,
            state.readings,
          );
        } catch (err) {
          logger.e('Erro ao buscar produtos da conferência!');
        }
        await injector.get<InventoryRepository>().finishInventory(state.currentInventory!.id);
        state = state.copyWith(
          finishReqStatus: RequestStatus.success,
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
    if (state.currentInventory == null || state.cancelReqStatus == RequestStatus.loading) {
      return;
    }

    state = state.copyWith(cancelReqStatus: RequestStatus.loading);
    try {
      await injector.get<InventoryRepository>().cancelInventory(state.currentInventory!.id);
    } catch (error) {
      logger.e('Error calling cancelInventory on inventoryManager: $error');
      state = state.copyWith(cancelReqStatus: RequestStatus.error);
    }
    state = state.copyWith(cancelReqStatus: RequestStatus.success, hasEnded: true, isPaused: false);
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

  void setInventoryFromServer(InventorySummaryDTO inventory) {
    state = state.copyWith(currentInventory: inventory);
  }
}
