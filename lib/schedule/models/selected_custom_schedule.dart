import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class SelectedCustomSchedule extends SelectedSchedule {
  const SelectedCustomSchedule({required this.id, required this.name, this.description, required super.schedule})
    : super(type: 'custom');

  final String id;
  @override
  final String name;
  final String? description;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'custom',
      'id': id,
      'name': name,
      'description': description,
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }

  static SelectedCustomSchedule fromJson(Map<String, dynamic> json) {
    final List<dynamic> scheduleJson = json['schedule'] as List<dynamic>;
    final List<SchedulePart> schedule =
        scheduleJson.map((e) => SchedulePart.fromJson(e as Map<String, dynamic>)).toList();

    return SelectedCustomSchedule(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      schedule: schedule,
    );
  }

  @override
  List<Object?> get props => [id, name, description, schedule];
}
