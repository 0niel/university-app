import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_birthday.freezed.dart';
part 'group_birthday.g.dart';

@freezed
abstract class GroupBirthday with _$GroupBirthday {
  const factory GroupBirthday({
    @JsonKey(defaultValue: '') required String name,
    @JsonKey(
      fromJson: requiredDateTimeFromJson,
      toJson: requiredDateTimeToJson,
    )
    required DateTime date,
    @Default(false) bool isMe,
  }) = _GroupBirthday;

  const GroupBirthday._();

  factory GroupBirthday.fromJson(Map<String, Object?> json) =>
      _$GroupBirthdayFromJson(json);

  int get daysLeft {
    final now = DateTime.now();
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}
