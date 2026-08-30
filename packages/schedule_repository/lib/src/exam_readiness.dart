import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_readiness.freezed.dart';
part 'exam_readiness.g.dart';

@freezed
/// A student's normalized preparation progress for one subject.
abstract class ExamReadiness with _$ExamReadiness {
  /// Creates a readiness value with progress constrained by the input parser.
  const factory ExamReadiness({
    @JsonKey(name: 'subject_name') required String subjectName,
    required int readiness,
  }) = _ExamReadiness;

  /// Parses the canonical snake_case readiness payload returned by Supabase.
  factory ExamReadiness.fromJson(Map<String, dynamic> json) =>
      _$ExamReadinessFromJson({
        'subject_name': (json['subject_name'] ?? '').toString(),
        'readiness': switch (json['readiness']) {
          final num value => value.toInt().clamp(0, 100),
          final String value => (int.tryParse(value) ?? 0).clamp(0, 100),
          _ => 0,
        },
      });
}
