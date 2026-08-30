part of 'exam_readiness_cubit.dart';

@freezed
abstract class ExamReadinessState with _$ExamReadinessState {
  const factory ExamReadinessState({
    @Default(<ExamReadiness>[]) List<ExamReadiness> entries,
    @Default(ExamReadinessStatus.initial) ExamReadinessStatus status,
  }) = _ExamReadinessState;

  const ExamReadinessState._();

  double readinessFor(String subjectName) {
    final entry = entries.firstWhereOrNull(
      (candidate) => candidate.subjectName == subjectName,
    );
    return (entry?.readiness ?? 0) / 100;
  }
}
