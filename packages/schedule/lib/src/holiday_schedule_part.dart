import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/src/dates_converter.dart';
import 'package:schedule/src/schedule_part.dart';

part 'holiday_schedule_part.freezed.dart';
part 'holiday_schedule_part.g.dart';

/// A holiday in a schedule.
@freezed
abstract class HolidaySchedulePart
    with _$HolidaySchedulePart
    implements SchedulePart {
  /// Creates a holiday schedule part.
  const factory HolidaySchedulePart({
    required String title,
    @DatesConverter() required List<DateTime> dates,
    @Default(HolidaySchedulePart.identifier) String type,
  }) = _HolidaySchedulePart;

  /// Deserializes a holiday schedule part from [json].
  factory HolidaySchedulePart.fromJson(Map<String, dynamic> json) =>
      _$HolidaySchedulePartFromJson(json);

  /// The serialized discriminator for a holiday.
  static const identifier = '__holiday__';
}
