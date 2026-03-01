import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/assets.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/config/exceptions.dart';
import 'package:smart_stock/app/config/preferences_manager.dart';
import 'package:smart_stock/app/data/repositories/inventory_repository.dart';
import 'package:smart_stock/app/domain/entities/inventory_entity.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/providers/storage_provider.dart';
import 'package:smart_stock/app/utils/internet.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

part 'inventory_provider.g.dart';

@Riverpod(keepAlive: true)
@JsonPersist()
class InventoryManager extends _$InventoryManager {
  final _audioPlayer = AudioPlayer();

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

  @override
  InventoryManagerState build() {
    persist(
      ref.watch(storageProvider.future),
      options: const StorageOptions(cacheTime: StorageCacheTime(Duration(days: 7))),
    );
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    return const InventoryManagerState();
  }

  Future<void> initOfflineInventory() async {
    final currentUser = await CurrentUserStorage.getValue();
    if (currentUser == null) {
      return;
    }

    final newInventory = InventorySummary(
      id: null,
      employeeUsername: currentUser,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(currentInventory: newInventory);
  }

  Future<void> initOnlineInventory() async {
    final newInventory = await injector.get<InventoryRepository>().initInventory();
    state = state.copyWith(currentInventory: newInventory);
  }

  void pauseInventory() {
    logger.d('Inventário pausado!');
    state = state.copyWith(isPaused: true);
  }

  void resetState() {
    logger.i('resetState called!');
    state = const InventoryManagerState();
  }

  void resumeInventory() {
    logger.d('Inventário retomado!');
    state = state.copyWith(isPaused: false);
  }

  void setInventoryFromServer(InventorySummary inventory) {
    state = state.copyWith(currentInventory: inventory);
  }

  Future<void> startInventoryFlow({required bool offline}) async {
    final Future<void> Function() initInventory = offline
        ? initOfflineInventory
        : initOnlineInventory;

    await Future.wait([
      initInventory(),
      ref.read(bleConnectionProvider).currentState.manager.enterOnReadMode(),
    ]);
  }

  Future<void> syncInventory() async {
    await checkIfHasInternet();
    InventorySummary targetInventory;

    if (state.currentInventory?.id != null) {
      targetInventory = state.currentInventory!;
    } else {
      final inventoryRepo = injector.get<InventoryRepository>();
      targetInventory =
          await inventoryRepo.getActiveInventory() ?? await inventoryRepo.initInventory();
      if (targetInventory.id == null) {
        throw const InternalSystemException("This shoudln't be reached");
      }
    }

    final notSyncedReadings = [...state.readings];

    for (int i = 0; i < notSyncedReadings.length; i++) {
      final readings = notSyncedReadings[i].readTags
          .where((tag) => !state.syncedTags.contains(tag.tagUid))
          .toList();
      notSyncedReadings[i] = notSyncedReadings[i].copyWith(readTags: readings);
    }

    await injector.get<InventoryRepository>().postReadings(targetInventory.id!, notSyncedReadings);
    state = state.copyWith(lastSyncedAt: DateTime.now());
  }
}

@JsonSerializable()
@immutable
class InventoryManagerState {
  final InventorySummary? currentInventory;
  final List<ProductReadings> readings;
  final ProductReadings? lastAddedProductReading;
  final bool isPaused;
  final List<String> syncedTags;
  final DateTime? lastSyncedAt;

  const InventoryManagerState({
    this.currentInventory,
    this.readings = const [],
    this.isPaused = false,
    this.syncedTags = const [],
    this.lastAddedProductReading,
    this.lastSyncedAt,
  });

  factory InventoryManagerState.fromJson(Map<String, dynamic> json) =>
      _$InventoryManagerStateFromJson(json);

  int get readingsCount => readings.fold(0, (acc, r) => acc + r.tagCount);

  InventoryManagerState copyWith({
    InventorySummary? currentInventory,
    List<ProductReadings>? readings,
    bool? isPaused,
    ProductReadings? lastAddedProductReading,
    List<String>? syncedTags,
    DateTime? lastSyncedAt,
  }) {
    return InventoryManagerState(
      currentInventory: currentInventory ?? this.currentInventory,
      readings: readings ?? this.readings,
      isPaused: isPaused ?? this.isPaused,
      lastAddedProductReading: lastAddedProductReading ?? this.lastAddedProductReading,
      syncedTags: syncedTags ?? this.syncedTags,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  Map<String, dynamic> toJson() => _$InventoryManagerStateToJson(this);
}
