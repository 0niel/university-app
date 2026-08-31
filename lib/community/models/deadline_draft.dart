import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'deadline_draft.freezed.dart';

@freezed
abstract class DeadlineDraft with _$DeadlineDraft {
  const factory DeadlineDraft({
    required String title,
    required DateTime dueAt,
    required DeadlineSource source,
    @Default('') String subjectName,
    @Default(DeadlinePriority.medium) DeadlinePriority priority,
    @Default(true) bool remind,
  }) = _DeadlineDraft;
}
