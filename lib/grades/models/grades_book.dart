import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/grades/models/subject_grades.dart';

class GradesBook extends Equatable {
  const GradesBook({this.terms = const {}, this.savedAt});

  factory GradesBook.fromJson(Map<String, Object?> json) {
    final rawTerms = json['terms'] as Map<Object?, Object?>? ?? const {};
    final savedAt = json['savedAt'] as String?;
    return GradesBook(
      terms: {
        for (final entry in rawTerms.entries)
          entry.key! as String: [
            for (final subject in entry.value! as List<Object?>)
              SubjectGrades.fromJson(
                Map.from(subject! as Map<Object?, Object?>),
              ),
          ],
      },
      savedAt: savedAt == null ? null : DateTime.parse(savedAt),
    );
  }

  final Map<String, List<SubjectGrades>> terms;
  final DateTime? savedAt;

  List<SubjectGrades> of(String termId) => terms[termId] ?? const [];

  GradesBook withTerm(
    String termId,
    List<SubjectGrades> subjects, {
    required DateTime updatedAt,
  }) => GradesBook(terms: {...terms, termId: subjects}, savedAt: updatedAt);

  Map<String, Object?> toJson() => {
    'terms': {
      for (final entry in terms.entries)
        entry.key: [for (final subject in entry.value) subject.toJson()],
    },
    'savedAt': savedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [terms, savedAt];
}
