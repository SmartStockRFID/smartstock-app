import 'package:smart_stock/app/domain/entities/event_entity.dart';
import 'package:smart_stock/app/domain/entities/reading_entity.dart';

class Conference {
  final String employeeUsername;
  final int id;
  final String status;
  final List<Reading> readings;
  final List<Event> events;

  Conference({
    required this.employeeUsername,
    required this.id,
    required this.status,
    required this.readings,
    required this.events,
  });
}
