class ConferenceMinimalDTO {
  final int id;
  final String employeeUsername;
  final String status;

  ConferenceMinimalDTO({required this.id, required this.employeeUsername, required this.status});

  factory ConferenceMinimalDTO.fromJson(Map<String, dynamic> json) {
    return ConferenceMinimalDTO(
      id: json['id'],
      employeeUsername: json['username_funcionario'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username_funcionario': employeeUsername, 'status': status};
  }

  static List<ConferenceMinimalDTO> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((jsonItem) {
      if (jsonItem is Map<String, dynamic>) {
        return ConferenceMinimalDTO.fromJson(jsonItem);
      } else {
        throw FormatException('Item inválido na lista de conferências: $jsonItem');
      }
    }).toList();
  }
}
