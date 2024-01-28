import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edu_program.g.dart';

@JsonSerializable()
class EduProgram extends Equatable {
  final String eduProgram;
  final String eduProgramCode;
  final String department;
  final String prodDepartment;
  final String? type;

  const EduProgram({
    required this.eduProgram,
    required this.eduProgramCode,
    required this.department,
    required this.prodDepartment,
    required this.type,
  });

  factory EduProgram.fromJson(Map<String, dynamic> json) => _$EduProgramFromJson(json);

  Map<String, dynamic> toJson() => _$EduProgramToJson(this);

  @override
  List<Object?> get props => [
        eduProgram,
        eduProgramCode,
        department,
        prodDepartment,
        type,
      ];
}
