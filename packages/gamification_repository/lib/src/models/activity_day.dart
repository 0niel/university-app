import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/json_converters.dart';

part 'activity_day.freezed.dart';
part 'activity_day.g.dart';

@freezed
abstract class ActivityDay with _$ActivityDay {
  const factory ActivityDay({
    @JsonKey(fromJson: dateOnlyFromJson) required DateTime day,
    @Default(0) int count,
  }) = _ActivityDay;

  const ActivityDay._();

  factory ActivityDay.fromJson(Map<String, Object?> json) =>
      _$ActivityDayFromJson(json);

  bool get isActive => count > 0;
}
