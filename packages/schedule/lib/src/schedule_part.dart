import 'package:meta/meta.dart';
import 'package:schedule/schedule.dart';

@immutable
abstract class SchedulePart {
  const SchedulePart({required this.dates, required this.type});

  final String type;

  final List<DateTime> dates;

  Map<String, dynamic> toJson();

  static SchedulePart fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case LessonSchedulePart.identifier:
        return LessonSchedulePart.fromJson(json);
      case HolidaySchedulePart.identifier:
        return HolidaySchedulePart.fromJson(json);
      case CalendarSchedulePart.identifier:
      case 'event':
      case 'exam':
      case 'deadline':
      case 'note':
      case 'custom':
        return CalendarSchedulePart.fromJson(json);
    }
    return const UnknownSchedulePart();
  }
}
