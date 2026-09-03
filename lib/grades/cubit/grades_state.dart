import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/grades/models/models.dart';

enum GradesStatus { initial, loading, ready, failure }

class GradesState extends Equatable {
  const GradesState({
    this.status = GradesStatus.initial,
    this.book = const GradesBook(),
    this.terms = const [],
    this.termId = '',
    this.scheduleSubjects = const [],
    this.now,
  });

  static const deltaWindow = Duration(days: 30);

  final GradesStatus status;
  final GradesBook book;
  final List<GradesTerm> terms;
  final String termId;
  final List<SubjectGrades> scheduleSubjects;
  final DateTime? now;

  bool get isCurrentTerm => terms.isNotEmpty && terms.first.id == termId;

  List<SubjectGrades> get subjects {
    final stored = book.of(termId);
    if (!isCurrentTerm) return stored;
    final byName = {for (final subject in stored) subject.subject: subject};
    final merged = <SubjectGrades>[
      for (final subject in scheduleSubjects)
        byName
                .remove(subject.subject)
                ?.copyWith(
                  teacher: subject.teacher.isEmpty ? null : subject.teacher,
                ) ??
            subject,
      ...byName.values,
    ];
    return merged;
  }

  List<GradeMark> get _marks => [
    for (final subject in subjects) ...subject.marks,
  ];

  double? get gpa => _averageOf(_marks);

  double? get gpaDelta {
    final now = this.now;
    final gpa = this.gpa;
    if (now == null || gpa == null) return null;
    final cutoff = now.subtract(deltaWindow);
    final previous = _averageOf(
      _marks.where((mark) => !mark.date.isAfter(cutoff)).toList(),
    );
    return previous == null ? 0 : gpa - previous;
  }

  double? _averageOf(List<GradeMark> marks) => marks.isEmpty
      ? null
      : marks.fold<int>(0, (sum, mark) => sum + mark.value) / marks.length;

  GradesState copyWith({
    GradesStatus? status,
    GradesBook? book,
    List<GradesTerm>? terms,
    String? termId,
    List<SubjectGrades>? scheduleSubjects,
    DateTime? now,
  }) => GradesState(
    status: status ?? this.status,
    book: book ?? this.book,
    terms: terms ?? this.terms,
    termId: termId ?? this.termId,
    scheduleSubjects: scheduleSubjects ?? this.scheduleSubjects,
    now: now ?? this.now,
  );

  @override
  List<Object?> get props => [
    status,
    book,
    terms,
    termId,
    scheduleSubjects,
    now,
  ];
}
