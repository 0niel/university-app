// json_serializable factory annotations are validated by generated code.
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

// Public API documentation lives in the package facade.

part 'schedule_target_row.freezed.dart';
part 'schedule_target_row.g.dart';

@freezed
abstract class ScheduleTargetRow with _$ScheduleTargetRow {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ScheduleTargetRow({
    required String externalId,
    required String targetTitle,
    required String fullTitle,
  }) = _ScheduleTargetRow;

  const ScheduleTargetRow._();

  factory ScheduleTargetRow.fromJson(Map<String, dynamic> json) =>
      _$ScheduleTargetRowFromJson(json);

  String get title => fullTitle.isNotEmpty ? fullTitle : targetTitle;
}
