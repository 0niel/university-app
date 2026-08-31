import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_group_summary.freezed.dart';
part 'study_group_summary.g.dart';

@freezed
abstract class StudyGroupSummary with _$StudyGroupSummary {
  const factory StudyGroupSummary({
    required String id,
    required String name,
    @Default('🎓') String emoji,
    @Default('') String description,
    @Default(0) int memberCount,
    @Default('') String ownerName,
    @Default(false) bool hasRequested,
  }) = _StudyGroupSummary;

  factory StudyGroupSummary.fromJson(Map<String, Object?> json) =>
      _$StudyGroupSummaryFromJson(json);
}
