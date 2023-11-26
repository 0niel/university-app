import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edu_program.g.dart';

/// {@template groups_response}
/// Информация об образовательной программе студента.
/// {@endtemplate}
@JsonSerializable()
class EduProgramInResposne extends Equatable {
  /// {@macro groups_response}
  const EduProgramInResposne({
    required this.eduProgram,
    required this.eduProgramCode,
    required this.department,
    required this.prodDepartment,
    required this.type,
  });

  /// Конвертирует `Map<String, dynamic>` в [EduProgramInResposne]
  factory EduProgramInResposne.fromJson(Map<String, dynamic> json) =>
      _$EduProgramFromJson(json);

  /// Название образовательной программы.
  final String eduProgram;

  /// Код образовательной программы. Например, "09.03.01".
  final String eduProgramCode;

  /// Институт.
  final String department;

  /// Выпускающее подразделение (кафедра).
  final String prodDepartment;

  /// Форма обучения. Например, "очная".
  final String? type;

  @override
  List<Object> get props => [
        eduProgram,
        eduProgramCode,
        department,
        prodDepartment,
      ];
}
