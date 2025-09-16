import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/data/repositories/conference_repository_impl.dart';

import 'package:smart_stock/app/domain/objects/reading_object.dart';
import 'package:smart_stock/app/ui/shared/types.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

part 'conference_provider.g.dart';

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

enum ConferenceState { NOT_STARTED, ACTIVE, PAUSED }

@immutable
class ConferenceManagerState {
  final List<ProductReadings> readings;
  final String? employeeUsername;
  final int? id;
  final ConferenceState state;
  final RequestStatus initReqStatus;
  final RequestStatus finishReqStatus;
  final RequestStatus cancelReqStatus;

  const ConferenceManagerState({
    this.readings = const [],
    this.employeeUsername,
    this.state = ConferenceState.NOT_STARTED,
    this.id,
    this.initReqStatus = RequestStatus.idle,
    this.finishReqStatus = RequestStatus.idle,
    this.cancelReqStatus = RequestStatus.idle,
  });

  int get readingsCount => readings.fold(0, (acc, r) => acc + r.tagCount);

  ConferenceManagerState copyWith({
    List<ProductReadings>? readings,
    String? employeeUsername,
    int? id,
    RequestStatus? initReqStatus,
    RequestStatus? finishReqStatus,
    RequestStatus? cancelReqStatus,
  }) {
    return ConferenceManagerState(
      readings: readings ?? this.readings,
      employeeUsername: employeeUsername ?? this.employeeUsername,
      id: id ?? this.id,
      initReqStatus: initReqStatus ?? this.initReqStatus,
      finishReqStatus: finishReqStatus ?? this.finishReqStatus,
      cancelReqStatus: cancelReqStatus ?? this.cancelReqStatus,
    );
  }
}

@riverpod
class ConferenceManager extends _$ConferenceManager {
  @override
  ConferenceManagerState build() {
    return const ConferenceManagerState();
  }

  void resetState() {
    logger.d('resetState called!');
    state = const ConferenceManagerState();
  }

  Future<void> initConference() async {
    logger.d('initConference called!');
    state = state.copyWith(initReqStatus: RequestStatus.loading);
    try {
      final hasActiveConf = await _getActiveReading();
      if (!hasActiveConf) {
        final confDetails = await ConferenceRepositoryImpl().initConference('Ryan');
        state = state.copyWith(
          id: confDetails.id,
          employeeUsername: confDetails.employeeUsername,
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
    final confs = await ConferenceRepositoryImpl().getAllConferences();
    final activeConfIndex = confs.indexWhere((conf) => conf.status == 'iniciada');
    if (activeConfIndex != -1) {
      final confDetails = confs[activeConfIndex];
      state = state.copyWith(
        id: confDetails.id,
        employeeUsername: confDetails.employeeUsername,
        initReqStatus: RequestStatus.success,
      );
      return true;
    }
    return false;
  }

  Future<void> finishConference() async {
    logger.d('Entrei em finishConference');
    if (state.id != null) {
      state = state.copyWith(finishReqStatus: RequestStatus.loading);
      try {
        logger.d('Calling finishConference...');
        await ConferenceRepositoryImpl().postReadings(state.id!, state.readings);
        await ConferenceRepositoryImpl().finishConference(state.id!);
        logger.d('finishConference successfully ended!');
        state = state.copyWith(finishReqStatus: RequestStatus.success);
        await Future.delayed(const Duration(seconds: 1));
        resetState();
      } catch (error) {
        logger.e('Error on finishConference vei $error');
        state = state.copyWith(finishReqStatus: RequestStatus.error);
      }
    }
  }

  Future<void> cancelConference() async {
    if (state.id != null) {
      state = state.copyWith(cancelReqStatus: RequestStatus.loading);
      try {
        await ConferenceRepositoryImpl().cancelConference(state.id!);
      } catch (error) {
        logger.e('Error calling cancelConference on ConferenceManager: $error');
        state = state.copyWith(cancelReqStatus: RequestStatus.error);
      }
      state = state.copyWith(cancelReqStatus: RequestStatus.success);
      await Future.delayed(const Duration(seconds: 1));
      resetState();
    }
  }

  void addNewReading(ReadingContentObject reading) {
    Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

    final readTimestamp = DateTime.now();
    final currentReadings = List<ProductReadings>.from(state.readings);

    final productIndex = currentReadings.indexWhere(
      (product) => product.productOEM == reading.productOEM,
    );

    if (productIndex == -1) {
      currentReadings.add(
        ProductReadings(
          readTags: [ReadTag(tagUid: reading.tagUid, readTimestamp: readTimestamp)],
          productOEM: reading.productOEM,
        ),
      );
    } else {
      final existingProduct = currentReadings[productIndex];

      if (!existingProduct.hasTag(reading.tagUid)) {
        currentReadings[productIndex] = existingProduct.copyWith(
          readTags: [
            ...existingProduct.readTags,
            ReadTag(tagUid: reading.tagUid, readTimestamp: readTimestamp),
          ],
        );
      }
    }

    state = state.copyWith(readings: currentReadings);
  }
}
