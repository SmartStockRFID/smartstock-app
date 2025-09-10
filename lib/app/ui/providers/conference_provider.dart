import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:smart_stock/app/domain/objects/reading_object.dart';

part 'conference_provider.g.dart';

@immutable
class ProductReadings {
  final List<String> readTags;
  final String productOEM;

  const ProductReadings({required this.readTags, required this.productOEM});

  int get tagCount => readTags.length;

  bool hasTag(String tagUid) => readTags.contains(tagUid);

  ProductReadings copyWith({List<String>? readTags, String? productOEM}) {
    return ProductReadings(
      readTags: readTags ?? this.readTags,
      productOEM: productOEM ?? this.productOEM,
    );
  }
}
@immutablereadingsCount

class ConferenceManagerState {
  final List<ProductReadings> readings;
  final String workerUsername;

  const ConferenceManagerState({this.readings = const [], this.workerUsername = 'Ryan'});

  int get readingsCount => readings.fold(0, (acc, r) => acc + r.tagCount);

  ConferenceManagerState copyWith({
    int? readingsCount,
    List<ProductReadings>? readings,
    String? workerUsername,
  }) {
    return ConferenceManagerState(
      readings: readings ?? this.readings,
      workerUsername: workerUsername ?? this.workerUsername,
    );
  }
}

@riverpod
class ConferenceManager extends _$ConferenceManager {
  @override
  ConferenceManagerState build() {
    return const ConferenceManagerState();
  }

  void addNewReading(ReadingContentObject reading) {
    final currentReadings = [...state.readings];

    final productIndex = currentReadings.indexWhere(
      (product) => product.productOEM == reading.productOEM,
    );

    if (productIndex == -1) {
      currentReadings.add(
        ProductReadings(readTags: [reading.tagUid], productOEM: reading.productOEM),
      );
    } else {
      final existingProduct = currentReadings[productIndex];

      if (!existingProduct.hasTag(reading.tagUid)) {
        currentReadings[productIndex] = existingProduct.copyWith(
          readTags: [...existingProduct.readTags, reading.tagUid],
        );
      }
    }

    state = state.copyWith(readings: [...currentReadings]);
  }
}
