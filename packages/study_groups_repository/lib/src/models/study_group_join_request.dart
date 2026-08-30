import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_group_join_request.freezed.dart';
part 'study_group_join_request.g.dart';

@freezed
abstract class StudyGroupJoinRequest with _$StudyGroupJoinRequest {
  const factory StudyGroupJoinRequest({
    required String id,
    required String userId,
    required String fullName,
    String? handle,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt,
  }) = _StudyGroupJoinRequest;

  factory StudyGroupJoinRequest.fromJson(Map<String, Object?> json) =>
      _$StudyGroupJoinRequestFromJson(json);
}

DateTime? _dateFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

String? _dateToJson(DateTime? value) => value?.toUtc().toIso8601String();
