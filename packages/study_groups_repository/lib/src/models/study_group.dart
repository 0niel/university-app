import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_group.freezed.dart';
part 'study_group.g.dart';

@freezed
abstract class StudyGroup with _$StudyGroup {
  const factory StudyGroup({
    required String id,
    required String name,
    @Default('🎓') String emoji,
    @Default('') String description,
    @Default('') String joinCode,
    @Default(true) bool isDiscoverable,
    @Default(0) int memberCount,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt,
  }) = _StudyGroup;

  factory StudyGroup.fromJson(Map<String, Object?> json) =>
      _$StudyGroupFromJson(json);
}

DateTime? _dateFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

String? _dateToJson(DateTime? value) => value?.toUtc().toIso8601String();
