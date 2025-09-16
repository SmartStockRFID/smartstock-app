class Event {
  final String type;
  final String description;
  final DateTime occurredAt;
  final int id;

  Event({
    required this.type,
    required this.description,
    required this.occurredAt,
    required this.id,
  });
}
