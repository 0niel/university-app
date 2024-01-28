import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'edu_program.dart';

part 'student.g.dart';

@JsonSerializable()
class Student extends Equatable {
  final String id;
  final bool isActive;
  final int course;
  final String personalNumber;
  final String educationStartDate;
  final String educationEndDate;
  final String academicGroup;
  final String code;
  final EduProgram eduProgram;
  final String status; // must be 'активный'

  const Student({
    required this.id,
    required this.isActive,
    required this.course,
    required this.personalNumber,
    required this.educationStartDate,
    required this.educationEndDate,
    required this.academicGroup,
    required this.code,
    required this.eduProgram,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  @override
  List<Object?> get props => [
        id,
        isActive,
        course,
        personalNumber,
        educationStartDate,
        educationEndDate,
        academicGroup,
        code,
        eduProgram,
        status,
      ];
}
