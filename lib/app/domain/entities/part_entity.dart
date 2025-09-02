class CarPart {
  int id;
  String name;
  String productCode;
  String description;
  String location;
  int quantity = 0;

  CarPart({
    required this.id,
    required this.name,
    required this.productCode,
    required this.description,
    required this.location,
    // required this.quantity,
  });
}
