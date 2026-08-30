import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'campus_event.freezed.dart';
part 'campus_event.g.dart';

@freezed
abstract class CampusEvent with _$CampusEvent {
  const factory CampusEvent({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @JsonKey(
      fromJson: requiredDateTimeFromJson,
      toJson: requiredDateTimeToJson,
    )
    required DateTime startsAt,
    @Default('') String description,
    @Default('🎉') String emoji,
    @Default('other') String category,
    @Default('') String place,
    @Default(0) int goingCount,
    @Default(false) bool isGoing,
    @Default(false) bool isMine,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> goingNames,
  }) = _CampusEvent;

  factory CampusEvent.fromJson(Map<String, Object?> json) =>
      _$CampusEventFromJson(json);
}
