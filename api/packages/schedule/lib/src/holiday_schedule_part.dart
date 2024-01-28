import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/src/dates_converter.dart';
import 'package:schedule/src/schedule_part.dart';

part 'holiday_schedule_part.g.dart';

/// {@template unknown_block}
/// Part of a schedule which represents a holiday.
/// {@endtemplate}
@JsonSerializable()
class HolidaySchedulePart with EquatableMixin implements SchedulePart {
  /// {@macro unknown_block}
  const HolidaySchedulePart({
    required this.title,
    required this.dates,
    this.type = HolidaySchedulePart.identifier,
  });

  /// Converts a `Map<String, dynamic>` into a [HolidaySchedulePart] instance.
  factory HolidaySchedulePart.fromJson(Map<String, dynamic> json) => _$HolidaySchedulePartFromJson(json);

  /// The unknown schedule part type identifier.
  static const identifier = '__holiday__';

  /// The title of the holiday.
  final String title;

  @override
  final String type;

  @override
  @DatesConverter()
  final List<DateTime> dates;

  @override
  Map<String, dynamic> toJson() => _$HolidaySchedulePartToJson(this);

  @override
  List<Object> get props => [type, dates, title];
}
