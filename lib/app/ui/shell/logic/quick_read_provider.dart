import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/domain/firmware/firmware_api_response.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';

final quickReadProvider = StreamProvider.autoDispose<ReadingResponseContent>((ref) async* {
  final bleManager = ref.watch(bleConnectionProvider.select((state) => state.currentState.manager));

  await for (final read in bleManager.rfidDataStream) {
    final microcontrollerResponse = FirmwareResponse.fromJson(read);
    if (microcontrollerResponse.type != FRTypes.readResult) {
      continue;
    }

    final readingResponse = ReadingResponseContent.fromMap(microcontrollerResponse.content);
    final hasError =
        !readingResponse.ok || readingResponse.tagUid == null || readingResponse.productOEM == null;

    if (hasError) {
      continue;
    }

    yield readingResponse;
  }
});
