import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:schedule/schedule.dart';

/// {@template schedule_part}
/// A reusable news block which represents a content-based component.
/// {@endtemplate}
@immutable
@JsonSerializable()
abstract class SchedulePart {
  /// {@macro schedule_part}
  const SchedulePart({required this.dates, required this.type});

  /// The block type key used to identify the type of schedule part.
  final String type;

  /// The dates when the schedule part is active. This is used for displaying
  /// the schedule part only on specific dates in the calendar.
  final List<DateTime> dates;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson();

  /// Deserialize [json] into a [SchedulePart] instance.
  /// Returns [UnknownSchedulePart] when the [json] is not a recognized type.
  static SchedulePart fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case LessonSchedulePart.identifier:
        return LessonSchedulePart.fromJson(json);
      case HolidaySchedulePart.identifier:
        return HolidaySchedulePart.fromJson(json);
    }
    return const UnknownSchedulePart();
  }
}
