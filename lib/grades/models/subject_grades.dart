import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/grades/models/grade_mark.dart';

class SubjectGrades extends Equatable {
  const SubjectGrades({
    required this.subject,
    this.teacher = '',
    this.marks = const [],
  });

  factory SubjectGrades.fromJson(Map<String, Object?> json) => SubjectGrades(
    subject: json['subject']! as String,
    teacher: json['teacher'] as String? ?? '',
    marks: [
      for (final mark in json['marks'] as List<Object?>? ?? const [])
        GradeMark.fromJson(Map.from(mark! as Map<Object?, Object?>)),
    ],
  );

  static const riskThreshold = 3.5;
  static const newMarkWindow = Duration(days: 7);

  final String subject;
  final String teacher;
  final List<GradeMark> marks;

  double? get average => marks.isEmpty
      ? null
      : marks.fold<int>(0, (sum, mark) => sum + mark.value) / marks.length;

  bool get isRisk {
    final average = this.average;
    return average != null && average < riskThreshold;
  }

  bool isNew(DateTime now) =>
      marks.any((mark) => now.difference(mark.date) < newMarkWindow);

  SubjectGrades copyWith({
    String? teacher,
    List<GradeMark>? marks,
    String? subject,
  }) => SubjectGrades(
    teacher: teacher ?? this.teacher,
    marks: marks ?? this.marks,
    subject: subject ?? this.subject,
  );

  Map<String, Object?> toJson() => {
    'subject': subject,
    'teacher': teacher,
    'marks': [for (final mark in marks) mark.toJson()],
  };

  @override
  List<Object?> get props => [subject, teacher, marks];
}
