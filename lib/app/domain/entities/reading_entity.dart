class Reading {
  final String productCode;
  final int id;
  final DateTime lastReading;
  final int quantity;

  Reading({
    required this.productCode,
    required this.id,
    required this.lastReading,
    required this.quantity,
  });
}
