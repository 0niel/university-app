import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/src/dates_converter.dart';
import 'package:schedule/src/schedule_part.dart';

part 'unknown_schedule_part.freezed.dart';
part 'unknown_schedule_part.g.dart';

/// A safe fallback for an unsupported schedule part.
@freezed
abstract class UnknownSchedulePart
    with _$UnknownSchedulePart
    implements SchedulePart {
  /// Creates an unknown schedule part.
  const factory UnknownSchedulePart({
    @DatesConverter() @Default(<DateTime>[]) List<DateTime> dates,
    @Default(UnknownSchedulePart.identifier) String type,
  }) = _UnknownSchedulePart;

  /// Deserializes an unknown schedule part from [json].
  factory UnknownSchedulePart.fromJson(Map<String, dynamic> json) =>
      _$UnknownSchedulePartFromJson(json);

  /// The serialized discriminator for an unknown schedule part.
  static const identifier = '__unknown__';
}
