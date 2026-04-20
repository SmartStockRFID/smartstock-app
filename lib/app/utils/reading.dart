import 'package:smart_stock/app/domain/interfaces/inventory_interfaces.dart';

int getProductReadingsTagsCount(List<ProductReadings> readings) =>
    readings.fold(0, (acc, r) => acc + r.tagCount);
