class InventorySummaryDTO {
  final int id;
  final String employeeUsername;
  final String status;
  final DateTime createdAt;

  InventorySummaryDTO({
    required this.id,
    required this.employeeUsername,
    required this.status,
    required this.createdAt,
  });

  factory InventorySummaryDTO.fromJson(Map<String, dynamic> json) {
    return InventorySummaryDTO(
      id: json['id'],
      employeeUsername: json['username_funcionario'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static List<InventorySummaryDTO> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((jsonItem) {
      if (jsonItem is Map<String, dynamic>) {
        return InventorySummaryDTO.fromJson(jsonItem);
      } else {
        throw FormatException('Item inválido na lista de inventários: $jsonItem');
      }
    }).toList();
  }
}
