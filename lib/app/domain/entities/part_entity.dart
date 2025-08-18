class CarPart {
  int id;
  String name;
  String oemCode;
  String description;
  String location;
  int quantity;
  double costPrice;
  double sellingPrice;
  String carModel;
  String carYear;
  String? rfidUid;

  CarPart({
    required this.id,
    required this.name,
    required this.oemCode,
    required this.description,
    required this.location,
    required this.quantity,
    required this.costPrice,
    required this.sellingPrice,
    required this.carModel,
    required this.carYear,
    this.rfidUid,
  });
}
